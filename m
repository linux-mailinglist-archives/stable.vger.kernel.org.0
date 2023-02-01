Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECF686D47
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 18:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjBARoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 12:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjBARoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 12:44:21 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34A22D5F;
        Wed,  1 Feb 2023 09:44:19 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id g7so1939825qto.11;
        Wed, 01 Feb 2023 09:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0grifz9oyU58374EdScY3NpybfPtk3g+WDr7VXFF15k=;
        b=R8cgjkJ9K6RB/P7cY+kyT0nYrGhg/J7hCkQdazFYGDEqtDAe38PggKOEoXIeTWavj+
         JhVyTEAMvuT7d2YRzcNj64BK2vYcNUsIOiFVb7WoMmD9uQTMVclMVNauC6x7p7r93R0z
         VdIji2IHoB+aCCrPA/a3phZddBzlA85AOrnNjEE2cS3HIukuUcsKlgYQBNaY6mq6PoOw
         SdCElwgzCgYs0iC3lMx38pHsLVBrXjrn21P+DgnZZvgRUoexebhqWkHnjj69aYc4pDpp
         A9TCk1zCXrAV/V4tPOVEtGE1SaB5q+2N/AqMNhQ1ZM6IePMjfSysShtZ1clHnJgqfUrK
         5j5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0grifz9oyU58374EdScY3NpybfPtk3g+WDr7VXFF15k=;
        b=I2EA0Z9EO4QNVmmdGscRFvJmyLqWKi8E6cAhzr2Vo2VHGQ3kNSnSQjxa8cuJAgPoEV
         jaqLQheeQTRZSPiKLF+xrJVddZAvgNDmfCuH/PfA5vpNJt1eccNfRrkWzNpvtt7uena3
         JxggimI/RgcZwpLQWANxhCSjPhf6qK7H5SxWcW4ilv0xoOhPqILG8/9ltjD53Zx8Hgg4
         GBsCeQQbA21ldudSBwF2bs9joE+AwXuernVhOUf2l7/S4OCkRUjvFDbsiF8oMkXwd9q9
         +OV0AONHnl3J9gVNUZpjAqYweRZIjLDESGGqbLWLwPcFwRP1xubJ5UVTFnzmrvvG8MNE
         NthQ==
X-Gm-Message-State: AO0yUKXHOYWpqADsepXfkJJp6nOSJTWHcDoFM2zhReHT0Y58ndcz06pO
        LjqauQBDNEuO+WnfxZ2WGa0EsmsEsgpysA==
X-Google-Smtp-Source: AK7set8ClY4Osb1Wp19ezjIbCkAEdc8H96qba4/SjoW8MbiYJU+201JCIx+2udG1IXW3um8xRtgs/A==
X-Received: by 2002:ac8:5f52:0:b0:3b9:bdb0:7aa1 with SMTP id y18-20020ac85f52000000b003b9bdb07aa1mr3215892qta.41.1675273458214;
        Wed, 01 Feb 2023 09:44:18 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f23-20020ac80157000000b003b868cdc689sm6681784qtg.5.2023.02.01.09.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 09:44:14 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        linux-usb@vger.kernel.org (open list:USB XHCI DRIVER)
Subject: [PATCH stable 4.14] usb: host: xhci-plat: add wakeup entry at sysfs
Date:   Wed,  1 Feb 2023 09:44:02 -0800
Message-Id: <20230201174404.32777-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
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

commit 4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream

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
index 2a73592908e1..3d20fe9c415f 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -252,7 +252,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			*priv = *priv_match;
 	}
 
-	device_wakeup_enable(hcd->self.controller);
+	device_set_wakeup_capable(&pdev->dev, true);
 
 	xhci->clk = clk;
 	xhci->main_hcd = hcd;
-- 
2.34.1

