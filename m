Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60052424472
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 19:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhJFRkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 13:40:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59524 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhJFRkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 13:40:51 -0400
Date:   Wed, 06 Oct 2021 17:38:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633541938;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbmE4xSXmD+805a7s3uI+751JapvC1TgNlpznYPvUbk=;
        b=3qZoKztEwLWCSq0jLhfPFioXDBV+AsoLTRH6jpVOSax3XTWYBXAozLqgMWuUbh9dH/OprC
        u7nHz645kKevA7620DD6Atusdhc9bq27c0LfM3/d1dqgBLIJ1zve6a7XL6S7Ray3aZKvzO
        KLieMBrfVxtl2TOW/awFnS+pb3W0MZ/v+dxBWNnIWOoMWet82c7pryS7mJlGXS1db3m9J5
        lGUKGaSKWG4pac8LDIaVtb1mcfVcP2vPKmGDnNV2Myy6kItzHydL9u1zQEF8DdzDWtcHJC
        9EMHCs7QtGHbM/mU3FwWH0f8CXH9vp58voGVCO7MY9uqT33NLjGMMx3s/89GiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633541938;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbmE4xSXmD+805a7s3uI+751JapvC1TgNlpznYPvUbk=;
        b=8Ogwt3MX1zSWaGQ0zcrkU2J13W/Z+67hEr6Acb8kZzftom8W3gl5/wQQmQ3vMreqamw54O
        QCF/J5FdZImkpfBw==
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
Message-ID: <163354193757.25758.7882332566852533800.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4758fd801f919b8b9acad78d2e49a195ec2be46b
Gitweb:        https://git.kernel.org/tip/4758fd801f919b8b9acad78d2e49a195ec2be46b
Author:        Lukas Bulwahn <lukas.bulwahn@gmail.com>
AuthorDate:    Tue, 03 Aug 2021 13:35:24 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 18:46:06 +02:00

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
