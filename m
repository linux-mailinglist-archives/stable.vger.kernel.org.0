Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7462352646C
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381117AbiEMOcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381447AbiEMObZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C719FB26;
        Fri, 13 May 2022 07:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B90762154;
        Fri, 13 May 2022 14:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A0BC34115;
        Fri, 13 May 2022 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452128;
        bh=FUcUhRYbP7KCybJFcZBEQiZkC4zROQLRkWfS3w43Iio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAlY982JpVdhMqQ4uFLc0KLmwgwaonzPlYSPEpcJ9AU7g1LIgiu4/2QXbmRhQBF9W
         u3ekTw7mMCgjALbzbtQO1T4rIbZ1UKIXz6/7iQk097xf+CVtVn1vNIpgnlrABagYwc
         HZFMFH8r9FYd2RHxkjAWzCHHRgKS8sGTt8gU6Cmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/21] tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in perf bench mem memcpy
Date:   Fri, 13 May 2022 16:23:50 +0200
Message-Id: <20220513142230.120380855@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 35cb8c713a496e8c114eed5e2a5a30b359876df2 ]

To bring in the change made in this cset:

  f94909ceb1ed4bfd ("x86: Prepare asm files for straight-line-speculation")

It silences these perf tools build warnings, no change in the tools:

  Warning: Kernel ABI header at 'tools/arch/x86/lib/memcpy_64.S' differs from latest version at 'arch/x86/lib/memcpy_64.S'
  diff -u tools/arch/x86/lib/memcpy_64.S arch/x86/lib/memcpy_64.S
  Warning: Kernel ABI header at 'tools/arch/x86/lib/memset_64.S' differs from latest version at 'arch/x86/lib/memset_64.S'
  diff -u tools/arch/x86/lib/memset_64.S arch/x86/lib/memset_64.S

The code generated was checked before and after using 'objdump -d /tmp/build/perf/bench/mem-memcpy-x86-64-asm.o',
no changes.

Cc: Borislav Petkov <bp@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/x86/lib/memcpy_64.S |   12 ++++++------
 tools/arch/x86/lib/memset_64.S |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/tools/arch/x86/lib/memcpy_64.S
+++ b/tools/arch/x86/lib/memcpy_64.S
@@ -39,7 +39,7 @@ SYM_FUNC_START_WEAK(memcpy)
 	rep movsq
 	movl %edx, %ecx
 	rep movsb
-	ret
+	RET
 SYM_FUNC_END(memcpy)
 SYM_FUNC_END_ALIAS(__memcpy)
 EXPORT_SYMBOL(memcpy)
@@ -53,7 +53,7 @@ SYM_FUNC_START_LOCAL(memcpy_erms)
 	movq %rdi, %rax
 	movq %rdx, %rcx
 	rep movsb
-	ret
+	RET
 SYM_FUNC_END(memcpy_erms)
 
 SYM_FUNC_START_LOCAL(memcpy_orig)
@@ -137,7 +137,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movq %r9,	1*8(%rdi)
 	movq %r10,	-2*8(%rdi, %rdx)
 	movq %r11,	-1*8(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_16bytes:
 	cmpl $8,	%edx
@@ -149,7 +149,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movq -1*8(%rsi, %rdx),	%r9
 	movq %r8,	0*8(%rdi)
 	movq %r9,	-1*8(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_8bytes:
 	cmpl $4,	%edx
@@ -162,7 +162,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movl -4(%rsi, %rdx), %r8d
 	movl %ecx, (%rdi)
 	movl %r8d, -4(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_3bytes:
 	subl $1, %edx
@@ -180,7 +180,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movb %cl, (%rdi)
 
 .Lend:
-	retq
+	RET
 SYM_FUNC_END(memcpy_orig)
 
 .popsection
--- a/tools/arch/x86/lib/memset_64.S
+++ b/tools/arch/x86/lib/memset_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memset)
 	movl %edx,%ecx
 	rep stosb
 	movq %r9,%rax
-	ret
+	RET
 SYM_FUNC_END(__memset)
 SYM_FUNC_END_ALIAS(memset)
 EXPORT_SYMBOL(memset)
@@ -63,7 +63,7 @@ SYM_FUNC_START_LOCAL(memset_erms)
 	movq %rdx,%rcx
 	rep stosb
 	movq %r9,%rax
-	ret
+	RET
 SYM_FUNC_END(memset_erms)
 
 SYM_FUNC_START_LOCAL(memset_orig)
@@ -125,7 +125,7 @@ SYM_FUNC_START_LOCAL(memset_orig)
 
 .Lende:
 	movq	%r10,%rax
-	ret
+	RET
 
 .Lbad_alignment:
 	cmpq $7,%rdx


