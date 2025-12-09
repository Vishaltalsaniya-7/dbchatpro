// using System;
// using System.Collections.Generic;
// using System.Threading;
// using System.Threading.Tasks;
// using Amazon.BedrockRuntime;
// using Amazon.BedrockRuntime.Model;
// using Microsoft.Extensions.AI;

// public sealed class AWSBedrockClient : IChatClient, IDisposable
// {
//     private readonly IAmazonBedrockRuntime _bedrockClient;
//     private readonly string _modelId;

//     // Constructor
//     public AWSBedrockClient(IAmazonBedrockRuntime bedrockClient, string modelId)
//     {
//         _bedrockClient = bedrockClient ?? throw new ArgumentNullException(nameof(bedrockClient));
//         _modelId = modelId ?? throw new ArgumentNullException(nameof(modelId));
//     }

//     public void Dispose()
//     {
//         _bedrockClient?.Dispose();
//     }

//     public async Task<ChatResponse> GetResponseAsync(
//         IEnumerable<ChatMessage> messages,
//         ChatOptions? options = null,
//         CancellationToken cancellationToken = default)
//     {
//         var bedRockMessages = new List<Message>();

//         foreach (var message in messages)
//         {
//             bedRockMessages.Add(new Message
//             {
//                 Role = ConversationRole.User,
//                 Content = new List<ContentBlock>
//                 {
//                     new ContentBlock { Text = message.Text }
//                 }
//             });
//         }

//         var request = new ConverseRequest
//         {
//             ModelId = _modelId,
//             Messages = bedRockMessages
//         };

//         try
//         {
//             var response = await _bedrockClient.ConverseAsync(request, cancellationToken);

//             return new ChatResponse(new[]
//             {
//                 new ChatMessage(ChatRole.Assistant, response.Output.Message.Content[0].Text)
//             });
//         }
//         catch (AmazonBedrockRuntimeException e)
//         {
//             return new ChatResponse(new[]
//             {
//                 new ChatMessage(ChatRole.Assistant, $"ERROR: Can't invoke '{_modelId}'. Reason: {e.Message}")
//             });
//         }
//     }

//     public object? GetService(Type serviceType, object? serviceKey = null)
//     {
//         throw new NotImplementedException();
//     }

//     public IAsyncEnumerable<ChatResponseUpdate> GetStreamingResponseAsync(
//         IEnumerable<ChatMessage> messages,
//         ChatOptions? options = null,
//         CancellationToken cancellationToken = default)
//     {
//         throw new NotImplementedException();
//     }
// }

using System.Runtime.CompilerServices;
using Amazon.SecurityToken;
using Amazon.BedrockRuntime;
using Amazon.BedrockRuntime.Model;
using Azure;
using Microsoft.Extensions.AI;

public sealed class AWSBedrockClient(
    IAmazonBedrockRuntime bedrockClient, string modelId) : IChatClient
{
    public void Dispose()
    {
        throw new NotImplementedException();
    }

    public async Task<ChatResponse> GetResponseAsync(IEnumerable<ChatMessage> messages, ChatOptions? options = null, CancellationToken cancellationToken = default)
    {
        var bedRockMessages = new List<Message>();

        // Convert MEAI messages into Bedrock messages
        foreach (var message in messages)
        {
            bedRockMessages.Add(new Message
            {
                Role = ConversationRole.User,
                Content = new List<ContentBlock> { new ContentBlock { Text = message.Text } }
            });
        }

        // Create a request with the model ID and messages
        var request = new ConverseRequest
        {
            ModelId = modelId,
            Messages = bedRockMessages
        };

        try
        {
            // Send the request to the Bedrock Runtime and wait for the result.
            var response = await bedrockClient.ConverseAsync(request);

            // Convert the result to MEAI types
            return new([new ChatMessage(ChatRole.Assistant, response.Output.Message.Content[0].Text)]);
        }
        catch (AmazonBedrockRuntimeException e)
        {
            // Convert the result to MEAI types
            return new([new ChatMessage(ChatRole.Assistant, $"ERROR: Can't invoke '{modelId}'. Reason: {e.Message}")]);
        }
    }

    // These aren't needed by the app
    public object? GetService(Type serviceType, object? serviceKey = null)
    {
        throw new NotImplementedException();
    }

    // These aren't needed by the app
    public IAsyncEnumerable<ChatResponseUpdate> GetStreamingResponseAsync(IEnumerable<ChatMessage> messages, ChatOptions? options = null, CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }
}