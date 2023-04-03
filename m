Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7C76D3F4C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjDCIn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjDCInt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:43:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94457E1B8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E096610FB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244F2C433D2;
        Mon,  3 Apr 2023 08:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680511426;
        bh=KnCt8tY3DLqg2NY901nOQnhE+2ORYx1zKA0JISY/eiQ=;
        h=Subject:To:Cc:From:Date:From;
        b=1tn5qWaZmQYNYwV0MWPWDDNdErJx6HcM9HY197iu/h2kzH6CYDp1nxPv74mIeBPT0
         huuIdKL5kllI1QGvem4t6rP/syL8CTbN38LvaJvT0/mF7OB4hl1szQHeodBDdmP8rq
         +QfZri+k7ZA9nKhNdWHJatCpExmVf1SKhDfPaI/Q=
Subject: FAILED: patch "[PATCH] s390/uaccess: add missing earlyclobber annotations to" failed to apply to 4.19-stable tree
To:     hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, mark.rutland@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:43:38 +0200
Message-ID: <2023040338-emphases-eggbeater-ad1c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 89aba4c26fae4e459f755a18912845c348ee48f3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040338-emphases-eggbeater-ad1c@gregkh' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

89aba4c26fae ("s390/uaccess: add missing earlyclobber annotations to __clear_user()")
4e1b5a86a5ed ("s390/uaccess: add missing EX_TABLE entries to __clear_user()")
731efc9613ee ("s390: convert ".insn" encoding to instruction names")
012a224e1fa3 ("s390/uaccess: introduce bit field for OAC specifier")
b087dfab4d39 ("s390/crypto: add SIMD implementation for ChaCha20")
de5012b41e5c ("s390/ftrace: implement hotpatching")
f8c2602733c9 ("s390/ftrace: fix ftrace_update_ftrace_func implementation")
d1e18efa8fa9 ("s390/lib,uaccess: get rid of register asm")
fcc91d5d4047 ("s390/timex: get rid of register asm")
dbb8864b28d6 ("s390/uaccess: get rid of register asm")
53c1c2504b6b ("s390/pgtable: use register pair instead of register asm")
80f06306240e ("s390/vdso: reimplement getcpu vdso syscall")
87d598634521 ("s390/mm: remove set_fs / rework address space handling")
c9343637d6b2 ("s390/ftrace: assume -mhotpatch or -mrecord-mcount always available")
ab177c5d00cd ("s390/mm: remove unused clear_user_asce()")
cfef9aa69a73 ("s390/vdso: remove unused constants")
847d4287a0c6 ("Merge tag 's390-5.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89aba4c26fae4e459f755a18912845c348ee48f3 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <hca@linux.ibm.com>
Date: Thu, 23 Mar 2023 13:09:16 +0100
Subject: [PATCH] s390/uaccess: add missing earlyclobber annotations to
 __clear_user()

Add missing earlyclobber annotation to size, to, and tmp2 operands of the
__clear_user() inline assembly since they are modified or written to before
the last usage of all input operands. This can lead to incorrect register
allocation for the inline assembly.

Fixes: 6c2a9e6df604 ("[S390] Use alternative user-copy operations for new hardware.")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/all/20230321122514.1743889-3-mark.rutland@arm.com/
Cc: stable@vger.kernel.org
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 720036fb1924..d44214072779 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -172,7 +172,7 @@ unsigned long __clear_user(void __user *to, unsigned long size)
 		"4: slgr  %0,%0\n"
 		"5:\n"
 		EX_TABLE(0b,2b) EX_TABLE(6b,2b) EX_TABLE(3b,5b) EX_TABLE(7b,5b)
-		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
+		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
 		: "a" (empty_zero_page), [spec] "d" (spec.val)
 		: "cc", "memory", "0");
 	return size;

