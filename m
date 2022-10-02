Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54465F26BE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiJBW7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJBW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557AE3F1C0;
        Sun,  2 Oct 2022 15:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75DA60F34;
        Sun,  2 Oct 2022 22:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81DDC433C1;
        Sun,  2 Oct 2022 22:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751199;
        bh=Oo5dzfgUvi7RFuvhID2RTEtBjZh0y9xtz/tZcCFnyi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTGpqUSrRR7kT/JfgC7aO1AKgNzycFNHT5NBZhh94nbq8vj4BgPLmVlhKpmtG5BmB
         3qe4XldkKLBprN4X1QLBN/KOvQo6iPcKKdcvxxWXRaJKNpiN2Fqel8PZr2suSHVKkW
         yJ15rzKJyWrfbByXcmLWIHxdRlSuIwHQdPxp05ofp6oz7u3gpAtjM6355TVDmqw1kV
         xns0dc1La0ZpQJn9wb4VnfLPSex5f1HZ91IyUHGVr4byWvbWY5OA9G0C0WZnhNiowd
         /DJU3ktftffUhInR/bcsGt7K8aNvmPzP5NIxyOWyR75jlMkev7iVaG3SZFqsck5FQI
         +fgyHJYZ5hseQ==
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
Subject: [PATCH AUTOSEL 4.19 7/8] um: Cleanup syscall_handler_t cast in syscalls_32.h
Date:   Sun,  2 Oct 2022 18:52:59 -0400
Message-Id: <20221002225300.239982-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225300.239982-1-sashal@kernel.org>
References: <20221002225300.239982-1-sashal@kernel.org>
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

