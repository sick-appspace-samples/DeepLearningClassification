
local function runInference(dnn, image, image_path)
  dnn:setInputImage(image) -- Prepare image for prediction
  local result = dnn:predict() -- Run prediction using the trained network

  -- Parse the result as a classification output
  local predicted_class_idx, predicted_score, predicted_label = result:getAsClassification()
  print(
      string.format(
          "Image %s was classified as class number %i: '%s' with score %0.2f",
          image_path,
          predicted_class_idx,
          predicted_label,
          predicted_score
      )
  )

  -- Show text with color depending on classification result
  local pass = predicted_class_idx > 0
  local g = pass and 255 or 0
  local r = pass and 0 or 255
  local textDecoration = View.TextDecoration.create()
  textDecoration:setPosition(5, 12)
  textDecoration:setColor(r, g, 0)

  -- Display the image
  local viewer = View.create()
  viewer:addImage(image)
  viewer:addText(predicted_label, textDecoration)
  viewer:present("ASSURED")

  -- Wait one second
  Script.sleep(1000)
end

local function main()
  -- Load a network from resources
  local net = Object.load("resources/SolderJoint_check_appspace.json") -- This will be a MachineLearning.DeepNeuralNetwork.Model instance
  -- Create an inference engine instance
  local dnn = MachineLearning.DeepNeuralNetwork.create()
  dnn:setModel(net) -- Load the neural network into the engine
  -- ... Load/Create your images ...
  local imageDir = "resources/images" -- Directory path of images
  local imagePaths = File.listRecursive(imageDir) -- List of images

  for _, imagePath in ipairs(imagePaths) do -- For each image
    local image = Image.load(imageDir .. '/' .. imagePath) -- Load image
    runInference(dnn, image, imagePath)
  end

end
Script.register("Engine.OnStarted", main)
-- serve API in global scope
