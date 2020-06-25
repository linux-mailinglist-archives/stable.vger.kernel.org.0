Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41979209A0A
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390207AbgFYGrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390162AbgFYGqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:35 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10876C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:35 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h15so4597882wrq.8
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PPkLe9A2c/a37hUly+zrhj0g8oPWNS5BWdFQdlxMTw8=;
        b=L97XwVALwtGB8lb0Ydl/Uxoxe8raykVlOYBYqzU4heUsw5RqxnPa3z8xLxPGWvfAbA
         plswBX//r6jz0dXg4KLn3wKD4CaHKrhY7iF7sZeT+RbpUrmY42yepOoZx+MVPjI225VO
         nNLGFSiojX+A97815KN5agb2E/kLbUdBcCIdOvBxdrbFrtff1TdCLeB8peWn7SoyItYh
         +VcxpYleMeIQH9oOuZf7wTN5wh42l2Ev54zBug8m3GmfyWSt07q2LFyenksyBaHsSM77
         EfhCIV6FZbyzHXCZ9HClXrK8R8qZxKM4nHdlXz4ut6uL1CY+62i4UYro1xNOXDO4L9dY
         IyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PPkLe9A2c/a37hUly+zrhj0g8oPWNS5BWdFQdlxMTw8=;
        b=nnsgwF8OkxCDB01knv4vQt5ARWI4zSHzuM6mJiHzsxhwlO0ZEPLjL5pvtfiTJLDanc
         zv49w4byz0BMfTvSCv41XgQk98HYlRpuaGsfnQ8GFsl7ddnhidhXkuQT3LVVLrymuQbk
         3nrcjH/Fq3Yfc9LpYaUljtfC0H2uWM0RWSle0nB1Bno3LKVPbLwl18ZcJPjXf8Ud7hVo
         cOjgwFQ8lOX6j5Jf9LIBQdyk1zU7jGgYdpI2MjLlATCzoCYDibY4gE6qYl0+QoqHVm55
         HnYtUl1OKBWgi3pnZuwCw5OpHulu8WDQ6HRb44qeL/t4/20Gf5FxHLVZ8lL4Zuf8lSdb
         xIZg==
X-Gm-Message-State: AOAM532rTpP/E1MHb+tQOTQLlhjUWbvEiqBGq37VIhTCYHmgryAL0eMa
        zeXJVL0IPZ+Vwoisptoh85W2Tg==
X-Google-Smtp-Source: ABdhPJx0uw9TCSRR+V93tjiW3ToHdg6Sqq5aiNebHk420Mimxl1+ayhEO9bw8440/cK3hU1Save1sw==
X-Received: by 2002:adf:f54b:: with SMTP id j11mr19439037wrp.206.1593067593835;
        Wed, 24 Jun 2020 23:46:33 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        Roger Quadros <rogerq@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH 07/10] mfd: omap-usb-tll: Provide description for 'pdev' argument to .probe()
Date:   Thu, 25 Jun 2020 07:46:16 +0100
Message-Id: <20200625064619.2775707-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kerneldoc syntax is used, but not complete.  Arg descriptions required.

Prevents warnings like:

 drivers/mfd/omap-usb-tll.c:204: warning: Function parameter or member 'pdev' not described in 'usbtll_omap_probe

Cc: <stable@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/omap-usb-tll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 4b7f73c317e87..04a444007cf4e 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -199,6 +199,8 @@ static unsigned ohci_omap3_fslsmode(enum usbhs_omap_port_mode mode)
  * usbtll_omap_probe - initialize TI-based HCDs
  *
  * Allocates basic resources for this USB host controller.
+ *
+ * @pdev: Pointer to this device's platform device structure
  */
 static int usbtll_omap_probe(struct platform_device *pdev)
 {
-- 
2.25.1

