Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58F9167477
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgBUIVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:21:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388244AbgBUIVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:21:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DFF20578;
        Fri, 21 Feb 2020 08:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273295;
        bh=j16pgwVUMftoF8YYXdrZkZvYgZV4vM+pB4OKieUtnF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ty34iHWFqoNfZt08HxFRkZ2HSzqhRkDvFf77PVOmva/CkXXgjKcBEMXyiQLm6J7R4
         dGtKtyLg+EhEldRf2h6RhP2zPSC0z0ty6mlCq1KtUyv0lZdaUHhjyntnyf9VDfEqmh
         k6Xi+t5ZdyzBScfOaTTgK6w2GsDVdzFbWqZJw7lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/191] tty: synclinkmp: Adjust indentation in several functions
Date:   Fri, 21 Feb 2020 08:41:29 +0100
Message-Id: <20200221072304.813234464@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 1feedf61e7265128244f6993f23421f33dd93dbc ]

Clang warns:

../drivers/tty/synclinkmp.c:1456:3: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
        if (C_CRTSCTS(tty)) {
        ^
../drivers/tty/synclinkmp.c:1453:2: note: previous statement is here
        if (I_IXOFF(tty))
        ^
../drivers/tty/synclinkmp.c:2473:8: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
                                                info->port.tty->hw_stopped = 0;
                                                ^
../drivers/tty/synclinkmp.c:2471:7: note: previous statement is here
                                                if ( debug_level >= DEBUG_LEVEL_ISR )
                                                ^
../drivers/tty/synclinkmp.c:2482:8: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
                                                info->port.tty->hw_stopped = 1;
                                                ^
../drivers/tty/synclinkmp.c:2480:7: note: previous statement is here
                                                if ( debug_level >= DEBUG_LEVEL_ISR )
                                                ^
../drivers/tty/synclinkmp.c:2809:3: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
        if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
        ^
../drivers/tty/synclinkmp.c:2807:2: note: previous statement is here
        if (I_INPCK(info->port.tty))
        ^
../drivers/tty/synclinkmp.c:3246:3: warning: misleading indentation;
statement is not part of the previous 'else' [-Wmisleading-indentation]
        set_signals(info);
        ^
../drivers/tty/synclinkmp.c:3244:2: note: previous statement is here
        else
        ^
5 warnings generated.

The indentation on these lines is not at all consistent, tabs and spaces
are mixed together. Convert to just using tabs to be consistent with the
Linux kernel coding style and eliminate these warnings from clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/823
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20191218024720.3528-1-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/synclinkmp.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 1e4d5b9c981a4..57c2c647af61e 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -1454,10 +1454,10 @@ static void throttle(struct tty_struct * tty)
 	if (I_IXOFF(tty))
 		send_xchar(tty, STOP_CHAR(tty));
 
- 	if (C_CRTSCTS(tty)) {
+	if (C_CRTSCTS(tty)) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals &= ~SerialSignal_RTS;
-	 	set_signals(info);
+		set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 }
@@ -1483,10 +1483,10 @@ static void unthrottle(struct tty_struct * tty)
 			send_xchar(tty, START_CHAR(tty));
 	}
 
- 	if (C_CRTSCTS(tty)) {
+	if (C_CRTSCTS(tty)) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals |= SerialSignal_RTS;
-	 	set_signals(info);
+		set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 }
@@ -2471,7 +2471,7 @@ static void isr_io_pin( SLMP_INFO *info, u16 status )
 					if (status & SerialSignal_CTS) {
 						if ( debug_level >= DEBUG_LEVEL_ISR )
 							printk("CTS tx start...");
-			 			info->port.tty->hw_stopped = 0;
+						info->port.tty->hw_stopped = 0;
 						tx_start(info);
 						info->pending_bh |= BH_TRANSMIT;
 						return;
@@ -2480,7 +2480,7 @@ static void isr_io_pin( SLMP_INFO *info, u16 status )
 					if (!(status & SerialSignal_CTS)) {
 						if ( debug_level >= DEBUG_LEVEL_ISR )
 							printk("CTS tx stop...");
-			 			info->port.tty->hw_stopped = 1;
+						info->port.tty->hw_stopped = 1;
 						tx_stop(info);
 					}
 				}
@@ -2807,8 +2807,8 @@ static void change_params(SLMP_INFO *info)
 	info->read_status_mask2 = OVRN;
 	if (I_INPCK(info->port.tty))
 		info->read_status_mask2 |= PE | FRME;
- 	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
- 		info->read_status_mask1 |= BRKD;
+	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
+		info->read_status_mask1 |= BRKD;
 	if (I_IGNPAR(info->port.tty))
 		info->ignore_status_mask2 |= PE | FRME;
 	if (I_IGNBRK(info->port.tty)) {
@@ -3178,7 +3178,7 @@ static int tiocmget(struct tty_struct *tty)
  	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
+	get_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	result = ((info->serial_signals & SerialSignal_RTS) ? TIOCM_RTS : 0) |
@@ -3216,7 +3216,7 @@ static int tiocmset(struct tty_struct *tty,
 		info->serial_signals &= ~SerialSignal_DTR;
 
 	spin_lock_irqsave(&info->lock,flags);
- 	set_signals(info);
+	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	return 0;
@@ -3228,7 +3228,7 @@ static int carrier_raised(struct tty_port *port)
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
+	get_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	return (info->serial_signals & SerialSignal_DCD) ? 1 : 0;
@@ -3244,7 +3244,7 @@ static void dtr_rts(struct tty_port *port, int on)
 		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
 		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
- 	set_signals(info);
+	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
-- 
2.20.1



