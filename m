Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D45110E7EF
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfLBJue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43612 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfLBJue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so43370802wra.10
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/muS7s9GcBWwOiQ2nT4NrXkQLoaaxRJ0Am/sFjK2n1M=;
        b=V/lZvx6f6F9UM+nPQihXQJR8mZqDE4wggRiB6PXai3RWE/cS7t7Nt/lejvngIUxqyy
         HKdq4pKYAk0o6xNRt6LCazEZToaB7cytOQW6FdykXAMod1jSyKKZIvzKM5RjB8p4SudS
         yCEZtjpe1dFkzO+9ygez17VJq91s4ksMayYny119cF31rNYVuSvSIDodg5hJWYPv2jRB
         +QnRk0AIjajJfqLWxvkCjreqUs1vJkqDLJ4ypizP98IIDd4ueHsjC5ekCcM0b28LX4sP
         ys47Qu2devSayhUW/SbpU9/L1j0y8OIyKMGgktSsrjpujGlcGYKsY41RrjpCsopXttTj
         AofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/muS7s9GcBWwOiQ2nT4NrXkQLoaaxRJ0Am/sFjK2n1M=;
        b=q4e/ktyIydt5/ATcmd9WklCC6DxcpbFt9BBeVUWp5FUf7VRq4zAX6MILvBVNBxNEBw
         KvyPTYoH/Zo1+gC22ymKnOKeI6jgDIDASZKafODW0zurYpxRir0Y0oyIlOTU3FgFC0Ht
         C3/yN+KGOfFH3qG1KtrXj187px3fLCqK40mzFOsIneVnVlyTo06RyAY48s1Nw6GAeDbP
         NzXFmOSDXI6z6kKkYjzliQFpweFMdfaAQAzjyzHj8Uj2mbI7KOzRqvM2IKEbLgM4T3ap
         uUP4CDZ5CONpW+qQVRbNv9Qw9rS2HPraukOFDotu5xYBOi7ERQ/1mHKPK7zN56BYVwfq
         uFqA==
X-Gm-Message-State: APjAAAXYhGpppTNPrw4tadnZakABw/6nE+uDlEnWDy+euSZPgUREz4Nz
        cy/+5a/4WA+cFsPAawoix7jcKkcpMv0=
X-Google-Smtp-Source: APXvYqwvl2xqmUNwNY+XvN4LzqZ7WYPJ7Hx0I8zdiRK9LrUVHyDruLgXwySbCY9REmWI6+qbprv65A==
X-Received: by 2002:a5d:4281:: with SMTP id k1mr31389590wrq.72.1575280230588;
        Mon, 02 Dec 2019 01:50:30 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id l3sm4629698wrt.29.2019.12.02.01.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:50:30 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 2/6] arm: add missing include platform-data/atmel.h
Date:   Mon,  2 Dec 2019 09:50:08 +0000
Message-Id: <20191202095012.559-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202095012.559-1-lee.jones@linaro.org>
References: <20191202095012.559-1-lee.jones@linaro.org>
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
index 8ba0e2e5ad97..3091c3817d9d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -25,6 +25,7 @@
 #include <linux/platform_data/atmel.h>
 #include <linux/io.h>
 #include <linux/clk/at91_pmc.h>
+#include <linux/platform_data/atmel.h>
 
 #include <asm/irq.h>
 #include <linux/atomic.h>
-- 
2.24.0

