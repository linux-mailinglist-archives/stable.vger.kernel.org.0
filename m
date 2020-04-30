Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E081BF250
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD3IL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 04:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgD3IL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 04:11:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833FBC035495
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 01:11:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f13so5649439wrm.13
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 01:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2o2Fztfk5W//D3bO+bVikVHBouyFoiJ2j9CyC6fkXWQ=;
        b=OU5l9pzjK2RQxM/eLRsv2chYFmymKQ5mxvF6GfOCys0Xtnj05P4pcSm6uR6bGUDa5P
         UTBh9te0UCO3ieR/1G4plJHfDbekvivY22NAHTT4GQGdU5yIZg+Qrfr1ZsZ7iwEyzFyI
         bfsPbs+2NFYLl/hgTX7ixpfR5v1314z90YVHVHBwhAIbk+sEaCbCERIuzQGY+7iMlNRL
         wWH+u4FfSBG6j7/NmbmpJni6XO3kmQlTF1c3kE6lnfVAl9WhWfDj0CaVx8+GeL9Hq/O6
         2owMONvh/MqWiGdeWn/U5Pq+pCVpwFB93zlr3xOg39sX0xVvx8yAAwpeNgMy6x1v/aGv
         MbWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=2o2Fztfk5W//D3bO+bVikVHBouyFoiJ2j9CyC6fkXWQ=;
        b=Q+lQPNAbRsdarLjc2K5ajy30tnDxT27flBw4TDxAixHQdfVImsHDt0Zymwo38oAkkG
         ytZv0xXHBBPBWP5/FamymwvhGLfeeNehZk3V6tnORF7CT2DLIYCJCAzhtPOi18YXDnJx
         UdwHNkfBRbkNKYDIrpI/JcOv3+oix8tfc+AVgeC+sWR7xrFt4M1pm0Wsi5LVYdQdD/dy
         fJuxBzDr29cMEeJPHha/zsXh79wn0GxSGKRBfJOrIvZx/5y9cVmJ/A2Zul15Q7z1oJop
         LsEYKSwsDRZ0zUgY6SLCSaQ04kG04Mmit3SB8chp+jsGF1VL5lQmZtPkeTTxZmdVWIhw
         B9Mw==
X-Gm-Message-State: AGi0PuaAZHkozdBY/1mAFfGhKJFTfxF5D1h8xNL+D+Y8wnhBzjuFNixe
        0xB/STTN4dlggdVt7rhza8jSaQ==
X-Google-Smtp-Source: APiQypILYB6i3OfitZOpjN+VgEPWdREhEKMt8Kth4moHZ+k3RT3PZah4rsctCqNQ9LdsMEwFt0izSw==
X-Received: by 2002:adf:b310:: with SMTP id j16mr2555234wrd.95.1588234282987;
        Thu, 30 Apr 2020 01:11:22 -0700 (PDT)
Received: from localhost (nat-35.starnet.cz. [178.255.168.35])
        by smtp.gmail.com with ESMTPSA id 74sm2992078wrk.30.2020.04.30.01.11.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Apr 2020 01:11:22 -0700 (PDT)
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com, stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [PATCH] tty: xilinx_uartps: Add the id to the console
Date:   Thu, 30 Apr 2020 10:11:21 +0200
Message-Id: <06195dc0effe2fb82e264e4faefcfdd6ebc00516.1588234277.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

Update the console index. Once the serial node is found update it to the
console index.

Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Greg: Would be good if you can take this patch to 5.7 and also to stable
trees.
---
 drivers/tty/serial/xilinx_uartps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 672cfa075e28..b9d672af8b65 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1465,6 +1465,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 		cdns_uart_uart_driver.cons = &cdns_uart_console;
+		cdns_uart_console.index = id;
 #endif
 
 		rc = uart_register_driver(&cdns_uart_uart_driver);
-- 
2.26.2

