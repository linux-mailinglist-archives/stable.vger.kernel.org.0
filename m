Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E29A406BFB
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhIJMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233856AbhIJMfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61398611F0;
        Fri, 10 Sep 2021 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277245;
        bh=0OciUXkOw6H8uLnsBBtXfwARuNwWQfNBL2OXCIPePuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4sDnF8dG1KGnboU1Fdccn9NJhfpPjEGN39Ue2yJAVHRiAAWYwGGZhZ7/Hgp4j/aC
         5FGc4GNkqBifCQ9YKqgcgR9SiCxkEFg+2AUt2HTNSibOGiPzw1kEeIX20zpS6xEFQK
         bTUZWja+L1RkRuWPir56+PMgkpsyBTAzgPhFuDKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.10 08/26] tty: drop termiox user definitions
Date:   Fri, 10 Sep 2021 14:30:12 +0200
Message-Id: <20210910122916.528381124@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit c762a2b846b619c0f92f23e2e8e16f70d20df800 upstream.

As was concluded in a follow-up discussion of commit e0efb3168d34 (tty:
Remove dead termiox code) [1], termiox ioctls never worked, so there is
barely anyone using this interface. We can safely remove the user
definitions for this never adopted interface.

[1] https://lore.kernel.org/lkml/c1c9fc04-02eb-2260-195b-44c357f057c0@kernel.org/t/#u

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210105120239.28031-12-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/termios.h |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/include/uapi/linux/termios.h
+++ b/include/uapi/linux/termios.h
@@ -5,19 +5,4 @@
 #include <linux/types.h>
 #include <asm/termios.h>
 
-#define NFF	5
-
-struct termiox
-{
-	__u16	x_hflag;
-	__u16	x_cflag;
-	__u16	x_rflag[NFF];
-	__u16	x_sflag;
-};
-
-#define	RTSXOFF		0x0001		/* RTS flow control on input */
-#define	CTSXON		0x0002		/* CTS flow control on output */
-#define	DTRXOFF		0x0004		/* DTR flow control on input */
-#define DSRXON		0x0008		/* DCD flow control on output */
-
 #endif


