Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA92FABA9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 21:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbhARUhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 15:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388362AbhARUhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 15:37:43 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44906C061573;
        Mon, 18 Jan 2021 12:37:03 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o10so530364wmc.1;
        Mon, 18 Jan 2021 12:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bboy8q8yCb3CXA4OuN2BVHMC9Xj9kSrm5bXm2ResfTM=;
        b=bUgTpVP7aHNIjpv38JtT0nZQS31CA9g72VWw9Kbc2EOnI2yMOfSoz0qjN35T7SJYlR
         GrO36oJKZcZ6lx3XE06rTdoxXBJxrmb+ViB4EufosdNFubDcEDcIZhW7I5dboUBKuZSu
         9/fnZpJZxHQMWxFjNponNTEMol2NsDwQLKKGxIXKJyC+zg3j5GemaMiI+OU4XFefgfP3
         D1Ku6LBBDJnqnXYAwue9bWsIB/sgMuYTJTf0HKHSwDjyfq14rBjrJBg9K64qZWAYXOV1
         IUse059AmAZ6NMC7Cu9BYJHbLKzhZl37T9k3tUPHH7d/WqHXtumZwFwSbIW+wed3SbGq
         Yysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bboy8q8yCb3CXA4OuN2BVHMC9Xj9kSrm5bXm2ResfTM=;
        b=SWvq7DhzynBaQonrjcxnDDMuYjjDYPrKlv29cjhFzFqpgHAnwvZmg4prLmGFpEMzJF
         bvEHPxbB/HeYArgGqcdMddgCmPsoJ4FRZOwUD23Vj+Id/MZIUa2wLA2fjSDObMzAKcGw
         CoptxJMi2SrHJN8o9d73TSHvdOWQTClJlymSarwIUY7hSWqT5t6zAD9/LKz8Fh2Xgpta
         6pvey+43n3QOg97MJ6jijTMyXVmnhtXHtHsLjwLjMF245oku3tYoBLlaE3w3CLJkFBbM
         qCPOXPWg+4Y2WjJ4VCppQ8G2jXx3vEVlJxVsyYyG7dTJ1yl2z4xZUAQEhCFLAatEZWdT
         iXvA==
X-Gm-Message-State: AOAM532JT9964X38W82T4E3DwFmTGQL1yeX9IqtaCZwheUvRZ+hQKmTs
        Q2fXeO1CY9gO+8u+G+d0S7viIuqeOwRoWA==
X-Google-Smtp-Source: ABdhPJyiFKyrUcs1D0eYc1RQ7M3PXQnM9lFRTrdIhH9yB6ouIFYyDPYIS8O4e5r1d3EZZIaVtwnY3Q==
X-Received: by 2002:a1c:a549:: with SMTP id o70mr961415wme.71.1611002221677;
        Mon, 18 Jan 2021 12:37:01 -0800 (PST)
Received: from workstation.suse.de (81-229-85-231-no13.tbcn.telia.com. [81.229.85.231])
        by smtp.gmail.com with ESMTPSA id q15sm31631237wrw.75.2021.01.18.12.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:37:01 -0800 (PST)
From:   Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Al Cooper <alcooperx@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] usb: bdc: Make bdc pci driver depend on BROKEN
Date:   Mon, 18 Jan 2021 21:36:15 +0100
Message-Id: <20210118203615.13995-1-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bdc pci driver is going to be removed due to it not existing in the
wild. This patch turns off compilation of the driver so that stable
kernels can also pick up the change. This helps the out-of-tree
facetimehd webcam driver as the pci id conflicts with bdc.

Cc: Al Cooper <alcooperx@gmail.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/usb/gadget/udc/bdc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/bdc/Kconfig b/drivers/usb/gadget/udc/bdc/Kconfig
index 3e88c7670b2e..fb01ff47b64c 100644
--- a/drivers/usb/gadget/udc/bdc/Kconfig
+++ b/drivers/usb/gadget/udc/bdc/Kconfig
@@ -17,7 +17,7 @@ if USB_BDC_UDC
 comment "Platform Support"
 config	USB_BDC_PCI
 	tristate "BDC support for PCIe based platforms"
-	depends on USB_PCI
+	depends on USB_PCI && BROKEN
 	default USB_BDC_UDC
 	help
 		Enable support for platforms which have BDC connected through PCIe, such as Lego3 FPGA platform.
-- 
2.29.2

