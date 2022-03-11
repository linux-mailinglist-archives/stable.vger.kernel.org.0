Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07424D6870
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 19:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242495AbiCKSbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 13:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiCKSbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 13:31:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742FD1BB723;
        Fri, 11 Mar 2022 10:30:09 -0800 (PST)
Date:   Fri, 11 Mar 2022 18:30:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647023407;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qr1P/2r6c3vLw0HKkU1SXJnnH56QlvpCoESrvPJot4E=;
        b=wlIY+x6G4xt4Jd9VMZc+ZCXp21wg0kDERLHQ/LVR332JQQJt+jcjxNO1/Dxai7oyAHfn93
        b/oDLzVHoTrn8XRFXTw2FVqc3R75+ZqfVdZaYmJeTtS4w8AhoGxp5r3llKgamIiy77Zr9O
        hxqyhA85Ti3HbnZjeIZnumdK/tkyCKXrzfoZ8JdopytvyDKUnSM1lhEzOhPBefHdaZ7r5v
        5dBUgooez7tXMLUEVkFQ8toCj5KMrhyBCRmT6Lji/E68O0+v0kqsuYWk0jtS+FpUPkjwpE
        DfZr+npRVf4xcAHadAeeYIv7II6u/LJY49Np09+LZn1CiefxabPdsfMSsegbag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647023407;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qr1P/2r6c3vLw0HKkU1SXJnnH56QlvpCoESrvPJot4E=;
        b=SiQZHKHvw7QfwbjgL1rxgXgv7jxi1DObR4d+LllTUonpuPwiW49sHQ3NgaNNQg2K9KaH9W
        a7AnNWikmd648sDw==
From:   "tip-bot2 for Li Huafei" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/traps: Mark do_int3() NOKPROBE_SYMBOL
Cc:     Li Huafei <lihuafei1@huawei.com>, Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220310120915.63349-1-lihuafei1@huawei.com>
References: <20220310120915.63349-1-lihuafei1@huawei.com>
MIME-Version: 1.0
Message-ID: <164702340572.16921.5012171249214992963.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a365a65f9ca1ceb9cf1ac29db4a4f51df7c507ad
Gitweb:        https://git.kernel.org/tip/a365a65f9ca1ceb9cf1ac29db4a4f51df7c507ad
Author:        Li Huafei <lihuafei1@huawei.com>
AuthorDate:    Thu, 10 Mar 2022 20:09:15 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 11 Mar 2022 19:19:30 +01:00

x86/traps: Mark do_int3() NOKPROBE_SYMBOL

Since kprobe_int3_handler() is called in do_int3(), probing do_int3()
can cause a breakpoint recursion and crash the kernel. Therefore,
do_int3() should be marked as NOKPROBE_SYMBOL.

Fixes: 21e28290b317 ("x86/traps: Split int3 handler up")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220310120915.63349-1-lihuafei1@huawei.com
---
 arch/x86/kernel/traps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c9d566d..8143693 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -659,6 +659,7 @@ static bool do_int3(struct pt_regs *regs)
 
 	return res == NOTIFY_STOP;
 }
+NOKPROBE_SYMBOL(do_int3);
 
 static void do_int3_user(struct pt_regs *regs)
 {
