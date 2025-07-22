import anthropic
client = anthropic.Anthropic()
msg = client.messages.create(
    model="claude-3.5-sonnet-20240620",
    max_tokens=100,
    messages=[{"role": "user", "content": "Tell me a joke"}]
)
print(msg.content[0].text)
