<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | HRSync</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="login-body">

<div class="login-container">
    <!-- LEFT SIDE: Login Form -->
    <div class="login-left">
        <div class="login-content">
            <!-- Brand Header -->
            <div class="login-brand">
                <div class="brand-icon">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="16" cy="16" r="14" fill="url(#grad)"/>
                        <path d="M16 8V24M10 14H22" stroke="white" stroke-width="2" stroke-linecap="round"/>
                        <defs>
                            <linearGradient id="grad" x1="0" y1="0" x2="32" y2="32">
                                <stop offset="0%" style="stop-color:#8EC5FF;stop-opacity:1" />
                                <stop offset="100%" style="stop-color:#CDB4FF;stop-opacity:1" />
                            </linearGradient>
                        </defs>
                    </svg>
                </div>
                <div>
                    <h1 class="brand-name">HRSync</h1>
                    <p class="brand-subtitle">Enterprise HR Management</p>
                </div>
            </div>

            <h2 class="login-title">Welcome Back</h2>
            <p class="login-subtitle">Sign in to your account to continue</p>

            <!-- Error Alert -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="login-alert alert-error">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <!-- Login Form -->
            <form class="login-form" action="<%= request.getContextPath() %>/login" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                            <polyline points="22,6 12,13 2,6"></polyline>
                        </svg>
                        <input type="email" id="email" name="email" placeholder="your@email.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <div class="password-header">
                        <label for="password">Password</label>
                        <a href="<%= request.getContextPath() %>/forgot-password" class="forgot-link">Forgot?</a>
                    </div>
                    <div class="input-wrapper">
                        <svg class="input-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="password" name="password" placeholder="••••••••" required>
                    </div>
                </div>

                <div class="form-group checkbox">
                    <input type="checkbox" id="remember" name="remember" value="true">
                    <label for="remember">Remember me for 30 days</label>
                </div>

                <button type="submit" class="btn-login">
                    <span>Sign In</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </button>
            </form>

            <!-- Security Badges -->
            <div class="security-badges">
                <div class="badge">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <span>SSL Secured</span>
                </div>
                <div class="badge">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                        <polyline points="2 12 12 17 22 12"></polyline>
                        <polyline points="2 17 12 22 22 17"></polyline>
                    </svg>
                    <span>GDPR Compliant</span>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT SIDE: Quote & Branding -->
    <div class="login-right">
        <div class="decoration decoration-1"></div>
        <div class="decoration decoration-2"></div>
        <div class="decoration decoration-3"></div>

        <div class="quote-container">
            <div class="quote-mark">"</div>
            <blockquote class="quote-text">
                Great team performance starts with great people management. Empower your team with tools that matter.
            </blockquote>
            <p class="quote-author">— HRSync Philosophy</p>
            
            <div class="stats-bar">
                <div class="stat">
                    <div class="stat-number">10K+</div>
                    <div class="stat-label">Companies</div>
                </div>
                <div class="stat">
                    <div class="stat-number">2M+</div>
                    <div class="stat-label">Employees</div>
                </div>
                <div class="stat">
                    <div class="stat-number">99.9%</div>
                    <div class="stat-label">Uptime</div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
