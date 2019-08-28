Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E73A0BD6
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfH1UtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfH1UtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:49:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9F622DA7;
        Wed, 28 Aug 2019 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567025352;
        bh=hjF/zcjuSYDnvE3QFrMmjL8CIPlWMrWt5TIv51y13G0=;
        h=Subject:To:From:Date:From;
        b=ppfKB/CwxYcd0OcVY+R4fDGSvDDt/6i8XQUqfNUNPXQgCPEVcSf3/7saWvnrUZdPY
         2vgNvQUSPAiEUdZiKXce1Uk7Sh5a6f92CzsHvn0UQLPxEQJEtc8oCYMXmxwL2RmIMr
         jPV7JfEYqrkJtvhQKkUywpoHlOylB4r1XHOn+MhU=
Subject: patch "usb: host: xhci: rcar: Fix typo in compatible string matching" added to usb-linus
To:     geert+renesas@glider.be, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:48:59 +0200
Message-ID: <15670253397613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci: rcar: Fix typo in compatible string matching

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 636bd02a7ba9025ff851d0cfb92768c8fa865859 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Tue, 27 Aug 2019 14:51:12 +0200
Subject: usb: host: xhci: rcar: Fix typo in compatible string matching

It's spelled "renesas", not "renensas".

Due to this typo, RZ/G1M and RZ/G1N were not covered by the check.

Fixes: 2dc240a3308b ("usb: host: xhci: rcar: retire use of xhci_plat_type_is()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20190827125112.12192-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-rcar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 8616c52849c6..2b0ccd150209 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -104,7 +104,7 @@ static int xhci_rcar_is_gen2(struct device *dev)
 	return of_device_is_compatible(node, "renesas,xhci-r8a7790") ||
 		of_device_is_compatible(node, "renesas,xhci-r8a7791") ||
 		of_device_is_compatible(node, "renesas,xhci-r8a7793") ||
-		of_device_is_compatible(node, "renensas,rcar-gen2-xhci");
+		of_device_is_compatible(node, "renesas,rcar-gen2-xhci");
 }
 
 static int xhci_rcar_is_gen3(struct device *dev)
-- 
2.23.0


