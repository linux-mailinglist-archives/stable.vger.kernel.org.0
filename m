Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B7BC2D75
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJAGYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 02:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfJAGYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 02:24:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A7A21783;
        Tue,  1 Oct 2019 06:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569911053;
        bh=qLQ5mOq+EECMPJMq4/f0dFNIkOPoiwCQPyuVQAIcdCA=;
        h=Subject:To:From:Date:From;
        b=FnE3q5fb1YavEYE5/2DMejijmVwkrfZyBaIu7mGi5r7GlcEh9K28nN8iSNa2XMOKs
         ddwiitoHGLbIn6XG5Aj88M8gH0Q/WTgGLBjy0hmqP3drbOJ/vunl3DzVmF3vYkrZUn
         sVD6m2tF7DYazunGJh6sYwajkTjSzH5a8AltCLTA=
Subject: patch "staging/fbtft: Depend on OF" added to staging-linus
To:     noralf@tronnes.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Oct 2019 08:24:00 +0200
Message-ID: <15699110408181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging/fbtft: Depend on OF

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 63f2b1677fba11c5bd02089f25c13421948905f5 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Date: Tue, 17 Sep 2019 19:18:41 +0200
Subject: staging/fbtft: Depend on OF
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor
interface") removed setting gpios via platform data. This means that
fbtft will now only work with Device Tree so set the dependency.

This also prevents a NULL pointer deref on non-DT platform because
fbtftops.request_gpios is not set in that case anymore.

Fixes: c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor interface")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://lore.kernel.org/r/20190917171843.10334-1-noralf@tronnes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fbtft/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/Kconfig b/drivers/staging/fbtft/Kconfig
index 8ec524a95ec8..4e5d860fd788 100644
--- a/drivers/staging/fbtft/Kconfig
+++ b/drivers/staging/fbtft/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 menuconfig FB_TFT
 	tristate "Support for small TFT LCD display modules"
-	depends on FB && SPI
+	depends on FB && SPI && OF
 	depends on GPIOLIB || COMPILE_TEST
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
-- 
2.23.0


