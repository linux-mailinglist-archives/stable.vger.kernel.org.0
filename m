Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B39F556FB6
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 03:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiFWBGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 21:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377389AbiFWBFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 21:05:42 -0400
X-Greylist: delayed 389 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Jun 2022 18:05:40 PDT
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE6BF42EE0
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 18:05:40 -0700 (PDT)
Received: from gw2.atmark-techno.com (localhost [127.0.0.1])
        by gw2.atmark-techno.com (Postfix) with ESMTP id 1085920D68
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:59:11 +0900 (JST)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id C773220D68
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:59:10 +0900 (JST)
Received: by mail-pf1-f197.google.com with SMTP id x123-20020a626381000000b005254d5e6a0fso798974pfb.5
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 17:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0+ou3720DKjkpl8odzY3MuihKdCms8PcP2mgDCRsYs=;
        b=7f1QM7oBXyA4hk8dVnSD4rgRXT6sFu9TVh2Fi10Oe27naVg7cIK0YXFjGsjuQzwhD7
         06xAD/p9uQOGOxKS79jUeaUcyMxcPMEoG8BBl11KUKry23MDUV4VNHbagRrUGSrdKclh
         +Dlo5tM05fs9nDST6XLrYrKLSUIFSBg5LjRR7vjc285wOt8+AD8LJzs2wHjwaxbHbjtQ
         wZVMkbtur+FsDZf+5Ntr6e/pYsmZ9eunoTJrdPIy+Cwe9zAxlPMKBnqAnSHIou0OW1bR
         1XVSrdy6JQnNSp3dCXLtDn3I3c7+Yi06+6d3m12a+t3Se2D81v24R6PdS2TNXymTbQX+
         +LtQ==
X-Gm-Message-State: AJIora/F4aAfSAjw3QjrM9BujCs0FGc2M3w+V+SLVOqwn0ayDMsQiCia
        RGQO2M6mcgamn/KW76wAf6cwBcOhkc1SAtGP8GcCMxsv8dsl4hBOOSEyIlTvxCkg3HukmhlYQlF
        OHFhShaLUoeYwiWhb3Q==
X-Received: by 2002:a17:903:32c4:b0:16a:4201:45e4 with SMTP id i4-20020a17090332c400b0016a420145e4mr7931986plr.108.1655945949699;
        Wed, 22 Jun 2022 17:59:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uXjmTdC2yfp7bSN6v74gky3liGSaqnK083JA6q/kEnwem8wGcG8Vvzx/jFMUBa4nB+OOb3qw==
X-Received: by 2002:a17:903:32c4:b0:16a:4201:45e4 with SMTP id i4-20020a17090332c400b0016a420145e4mr7931973plr.108.1655945949409;
        Wed, 22 Jun 2022 17:59:09 -0700 (PDT)
Received: from pc-zest.atmarktech (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id e13-20020a17090301cd00b0015e8d4eb1d2sm13714602plh.28.2022.06.22.17.59.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jun 2022 17:59:09 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o4BBb-0080K0-TJ;
        Thu, 23 Jun 2022 09:59:07 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH v5.10] serial: core: Initialize rs485 RTS polarity already on probe
Date:   Thu, 23 Jun 2022 09:58:58 +0900
Message-Id: <20220623005858.1907788-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Core part of commit 2dd8a74fddd21b95dcc60a2d3c9eaec993419d69 upstream:
the PL011 driver does not support RS485 in the 5.10 tree yet so drop
that bit.

RTS polarity of rs485-enabled ports is currently initialized on uart
open via:

tty_port_open()
  tty_port_block_til_ready()
    tty_port_raise_dtr_rts()  # if (C_BAUD(tty))
      uart_dtr_rts()
        uart_port_dtr_rts()

There's at least three problems here:

First, if no baud rate is set, RTS polarity is not initialized.
That's the right thing to do for rs232, but not for rs485, which
requires that RTS is deasserted unconditionally.

Second, if the DeviceTree property "linux,rs485-enabled-at-boot-time" is
present, RTS should be deasserted as early as possible, i.e. on probe.
Otherwise it may remain asserted until first open.

Third, even though RTS is deasserted on open and close, it may
subsequently be asserted by uart_throttle(), uart_unthrottle() or
uart_set_termios() because those functions aren't rs485-aware.
(Only uart_tiocmset() is.)

To address these issues, move RTS initialization from uart_port_dtr_rts()
to uart_configure_port().  Prevent subsequent modification of RTS
polarity by moving the existing rs485 check from uart_tiocmget() to
uart_update_mctrl().

That way, RTS is initialized on probe and then remains unmodified unless
the uart transmits data.  If rs485 is enabled at runtime (instead of at
boot) through a TIOCSRS485 ioctl(), RTS is initialized by the uart
driver's ->rs485_config() callback and then likewise remains unmodified.

The PL011 driver initializes RTS on uart open and prevents subsequent
modification in its ->set_mctrl() callback.  That code is obsoleted by
the present commit, so drop it.

Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Su Bao Cheng <baocheng.su@siemens.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/2d2acaf3a69e89b7bf687c912022b11fd29dfa1e.1642909284.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # 5.10
Reported-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Tested-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
Notes:
 - as said in commit message, I've dropped the PL011 part of the
original patch as it is orthogonal to this change. We need this
serial core fix for the imx serial tty driver.

- I wasn't really sure what to do with tags in the commit message,
everything below the 'Cc: stable' tag apply to the backport:
Mizobuchi-san tested the backport on the 5.10 branch with the imx
driver.

- I'm not quite sure how far back it is relevant, for imx I assume
rs485 is broken since 58362d5be352 ("serial: imx: implement handshaking
using gpios with the mctrl_gpio helper") (4.5), and we did have that
problem all the way back in our older 4.9 product tree... but core
support back then wasn't as extensive for RS485 so we have a different
imx specific workaround there.

 - I do not use 5.15 but either version of this patch apply cleanly
there; I'd assume it'd be more appropriate to get the original
2dd8a74fddd21b cherry-picked in this case for 5.15.

Thanks!


 drivers/tty/serial/serial_core.c | 34 +++++++++++---------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 19f0c5db11e3..32d09d024f6c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -144,6 +144,11 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	unsigned long flags;
 	unsigned int old;
 
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		set &= ~TIOCM_RTS;
+		clear &= ~TIOCM_RTS;
+	}
+
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
@@ -157,23 +162,10 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 
 static void uart_port_dtr_rts(struct uart_port *uport, int raise)
 {
-	int rs485_on = uport->rs485_config &&
-		(uport->rs485.flags & SER_RS485_ENABLED);
-	int RTS_after_send = !!(uport->rs485.flags & SER_RS485_RTS_AFTER_SEND);
-
-	if (raise) {
-		if (rs485_on && RTS_after_send) {
-			uart_set_mctrl(uport, TIOCM_DTR);
-			uart_clear_mctrl(uport, TIOCM_RTS);
-		} else {
-			uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
-		}
-	} else {
-		unsigned int clear = TIOCM_DTR;
-
-		clear |= (!rs485_on || RTS_after_send) ? TIOCM_RTS : 0;
-		uart_clear_mctrl(uport, clear);
-	}
+	if (raise)
+		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+	else
+		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
 /*
@@ -1116,11 +1108,6 @@ uart_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
 		goto out;
 
 	if (!tty_io_error(tty)) {
-		if (uport->rs485.flags & SER_RS485_ENABLED) {
-			set &= ~TIOCM_RTS;
-			clear &= ~TIOCM_RTS;
-		}
-
 		uart_update_mctrl(uport, set, clear);
 		ret = 0;
 	}
@@ -2429,6 +2416,9 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
+		if (port->rs485.flags & SER_RS485_ENABLED &&
+		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
+			port->mctrl |= TIOCM_RTS;
 		port->ops->set_mctrl(port, port->mctrl);
 		spin_unlock_irqrestore(&port->lock, flags);
 
-- 
2.35.1

