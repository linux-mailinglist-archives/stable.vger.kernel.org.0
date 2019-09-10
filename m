Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130CEAE918
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 13:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfIJL1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 07:27:02 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35843 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbfIJL1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 07:27:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 089DE63B;
        Tue, 10 Sep 2019 07:27:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 07:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MUFRBm
        l35jJTt7XOLaEkXQ46xrAKW1mnueALrf0wrt8=; b=HTeWCp1AmLKSryGlNlYhEC
        f3jvXEDPIqjiz2bvE4R7gf0jF+JeRpkbAIlibD/jtSRNME5ZlM5ONXhh2BKpvor3
        0o8QspFZguIi43vs2EkWEe4npaSV/Jz/kTGLy4bS7kF7MpSbXsIAlegHXoPmcH8e
        IVmo2GP3Ymzlbqa84h9YG+AV2ijpMjGlUnT5e+lirtMiYsA2c6fT2dErCqUD6mTf
        0O2wsqM6q1fQJxGoXqo2AFy0rDOi/3wjIKTqhnA/q+F1xOE0Num/S5BKKOU9SMrY
        RFT0yEBgQnEToePl2KZZVPjlXwlDMtwVKZT+OLQBpUcbQj32MRZtbCH4pmARYcdQ
        ==
X-ME-Sender: <xms:hIh3XedGHcHBsRM8sufVJB8v3XwVoIim5FerKepxxihO8UhPvubxEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvudefrdeftddrkedrud
    dutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:hIh3XT7zxKkttWisyYfgNiYmjWKJpLaJ-26T3Wrydm8vX9GawjKasg>
    <xmx:hIh3Xb9GAm0HxxFJT4tvBtSaF5UBhKBUpmjeydfUnThv3P7ZTIN4tw>
    <xmx:hIh3XVGRuavIRD2zgkoPVae0yHx87-GBAuXykjNTWHqbhQTDMYNLfg>
    <xmx:hIh3XRmlnDM470fSwfqCVsxb6dKZzz0P7-p-hQTWnf1Te7RZcGPN7w>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A894D6005F;
        Tue, 10 Sep 2019 07:26:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64e: Drop stale call to smp_processor_id() which" failed to apply to 4.14-stable tree
To:     christophe.leroy@c-s.fr, Chris.Packham@alliedtelesis.co.nz,
        chris.packham@alliedtelesis.co.nz, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Sep 2019 12:26:56 +0100
Message-ID: <1568114816251171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b9ee5e04fd77898208c51b1395fa0b5e8536f9b6 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Thu, 8 Aug 2019 12:48:26 +0000
Subject: [PATCH] powerpc/64e: Drop stale call to smp_processor_id() which
 hangs SMP startup

Commit ebb9d30a6a74 ("powerpc/mm: any thread in one core can be the
first to setup TLB1") removed the need to know the cpu_id in
early_init_this_mmu(), but the call to smp_processor_id() which was
marked __maybe_used remained.

Since commit ed1cd6deb013 ("powerpc: Activate CONFIG_THREAD_INFO_IN_TASK")
thread_info cannot be reached before MMU is properly set up.

Drop this stale call to smp_processor_id() which makes SMP hang when
CONFIG_PREEMPT is set.

Fixes: ebb9d30a6a74 ("powerpc/mm: any thread in one core can be the first to setup TLB1")
Fixes: ed1cd6deb013 ("powerpc: Activate CONFIG_THREAD_INFO_IN_TASK")
Cc: stable@vger.kernel.org # v5.1+
Reported-by: Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bef479514f4c08329fa649f67735df8918bc0976.1565268248.git.christophe.leroy@c-s.fr

diff --git a/arch/powerpc/mm/nohash/tlb.c b/arch/powerpc/mm/nohash/tlb.c
index d4acf6fa0596..bf60983a58c7 100644
--- a/arch/powerpc/mm/nohash/tlb.c
+++ b/arch/powerpc/mm/nohash/tlb.c
@@ -630,7 +630,6 @@ static void early_init_this_mmu(void)
 #ifdef CONFIG_PPC_FSL_BOOK3E
 	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
 		unsigned int num_cams;
-		int __maybe_unused cpu = smp_processor_id();
 		bool map = true;
 
 		/* use a quarter of the TLBCAM for bolted linear map */

