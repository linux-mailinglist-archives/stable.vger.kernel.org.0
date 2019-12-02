Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD5210E8E0
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLBKbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32887 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfLBKbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so13899130wrq.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zr96crpOCB+hjaopjnY9IA7TtFLCsfoyTiLDSqWQNJg=;
        b=Aw3QF6HOx+SsIWiQr5Xl6wFB7jA+iNUAyGUkJxS+gRXwEY9969iYx56wYgECkhtAI1
         He4wl/brIOVkuzGmKRGNWrJPLfQ2kH22pGZrSj4xxILirRZH3cG5/a3R07FxMYrpKUh+
         z413P2ahOsqK2FvBDKSN/F7x3ktlkate51PQTHaelgU0yQLHps2RWzeo14/kwNbIV57+
         xxWD/8XWWZYcfUO+e7Ujep6MPkP3Y6+JCoHqf9NHY5Ean95+3CHmiuSKOj6MGJijnHYH
         0HYjb8KHtXoug5L5/Ul36psvpxNxNbQG6oRVA2UJ8kg5vOj9LLdthtWIkUw2WYvK+JSM
         4gMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zr96crpOCB+hjaopjnY9IA7TtFLCsfoyTiLDSqWQNJg=;
        b=nIFYg7NmQarLOBCUdxYFG6j++55hJutSKhDh+JooDKDwzFre8vqNrbtGR5ibE1MpSs
         HSleXQFSR6oz0bFkv+IkqbgItQW5M8om14auSs4BT0ez28QeevXmKuRQNgIwWny4YLqu
         rJbpbsLhMJysBRHVlsM4MO8tMBbbtOIBHSkqps+urQU8Gr+PQv583FdI9fG20pfx8iSF
         tbWx2D/GTKsA72ystpX1pZ5k3W1/NQjCn307bC29bpFjteyjBsw+VGPpe20R2YTjNZnw
         Oy10N6GlXh25A/QKm93UWjPmcvC9xay2taHYBk6CcJ3IIYpyIfqMdbnM+6Pih4A35A2A
         Ebtw==
X-Gm-Message-State: APjAAAUqmcRXdPxbpd80auFXTgmTBufz/9IFm7rhz6dFVRgzNHJTumZl
        lo0ocexbin9ApUMcr7x0OywKizuFxcU=
X-Google-Smtp-Source: APXvYqy3srGYPUN8hAHoPvxM/st2dTxRtdyL1JL2/okP/+GjKuVDgYAKInWwLsvBzLfSWDu6igKq0Q==
X-Received: by 2002:a5d:5403:: with SMTP id g3mr16765783wrv.302.1575282663783;
        Mon, 02 Dec 2019 02:31:03 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 02/15] arm: add missing include platform-data/atmel.h
Date:   Mon,  2 Dec 2019 10:30:37 +0000
Message-Id: <20191202103050.2668-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
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
index e2e4df3d11e5..b4a9ac3061b4 100644
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

