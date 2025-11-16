from django.http import HttpResponse


def hello_world(request):
    """Simple hello world view."""
    return HttpResponse("""
    <html>
        <head>
            <title>Hello World</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                }
                .container {
                    text-align: center;
                    background: white;
                    padding: 40px;
                    border-radius: 10px;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                }
                h1 {
                    color: #333;
                    margin-bottom: 20px;
                }
                p {
                    color: #666;
                    font-size: 18px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Lesson 8 & 9</h1>
                <p>This lesson contains Jenkins & ArgoCD!</p>
            </div>
        </body>
    </html>
    """)

