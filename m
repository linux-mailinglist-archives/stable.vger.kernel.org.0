Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500335F272C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJBXQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiJBXQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:16:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9EE49B66;
        Sun,  2 Oct 2022 16:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 743F860F1A;
        Sun,  2 Oct 2022 22:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91385C433D6;
        Sun,  2 Oct 2022 22:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751217;
        bh=Oo5dzfgUvi7RFuvhID2RTEtBjZh0y9xtz/tZcCFnyi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmBG++Qmhiy1iC32hNc8imd949r92onR1YlaLSFTWwwo5/RrWahetc8bBedC64Je7
         ku2ZHQDIzE9jZ1g7GtCsN0rfJarwKHcnkrAU3tqWmeAhx0nCn3rvh2OyuYp7Nt0vy+
         slUCR6/9VarbQxgFhrtt6SE1WcP685GlR17FF9uyjmpZSdutxfcIXW7YcWxIFIjh+G
         wv9ddxUUy5N9K4KwzEAwTmbmj9TtQB0SC2OvMKNzPztvdpCKVFMj9P6LyVtpSR5/Zk
         TTDbC8qQ+hAmZ7tOWy6foyPhAliGnxBtRGRGaiN6F6lwrSWGz/oGDtDOg1iAvZr+ll
         hW8gL9welwQ1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Straub <lukasstraub2@web.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 5/6] um: Cleanup syscall_handler_t cast in syscalls_32.h
Date:   Sun,  2 Oct 2022 18:53:20 -0400
Message-Id: <20221002225323.240142-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225323.240142-1-sashal@kernel.org>
References: <20221002225323.240142-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Straub <lukasstraub2@web.de>

[ Upstream commit 61670b4d270c71219def1fbc9441debc2ac2e6e9 ]

Like in f4f03f299a56ce4d73c5431e0327b3b6cb55ebb9
"um: Cleanup syscall_handler_t definition/cast, fix warning",
remove the cast to to fix the compiler warning.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/shared/sysdep/syscalls_32.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/um/shared/sysdep/syscalls_32.h b/arch/x86/um/shared/sysdep/syscalls_32.h
index 68fd2cf526fd..f6e9f84397e7 100644
--- a/arch/x86/um/shared/sysdep/syscalls_32.h
+++ b/arch/x86/um/shared/sysdep/syscalls_32.h
@@ -6,10 +6,9 @@
 #include <asm/unistd.h>
 #include <sysdep/ptrace.h>
 
-typedef long syscall_handler_t(struct pt_regs);
+typedef long syscall_handler_t(struct syscall_args);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) \
-	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
-- 
2.35.1

