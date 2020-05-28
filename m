Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F6B1E5856
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 09:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgE1HTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 03:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE1HTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 03:19:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18E120899;
        Thu, 28 May 2020 07:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590650358;
        bh=D7gcpPZHWbvOqyin3e7Zk+J7UaDkauetCbJN0w1Kvxo=;
        h=Subject:To:From:Date:From;
        b=wvfAy8qHYjP8CNxCv1Lmy3NEu1o5MufFSfOTb9JzyUUB84R7AUqMzXROduwO4MLF5
         pGDvf+xsBJepXyJEwCdUdDSEMqo1V3aJFW0m3tKvAGQEdEVNk1UhZ2IndtywFcHYxj
         RaZp2LSUaj0JwtH+1cey6unnjQQIwwZeEd3JfT+E=
Subject: patch "serial: 8250: Enable 16550A variants by default on non-x86" added to tty-next
To:     josh@joshtriplett.org, fido_max@inbox.ru,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        vladimir.oltean@nxp.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 May 2020 09:19:08 +0200
Message-ID: <1590650348184173@kroah.com>
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
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


