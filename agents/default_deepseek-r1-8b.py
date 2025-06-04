from langchain_ollama import ChatOllama
from browser_use import Agent, BrowserConfig
from dotenv import load_dotenv
load_dotenv()
import asyncio

llm = ChatOllama(model="phi4:14b")

async def main():
    # Configure browser to fix sandboxing issue
    browser_config = BrowserConfig(
        headless=True,
        extra_browser_args=[
            '--no-sandbox',
            '--disable-dev-shm-usage',
            '--disable-setuid-sandbox'
        ]
    )
    
    agent = Agent(
        task="Imagine that you are a real human, and that you have access to a computer. Perform real actions on that computer such as making searches on google, browsing youtube, and shopping online. You can imagine you are any gender. Make sure to take breaks and sleep.",
        llm=llm,
        browser_config=browser_config
    )
    result = await agent.run()
    print(result)

asyncio.run(main())
