Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528AE5F2694
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiJBWzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiJBWxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20423DF2D;
        Sun,  2 Oct 2022 15:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D67260EE8;
        Sun,  2 Oct 2022 22:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C161C433C1;
        Sun,  2 Oct 2022 22:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751088;
        bh=Oo5dzfgUvi7RFuvhID2RTEtBjZh0y9xtz/tZcCFnyi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+1R9EFUnfFLCrUtcL7SmuV/eZgm5popg1b6Sc1VqhECmcwRjjQGz/pfBvkAnywZm
         0cPs707xywjJcv11iZ9FxF5fwESq4BfB/xNg/Wu6vonhoxVXg5t1CNOLBdJGAh47rk
         FSavOc7TzQfcguczhlsOMOKomhmFXWUqaZ3/waRugqaR4Di7XOpahVd2CJD3mS9tvc
         U4bKsDkTh3ypaZpTQLa9n9ZojHUBhvVlsy5Do5Tm8DYnmRnN8TXO1UftwpYX77nYI7
         jEP1HJUHzk1ZJpSX+vcaWuMP2eHTuN301vnRPn5xFcWfvuzuIAz+4DS7yysHWEeIqA
         y0JtXhs+E1b9Q==
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
Subject: [PATCH AUTOSEL 5.15 13/20] um: Cleanup syscall_handler_t cast in syscalls_32.h
Date:   Sun,  2 Oct 2022 18:50:52 -0400
Message-Id: <20221002225100.239217-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
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

