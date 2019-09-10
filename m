Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AEDAE917
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 13:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfIJL07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 07:26:59 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41435 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbfIJL07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 07:26:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3531E5F8;
        Tue, 10 Sep 2019 07:26:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 07:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v+OMKz
        QM9mjJovWjpqbKtCH+6YCGcggVmvwL4wi8rjM=; b=PFGcyIxVlcoKcEeZC5eDOC
        mGl8aZ0/HosXicPsX6uI8FPWFb0HGOLK1KvAyUhPTyYJd5mv2Ude9rV6Vs1BYgr4
        5mBdHbLrj9aLlPfct5yqD/LBsIm20cE0NyeqdHpUS4jhOdc3xCcsHc9PYZhOqCXR
        9TI9ZhzPLEjZDTGTlP50eOVMxRsaQ8BYsHRDJNeHz3vcYu32RAM2hO8u9cLTrIvn
        YWehkhkt65eZ85qofTdVBUUJQ0pilPXb4dGzyWuqWQew+QS8C9Hw3HMMFurdcqE8
        9StD8pElHLUvYL0uH6ynHH/69ac6GipIicyVxoi7Io0W30Le3guCTa8WqZFYq2Og
        ==
X-ME-Sender: <xms:gIh3Xb9LTI3ofZCXdRVBzbosRnKMk73hpHxskN4LyPSdiwvU32hheA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvudefrdeftddrkedrud
    dutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:gIh3XbaUPMJtB-omNiVIJTZ7FqVs_9jhktCqjN5yXGLpjlGjo4ZKcQ>
    <xmx:gIh3XUHjgAOAEm1a63sn8OGmqaM42tlK-JCjvbbk4jkcaumc1x_Irw>
    <xmx:gIh3XU4IcuPWVwZHi78RlwbeFDa5GF0ThyXITHtW2PHWiie0ePOjRw>
    <xmx:gYh3XWjHwlVQIbRl195V91zrtLuIN79Vc_45zGPu0h_4FQMfDOSyaw>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C974D6005A;
        Tue, 10 Sep 2019 07:26:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64e: Drop stale call to smp_processor_id() which" failed to apply to 4.19-stable tree
To:     christophe.leroy@c-s.fr, Chris.Packham@alliedtelesis.co.nz,
        chris.packham@alliedtelesis.co.nz, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Sep 2019 12:26:54 +0100
Message-ID: <156811481474161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

