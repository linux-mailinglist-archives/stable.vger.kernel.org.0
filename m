Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C51E3CE0
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgE0I6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388370AbgE0I6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 04:58:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00282078C;
        Wed, 27 May 2020 08:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590569928;
        bh=1dXGt3ssHLZZEZks9PKXhvO12R5uTxPOsT/IAGBMTHA=;
        h=Subject:To:From:Date:From;
        b=DUoUvg5T+3OcDbQWjVZ5wSDlZpxT8fluKvVDq2zeaZVcDdKyLq687o66/e78fTg2T
         leIqLnRAb/ggP8ZsLMiw3GzWxN9oyoAZGjkZ1bNYoUzcGQNyqOa2XxLfcinlCmkIR/
         2nhp+61AXc+cGofvRoLNpnRsUvjPXpVI4RdmS4Y4=
Subject: patch "serial: 8250: Enable 16550A variants by default on non-x86" added to tty-testing
To:     josh@joshtriplett.org, fido_max@inbox.ru,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        vladimir.oltean@nxp.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 May 2020 10:58:38 +0200
Message-ID: <1590569918140245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250: Enable 16550A variants by default on non-x86

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 15a3f03d5ec0118f1e5db3fc1018686e72744e37 Mon Sep 17 00:00:00 2001
From: Josh Triplett <josh@joshtriplett.org>
Date: Tue, 26 May 2020 09:13:57 -0700
Subject: serial: 8250: Enable 16550A variants by default on non-x86

Some embedded devices still use these serial ports; make sure they're
still enabled by default on architectures more likely to have them, to
avoid rendering someone's console unavailable.

Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reported-by: Maxim Kochetkov <fido_max@inbox.ru>
Fixes: dc56ecb81a0a ("serial: 8250: Support disabling mdelay-filled probes of 16550A variants")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: https://lore.kernel.org/r/a20b5fb7dd295cfb48160eecf4bdebd76332d67d.1590509426.git.josh@joshtriplett.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index af0688156dd0..8195a31519ea 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -63,6 +63,7 @@ config SERIAL_8250_PNP
 config SERIAL_8250_16550A_VARIANTS
 	bool "Support for variants of the 16550A serial port"
 	depends on SERIAL_8250
+	default !X86
 	help
 	  The 8250 driver can probe for many variants of the venerable 16550A
 	  serial port. Doing so takes additional time at boot.
-- 
2.26.2


