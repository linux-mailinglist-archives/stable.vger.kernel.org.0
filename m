Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620C23A7F1B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhFONYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 09:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhFONYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 09:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C016661468;
        Tue, 15 Jun 2021 13:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623763339;
        bh=02/Q73809IehkjomT9VtgHcAl2mCWI3mA2IgrNh15ak=;
        h=Subject:To:From:Date:From;
        b=y2LyRpq++Zb5YASHXmaD0b4Kteogw/iYI+DClNoX2SwYAmG7yzwdIZg9H1ZgD6k+K
         dejJNWhb7ur7VY+qsr+cjsqP8VTEom1ycx+VcwQBkhViMIK/XqVGhpeEM4tCqOrzyN
         T96OmzQEbbdpe7bYh9aaxzIyBQSzTfKoQNzwUAEY=
Subject: patch "serial_cs: Add Option International GSM-Ready 56K/ISDN modem" added to tty-testing
To:     linux@zary.sk, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Jun 2021 15:22:08 +0200
Message-ID: <1623763328254114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial_cs: Add Option International GSM-Ready 56K/ISDN modem

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 674b5396576b636a1ff101f692935748388c7325 Mon Sep 17 00:00:00 2001
From: Ondrej Zary <linux@zary.sk>
Date: Fri, 11 Jun 2021 22:19:40 +0200
Subject: serial_cs: Add Option International GSM-Ready 56K/ISDN modem

Add support for Option International GSM-Ready 56K/ISDN PCMCIA modem
card.

Signed-off-by: Ondrej Zary <linux@zary.sk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210611201940.23898-2-linux@zary.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/serial_cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 2f1d33ea26e1..dc2ef05a10eb 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -786,6 +786,7 @@ static const struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Multi-Tech", "MT2834LT", 0x5f73be51, 0x4cd7c09e),
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
 	PCMCIA_DEVICE_PROD_ID12("Option International", "V34bis GSM/PSTN Data/Fax Modem", 0x9d7cd6f5, 0x5cb8bf41),
+	PCMCIA_DEVICE_PROD_ID12("Option International", "GSM-Ready 56K/ISDN", 0x9d7cd6f5, 0xb23844aa),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),
-- 
2.32.0


