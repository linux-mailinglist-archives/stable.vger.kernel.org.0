Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5AAF989C
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLS2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfKLS2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:28:17 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57940206B6;
        Tue, 12 Nov 2019 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583295;
        bh=MdlejGXBScK+hxH3YQa6yeXUfe+PDdNuxToJcwsKtbE=;
        h=Subject:To:From:Date:From;
        b=JUNZQhCUpxEqyeJObFEuhgUBsZsk1ihp3z6DxW3X/AXUtLY6/1cRGf9yXSNE4MBkl
         sLo2f9wr/K1tn6LqVDkaqMMoKQEBq0BO+5d9waltxgrn0ifv74M8f37seQMmsvoOXD
         0KV6at8aF4Jm1yIJXX5Mipef6P8QujkYWGd7i5+U=
Subject: patch "USBIP: add config dependency for SGL_ALLOC" added to usb-next
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Nov 2019 19:25:01 +0100
Message-ID: <157358310123228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USBIP: add config dependency for SGL_ALLOC

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1ec13abac58b6f24e32f0d3081ef4e7456e62ed8 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 12 Nov 2019 16:49:39 +0100
Subject: USBIP: add config dependency for SGL_ALLOC

USBIP uses lib/scatterlist.h
Hence it needs to set CONFIG_SGL_ALLOC

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20191112154939.21217-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/usbip/Kconfig b/drivers/usb/usbip/Kconfig
index 2f86b28fa3da..7bbae7a08642 100644
--- a/drivers/usb/usbip/Kconfig
+++ b/drivers/usb/usbip/Kconfig
@@ -4,6 +4,7 @@ config USBIP_CORE
 	tristate "USB/IP support"
 	depends on NET
 	select USB_COMMON
+	select SGL_ALLOC
 	---help---
 	  This enables pushing USB packets over IP to allow remote
 	  machines direct access to USB devices. It provides the
-- 
2.24.0


