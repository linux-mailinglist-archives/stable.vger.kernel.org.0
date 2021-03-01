Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB262328D4C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhCATIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:18 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55125 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241028AbhCATEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 14:04:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 412BCC4E;
        Mon,  1 Mar 2021 14:03:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 01 Mar 2021 14:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4QTYUo
        o3/6eKaOo47+IasKWrPuBlv78M6kSn9J/xWpA=; b=gdu6eNkKojAKuIkjg+7R8J
        BVcx7CRDbfTezL/CpyvwWVPWv/a4HWXw/cxdC0whvQGpZ1a1tlD2REAEoxc9mp4G
        +Ym4P03wWZ0nEN2HPJVpX2t6hAXiPQbcdUuaG36L1m31qXCGfYrmVkLMzlI6hBoD
        /M8SWQY1kbdbWbxplvpqVa1+0O7GL7LqVNZlTNtknBa0mc2gI2q4EwA2w7rhYVjo
        zLjkGCNhewq0krWPrCMBIbZ0xTByRQkti8NqgOnG2eJ1TUl6TUgDskGFPXFgsb2o
        azYQKbAmmvxoZQCg/Ou69NyCUy2Br5Dm3lwdywUuxpOA5sjXzbH7ginQDKp5PlOw
        ==
X-ME-Sender: <xms:hzo9YM4KCkunZ_Q-zincCkWZ9F9jgMSZ8rZieEDdfGALuoDQVgahxA>
    <xme:hzo9YN0uWftq8uMCgvbFKD41CnpJ9hvpFtpyOqZ4iYdNSvC-bbNaVQTr9rY9Z_ry7
    jjxe1rEM_IFeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hzo9YIV39J9n-I8kmK4tfp4yGH1vYcXI4w33iuUQPq45HygQk-b1QA>
    <xmx:hzo9YI5OvwTSHjPjLOT3FFm_a2Mw2N3gNLzb3eH5_KlDdBHBQOdfjA>
    <xmx:hzo9YPIP74Oz5lKdA3iLGnqltXaFu8stWM3p7PhoV-jmRGfadcCzvA>
    <xmx:hzo9YDFWL3bsMLmIMebov1FC_RtEPNesFDEQMwSEmzBf6cVP46XeNPTow18>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4F68108005F;
        Mon,  1 Mar 2021 14:03:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/sstep: Fix incorrect return from analyze_instr()" failed to apply to 5.4-stable tree
To:     ananth@linux.ibm.com, mpe@ellerman.id.au,
        naveen.n.rao@linux.vnet.ibm.com, sandipan@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 20:03:25 +0100
Message-ID: <1614625405130109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 718aae916fa6619c57c348beaedd675835cf1aa1 Mon Sep 17 00:00:00 2001
From: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Date: Mon, 25 Jan 2021 18:36:43 +0530
Subject: [PATCH] powerpc/sstep: Fix incorrect return from analyze_instr()

We currently just percolate the return value from analyze_instr()
to the caller of emulate_step(), especially if it is a -1.

For one particular case (opcode = 4) for instructions that aren't
currently emulated, we are returning 'should not be single-stepped'
while we should have returned 0 which says 'did not emulate, may
have to single-step'.

Fixes: 930d6288a26787 ("powerpc: sstep: Add support for maddhd, maddhdu, maddld instructions")
Signed-off-by: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161157999039.64773.14950289716779364766.stgit@thinktux.local

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index f859cbbb6375..e96cff845ef7 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1445,6 +1445,11 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 #ifdef __powerpc64__
 	case 4:
+		/*
+		 * There are very many instructions with this primary opcode
+		 * introduced in the ISA as early as v2.03. However, the ones
+		 * we currently emulate were all introduced with ISA 3.0
+		 */
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
 			goto unknown_opcode;
 
@@ -1472,7 +1477,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		 * There are other instructions from ISA 3.0 with the same
 		 * primary opcode which do not have emulation support yet.
 		 */
-		return -1;
+		goto unknown_opcode;
 #endif
 
 	case 7:		/* mulli */

