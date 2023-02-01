Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE79D686D4D
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjBARoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 12:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBARo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 12:44:28 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557E77E050;
        Wed,  1 Feb 2023 09:44:26 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id bb40so10326366qtb.2;
        Wed, 01 Feb 2023 09:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B3nHzRGVx2G3Ad+A+UdBuuCyovh9u8R6IqbxmPGl7MA=;
        b=QzoRbBSb+IrC/Nz+pNHzFO+ml6X4xctJi5BpEvWZ50IWM4sJkXsBJKcpdiw+Rxg6vs
         Kralllqz7OJACrzejGyLVM94lg6BChUSBk4CKWnXS5GtkHCwut27F8+JbAmYuFT2CCgG
         pZ1zia9Phs8YjpNQI+uu3o6+eigAzb2/rD8kte3k83kcDVBD52fkQRmjD2aSZ5kmvusY
         lCkWqQeAw38IlnH5Bs8HxguRbgeiNpsUc1a5iE0JwCACiq4uT7r6HEy8DUBZGHZwa1Jf
         g52TtMqKBRQQI8PgOA6D05Fi+9uJ7O4oYfCWv+Po5E7UPa/MPDB6HTJcU2isl4+c2aA7
         ZQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B3nHzRGVx2G3Ad+A+UdBuuCyovh9u8R6IqbxmPGl7MA=;
        b=vystSdCfv+yrIaXtokIwJePWUyDErHn+Sp+rvaj058Y+dq5wkLM37sXzZK9ErYJPp4
         9hXAYLIxSC5t4TL7x+5jVmmCxAFCf83yAqr45KKA91t+w8ZeZTNlaGyjmOCIGwfdSXi7
         dQ26fQWHvwZY4bFcFdNPmeoCJkBdmh+gukx6/LuxVsJWt60o08udvbvVBstYKivaKSpF
         fvELjJtPASl6HGihnAi4h1+2DrzXyPrutIGSkGAiAP37G61xoaW+oJGKkEWPGipGy6ah
         rukMyWbhrbTDnEynepxOAHp/oXa/qjFJUdQef3oJbyRr7I6uTOYCv4Y4r+KzE633lXYB
         C2QQ==
X-Gm-Message-State: AO0yUKXbsjFbbsucMLYOtfdP+SbmnylW/7qD1P7sG5z0cZqDTrjyXxKo
        Ykbx3fvmfxg7mbKZoQmX2Vnyo7ftNGCSdA==
X-Google-Smtp-Source: AK7set+BDeB0Jpasg90Lz9FJ5tXDwXZufQadJtdbMWnchYWGQq3GBEVYMSsGxW/GZ+xJyvSvs6iaFw==
X-Received: by 2002:a05:622a:241:b0:3b8:696b:95e9 with SMTP id c1-20020a05622a024100b003b8696b95e9mr6284012qtx.47.1675273465337;
        Wed, 01 Feb 2023 09:44:25 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f23-20020ac80157000000b003b868cdc689sm6681784qtg.5.2023.02.01.09.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 09:44:23 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        linux-usb@vger.kernel.org (open list:USB XHCI DRIVER)
Subject: [PATCH stable 5.4] usb: host: xhci-plat: add wakeup entry at sysfs
Date:   Wed,  1 Feb 2023 09:44:04 -0800
Message-Id: <20230201174404.32777-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201174404.32777-1-f.fainelli@gmail.com>
References: <20230201174404.32777-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit  4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream

With this change, there will be a wakeup entry at /sys/../power/wakeup,
and the user could use this entry to choose whether enable xhci wakeup
features (wake up system from suspend) or not.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 84cfa8544285..fa320006b04d 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -276,7 +276,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			*priv = *priv_match;
 	}
 
-	device_wakeup_enable(hcd->self.controller);
+	device_set_wakeup_capable(&pdev->dev, true);
 
 	xhci->main_hcd = hcd;
 	xhci->shared_hcd = __usb_create_hcd(driver, sysdev, &pdev->dev,
-- 
2.34.1

