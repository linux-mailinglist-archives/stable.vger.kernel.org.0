Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E92A9964
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgKFQX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgKFQXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 11:23:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A739221556;
        Fri,  6 Nov 2020 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604679805;
        bh=496OuYRpkO4PfdSyjyboKB5B8KFXgRcdT1mAkzn+W+A=;
        h=Subject:To:From:Date:From;
        b=w6QJ2zxrA46UEbvTVufZrEkQrEiXAeI3u7h5AxMCxHxWf0fmqdMZ8U+QpYMG80/ZT
         C4SSTX+Dj2RQKfLAsfqCaOxZ7Qn0TJxxC7vKjIqJ06KYC+xzJM44Z9C94ifHb+KdMo
         /+qReflM+4glcO4PCrKePpSdONiL1UZJR3OUlp90=
Subject: patch "tty: serial: imx: enable earlycon by default if IMX_SERIAL_CONSOLE is" added to tty-linus
To:     l.stach@pengutronix.de, festevam@gmail.com, fugang.duan@nxp.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Nov 2020 17:24:03 +0100
Message-ID: <16046798439530@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: imx: enable earlycon by default if IMX_SERIAL_CONSOLE is

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 427627a23c3e86e31113f9db9bfdca41698a0ee5 Mon Sep 17 00:00:00 2001
From: Lucas Stach <l.stach@pengutronix.de>
Date: Thu, 5 Nov 2020 21:40:26 +0100
Subject: tty: serial: imx: enable earlycon by default if IMX_SERIAL_CONSOLE is
 enabled

Since 699cc4dfd140 (tty: serial: imx: add imx earlycon driver), the earlycon
part of imx serial is a separate driver and isn't necessarily enabled anymore
when the console is enabled. This causes users to loose the earlycon
functionality when upgrading their kenrel configuration via oldconfig.

Enable earlycon by default when IMX_SERIAL_CONSOLE is enabled.

Fixes: 699cc4dfd140 (tty: serial: imx: add imx earlycon driver)
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20201105204026.1818219-1-l.stach@pengutronix.de
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 1044fc387691..28f22e58639c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -522,6 +522,7 @@ config SERIAL_IMX_EARLYCON
 	depends on OF
 	select SERIAL_EARLYCON
 	select SERIAL_CORE_CONSOLE
+	default y if SERIAL_IMX_CONSOLE
 	help
 	  If you have enabled the earlycon on the Freescale IMX
 	  CPU you can make it the earlycon by answering Y to this option.
-- 
2.29.2


