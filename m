Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B7210E7D2
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfLBJmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:42:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36596 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfLBJmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:42:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so16487207wma.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jREQE+bGMWZ83hzSZ5R/u/Tew5kuKbz+yZnyyRL8Mxk=;
        b=IGN84s0uxjaWmLDhTnJYDej5ZRNPztH/bYRmY9K+D/B2sD+b/YNAg/Np9rC1IEOHnf
         zbvjYKGJDSbtW4N4c7K3ur1j8sXPE6d4CG1vwLi2wxypabCEzgmwu9xuZx7b9zUGDmnf
         sdVAluFnyXtkZvQZ5FgIKxGN+LXW4QRjLlAAI5vvImeUwQC1SR2HUhMx+6HoZz3L0/oi
         DSZf6QfJluXU9/khwmh7m0VxWdbEzB3hUARzXnHHUWgZBo7aIwTrw9CebHeRsJtgckGl
         47/ySt0N2vjMSl8rjxaT87B83gszvzzHDvQFhcp9gzxvj6oDfsugPsYdiZjUnqWL6v+u
         LpqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jREQE+bGMWZ83hzSZ5R/u/Tew5kuKbz+yZnyyRL8Mxk=;
        b=ftJ1jxe4uYjEgzatY/HqsYXfUaAG1aZ+Xp1eZyQnRAn8SnEvssZdxaVYtOTob43DSu
         Q/nXf7/VKVaKTnooGV0fqy1Lrsf0GjyKjYl/pMK4/CMuLHuQWwzc9+AzcqBkHu6zYmDb
         A/hTy6WwKyIRdPsbTiban7mcOSLHLQr+WVZdFT7tgHrx1QGqRUfEyiuCrxqt1pjYB2Hf
         82VVGy+N/cwfWSNbvRKF757Z1aLn86mhZxmqnvqdXOHmXF+dx4rmIg+5cJns0rlr24Kx
         lDlIGf+nc/R3oz7f5x0nK+AHaOLEMGLhhA6IOZLKiKL+QUhAJVOgIh56I/Fr79zzOhIm
         6KKQ==
X-Gm-Message-State: APjAAAWEaPUbcqk9lRJDbBiA5fV6ejpL+7ixZ5rwZP//ND6aDEKCuOW1
        AQtHhg8wg0AHwslxxnnzyQMwks/ey8g=
X-Google-Smtp-Source: APXvYqwI739JBhH5I9Xnpf2bVxeK3Zn5SCCAkH9KiLh7h/hF/rdDL0gxEQuBHvGuNKx0jdRx6SB4jw==
X-Received: by 2002:a05:600c:218f:: with SMTP id e15mr8437939wme.124.1575279729352;
        Mon, 02 Dec 2019 01:42:09 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id w8sm990381wmm.0.2019.12.02.01.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:42:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 1/4] arm: add missing include platform-data/atmel.h
Date:   Mon,  2 Dec 2019 09:41:47 +0000
Message-Id: <20191202094150.32485-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philippe Mazenauer <philippe.mazenauer@outlook.de>

[ Upstream commit 95701b1c3c8fe36368361394e3950094eece4723 ]

Include corresponding headerfile <linux/platform-data/atmel.h> for
function at91_suspend_entering_slow_clock().

../arch/arm/mach-at91/pm.c:279:5: warning: no previous prototype for ‘at91_suspend_entering_slow_clock’ [-Wmissing-prototypes]
 int at91_suspend_entering_slow_clock(void)
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Philippe Mazenauer <philippe.mazenauer@outlook.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-at91/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 84eefbc2b4f9..983a313bdbaf 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk/at91_pmc.h>
+#include <linux/platform_data/atmel.h>
 
 #include <asm/irq.h>
 #include <linux/atomic.h>
-- 
2.24.0

