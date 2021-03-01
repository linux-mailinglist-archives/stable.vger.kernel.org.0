Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2CF328D54
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbhCATIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:37 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55555 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241031AbhCATEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 14:04:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E9E8DC41;
        Mon,  1 Mar 2021 14:03:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 14:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2Marnn
        LPXqQ38e/QlpDY3uB/Pu5xy5An/G/pgn9IUPI=; b=kYlJ7achUKoToqcIKcDR0p
        9ccJnlNxtu5RrA9LrCSGkXWo3hKD5TqhVOCOgE/gVmqVei4RmE1leI9LwMntCcpa
        Zefx+jZ1Jgc0miPFkIq1cc0cHbkVoCuO1REeHU1We6+hQYmC5/4vywmEJE4Y3kV2
        lwPPMUbVnrIrGxyYF2kSCmcmZdUtPxRtqV4gswsdrCEz541/wPI0DduU+0XuzBLo
        3WdjvczkQQmkkQY1oDlfnWqlm+NHWkhvz/dqJ8A8BKfNHdCp7XUk1SXXO+woeMy7
        uZIZh/ILzOJJi6iD7dPSt0jMW0vj0YoBQ1XwecJ9EC6zn1V6yvK1UFcMi1m+0Wxw
        ==
X-ME-Sender: <xms:fjo9YFXPT84j-BnqichQhg_CXEkG0Y2tLERy8teJiy8QVCbDUI5T2Q>
    <xme:fjo9YFnBk6zPyZvU-CEcGpw66DuGsCfCsAF7ZbBh_9I68oNJCbhnb9t2puwLAAxjP
    BVJF3rx9LUj4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fjo9YBahC542SCH9YhhRpataBInpvaMMCJ2Zd-66k2hSic79XUse6w>
    <xmx:fjo9YIXG2JZHDTFBd9FXMTG79_nex06tRKSe4BGaEbWy8gqo4I_GMQ>
    <xmx:fjo9YPnIh5E3gZ0tvD70FEusSsHS3fCiEG1ctfpdFsGAeXLPWepYlA>
    <xmx:gDo9YEycG4hr--GugLKPDQkpchkCtAvb0HLnlJa7W27DRK4DoHvrtQpVlf8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C7B11080054;
        Mon,  1 Mar 2021 14:03:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/sstep: Fix incorrect return from analyze_instr()" failed to apply to 5.10-stable tree
To:     ananth@linux.ibm.com, mpe@ellerman.id.au,
        naveen.n.rao@linux.vnet.ibm.com, sandipan@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 20:03:24 +0100
Message-ID: <161462540422642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

