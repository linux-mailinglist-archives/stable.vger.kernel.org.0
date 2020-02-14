Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECBD15F14C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388328AbgBNSBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387713AbgBNP4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F6B24654;
        Fri, 14 Feb 2020 15:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695776;
        bh=qe91vsZl+bETNV5aGSCLwyygrLUCbqOnEPRe1+9FlF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csEYfO49MJGa2CRVNnauvl5AG+zRf/JjhNuOM7iMF7aP0TQog5T2j84EQSwiylbXq
         WbDFR+FSJRj295NOhNzTFbE6TSKTACMfmx9sMcigsocORuNW00hgh0FAA1Gcz1YDBK
         t+lYLY1tIXWhG8oFrpqbv6ESAVkDl+mypgKS2tqQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.5 341/542] tty: synclink_gt: Adjust indentation in several functions
Date:   Fri, 14 Feb 2020 10:45:33 -0500
Message-Id: <20200214154854.6746-341-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 446e76873b5e4e70bdee5db2f2a894d5b4a7d081 ]

Clang warns:

../drivers/tty/synclink_gt.c:1337:3: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
        if (C_CRTSCTS(tty)) {
        ^
../drivers/tty/synclink_gt.c:1335:2: note: previous statement is here
        if (I_IXOFF(tty))
        ^
../drivers/tty/synclink_gt.c:2563:3: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
        if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
        ^
../drivers/tty/synclink_gt.c:2561:2: note: previous statement is here
        if (I_INPCK(info->port.tty))
        ^
../drivers/tty/synclink_gt.c:3221:3: warning: misleading indentation;
statement is not part of the previous 'else' [-Wmisleading-indentation]
        set_signals(info);
        ^
../drivers/tty/synclink_gt.c:3219:2: note: previous statement is here
        else
        ^
3 warnings generated.

The indentation on these lines is not at all consistent, tabs and spaces
are mixed together. Convert to just using tabs to be consistent with the
Linux kernel coding style and eliminate these warnings from clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/822
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20191218023912.13827-1-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/synclink_gt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index e8a9047de4516..36f1a4d870eb1 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1334,10 +1334,10 @@ static void throttle(struct tty_struct * tty)
 	DBGINFO(("%s throttle\n", info->device_name));
 	if (I_IXOFF(tty))
 		send_xchar(tty, STOP_CHAR(tty));
- 	if (C_CRTSCTS(tty)) {
+	if (C_CRTSCTS(tty)) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->signals &= ~SerialSignal_RTS;
-	 	set_signals(info);
+		set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 }
@@ -1359,10 +1359,10 @@ static void unthrottle(struct tty_struct * tty)
 		else
 			send_xchar(tty, START_CHAR(tty));
 	}
- 	if (C_CRTSCTS(tty)) {
+	if (C_CRTSCTS(tty)) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->signals |= SerialSignal_RTS;
-	 	set_signals(info);
+		set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
 }
@@ -2560,8 +2560,8 @@ static void change_params(struct slgt_info *info)
 	info->read_status_mask = IRQ_RXOVER;
 	if (I_INPCK(info->port.tty))
 		info->read_status_mask |= MASK_PARITY | MASK_FRAMING;
- 	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
- 		info->read_status_mask |= MASK_BREAK;
+	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
+		info->read_status_mask |= MASK_BREAK;
 	if (I_IGNPAR(info->port.tty))
 		info->ignore_status_mask |= MASK_PARITY | MASK_FRAMING;
 	if (I_IGNBRK(info->port.tty)) {
@@ -3192,7 +3192,7 @@ static int tiocmset(struct tty_struct *tty,
 		info->signals &= ~SerialSignal_DTR;
 
 	spin_lock_irqsave(&info->lock,flags);
- 	set_signals(info);
+	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 	return 0;
 }
@@ -3203,7 +3203,7 @@ static int carrier_raised(struct tty_port *port)
 	struct slgt_info *info = container_of(port, struct slgt_info, port);
 
 	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
+	get_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 	return (info->signals & SerialSignal_DCD) ? 1 : 0;
 }
@@ -3218,7 +3218,7 @@ static void dtr_rts(struct tty_port *port, int on)
 		info->signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
 		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
- 	set_signals(info);
+	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
-- 
2.20.1

