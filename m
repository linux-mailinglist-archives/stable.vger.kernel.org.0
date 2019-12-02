Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4974410E820
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLBKDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:51 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34984 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfLBKDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:51 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so11355564wro.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AJBi3Wx4dc8N0SQvfeVCMhWPD/cyEKNjvF5LH/jG1lQ=;
        b=Hzi3syw7fGa86cv/mmyMTIeCiZ6euZMw5IG/N9olmez/KI+7/ApDBxxVl9ns3KZTc/
         xPBnZ9Uw4/0IFlgabTj1SqFDnW1kZSo658qHkrtlSjTpCjtnfRS/nSHmE0P91uqjvPEp
         27DntP2zFBUziHe7kQiNYoKKL84N50QiMKwfVPZ6df5BAi7C/WawAh5zebSeR93FfD92
         Tw68WwZifgBPxq/xcg8VxWP+pN68YjpikZ4LYUzUF0MMU6UQmAlNQ4y3tQYMCyIBRir+
         PfPy1Av/8E9u37cqnL9gNQFYXKTxYjKr/c7CcRGAt9MVDlOZguPQmQs29KT4m5Xk0gmE
         taDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJBi3Wx4dc8N0SQvfeVCMhWPD/cyEKNjvF5LH/jG1lQ=;
        b=JBK0IVa1yEdQCVv+vojyBKLIBxzX1BX9Pg0NHI+1EOnX44mwmVfW8OErgCVDV8eM0o
         SzcWeKPYx2PMJF5Me/Sx16z2ksUsZeCda7Cceh0RXhaTLBfc4lPFXRRQGgZEoI2nVHSa
         y9mJ5Pxq4bNbvkXM5M02IePdfmSfiG8bsl8sxCrC4e1X41hxndwzn6u8m9/bcyRHgkvV
         /1HC3yPJFFTyjpJIMeP2O03rjeG1snZPtx4nZQT2L7VZWCid0+6d7KO7ee6L7Xb6fLeb
         CEhO9j7XAvNbVgQLlKN38SxhUgtZhn0g9LkvwsazmRePYGWWiNA64RwMSc5EtGWiw/HB
         uMiA==
X-Gm-Message-State: APjAAAVVRihmI1KTK2pdRUILm1EVgc7DS1nb8v0TwGPF3mo4FaxJJh0v
        nDC9HRTiIcL4WZOeIlLQntqLXb2Erv8=
X-Google-Smtp-Source: APXvYqwmkH3CrM8YEY/c/oC5uT06GHrwzlAPSj13a3+65GZKf2Hwen8QyHl/etBJwSLIyH678VJkfA==
X-Received: by 2002:adf:e303:: with SMTP id b3mr52723850wrj.335.1575281028827;
        Mon, 02 Dec 2019 02:03:48 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:48 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 02/14] arm: add missing include platform-data/atmel.h
Date:   Mon,  2 Dec 2019 10:03:00 +0000
Message-Id: <20191202100312.1397-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
index 849014c01cf4..796182e33361 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -19,6 +19,7 @@
 #include <linux/suspend.h>
 
 #include <linux/clk/at91_pmc.h>
+#include <linux/platform_data/atmel.h>
 
 #include <asm/cacheflush.h>
 #include <asm/fncpy.h>
-- 
2.24.0

