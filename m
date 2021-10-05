Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C774233E3
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 00:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhJEWy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 18:54:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54142 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhJEWy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 18:54:28 -0400
Date:   Tue, 05 Oct 2021 22:52:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633474356;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1mORWf0172sm+BisG0N1WyeXognkoKrkSS5hBAwMsiw=;
        b=tH3y/KAeFNmeJJ/GjLKSh/u3X/IMWu+WoXBAby1XAoRV9Lwfs7maTtAAbAXfJT9hZc9ouW
        ReYmKkP7BuJo9kGue0APLB5LVUlYhjrBGNQa1bx3R66TXyuzs1ppQ+XEQIybzlL7dPQn22
        vkthMHO7KeG8Rn1dndqWfHNWh7dtmcOIdPJ0ixbYiswon498a0va5k22vsS3/UitrtbW0Z
        HEF8ZfEjrhr1FOBAbAwfw2I4HA44zrAJVztogVPt1Xrkt5XiCPaBKPmh2eEMO+DYtJLdO+
        WZpZrtGd7a6Jm6mR+4Zkic6asKHcbzk1+BPQAgH6aN/vTrimncbuTxzM9/Es2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633474356;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1mORWf0172sm+BisG0N1WyeXognkoKrkSS5hBAwMsiw=;
        b=mkb5io2L+ohG9AQZbzQ1gn0bSD0YWtXjwq1Kv39jR6T3lo2Yu1ADuloYiBoxUOKSwi+BVe
        qj+xoIERAjVTx+Cg==
From:   "tip-bot2 for Lukas Bulwahn" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/platform/olpc: Correct ifdef symbol to intended
 CONFIG_OLPC_XO15_SCI
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210803113531.30720-3-lukas.bulwahn@gmail.com>
References: <20210803113531.30720-3-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Message-ID: <163347435478.25758.5867182553865653470.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4f90c68790aaa260fb5852406c28e25018872e45
Gitweb:        https://git.kernel.org/tip/4f90c68790aaa260fb5852406c28e25018872e45
Author:        Lukas Bulwahn <lukas.bulwahn@gmail.com>
AuthorDate:    Tue, 03 Aug 2021 13:35:24 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 00:46:10 +02:00

x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI

The refactoring in the commit in Fixes introduced an ifdef
CONFIG_OLPC_XO1_5_SCI, however the config symbol is actually called
"CONFIG_OLPC_XO15_SCI".

Fortunately, ./scripts/checkkconfigsymbols.py warns:

OLPC_XO1_5_SCI
Referencing files: arch/x86/platform/olpc/olpc.c

Correct this ifdef condition to the intended config symbol.

Fixes: ec9964b48033 ("Platform: OLPC: Move EC-specific functionality out from x86")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-3-lukas.bulwahn@gmail.com
---
 arch/x86/platform/olpc/olpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index ee2beda..1d4a00e 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -274,7 +274,7 @@ static struct olpc_ec_driver ec_xo1_driver = {
 
 static struct olpc_ec_driver ec_xo1_5_driver = {
 	.ec_cmd = olpc_xo1_ec_cmd,
-#ifdef CONFIG_OLPC_XO1_5_SCI
+#ifdef CONFIG_OLPC_XO15_SCI
 	/*
 	 * XO-1.5 EC wakeups are available when olpc-xo15-sci driver is
 	 * compiled in
