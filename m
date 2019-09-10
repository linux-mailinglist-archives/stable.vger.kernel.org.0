Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80984AE919
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 13:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfIJL1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 07:27:04 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:36827 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbfIJL1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 07:27:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6DCF160D;
        Tue, 10 Sep 2019 07:27:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 07:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Jut87w
        iHf2Vzg8FkJJWwS41rKGC64oYRGVdIfiUiYqs=; b=zgHNueuoGSNzGspa0P3eQA
        v/D8dS1Bl6hJIsWoPAqsyxL+jzTIXT3NeCTbVpjByEQ1YeqwKIwUR0EF4EUIxraL
        DOAijXr3KQK1vbH4Y7AABRYsPcunp2AVGm6tXzJBnjSl6+uaV0t30kXrWlrb8L3F
        w2UmrEH3gpMycOxIm/rNceNVylWNAnRphpv55rSrKLpG2nro6fW6GQUR8vkBQRAt
        4NkfjvArKFeJdkt+tdz8a9YJooaR66aSMMjglbJtpc1FUEsTMZZQMZ8Mj4zwmeuO
        jx/AHF7bQVAWQtB7l8IYAL5GoZCjvqmXlfotR1xG4dCFyUIKXnIuX3P3w+cw6whg
        ==
X-ME-Sender: <xms:h4h3XSpr1oT750-ZaFoIBAkbG3OYydCqxTaEQKQlIk6xxybpumwn6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvudefrdeftddrkedrud
    dutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:h4h3Xc5dltmPTNMa8tCdfckRWMSi0NKeD_qANZOl5QEKohrco1J8Cg>
    <xmx:h4h3XQ2NHfdOeRpSQyzG9NmZu8BM44rmBmv4RiXak2_R8Obv2c6Nxw>
    <xmx:h4h3XSPuaYWz6VVcqPHoYY40j5wSKhp4XqQTXz7tBhz7P9sp5S4DUw>
    <xmx:h4h3XYb5yTkFV2zgkFFkXQmCPrqqAqQLPmTXkFmo84pS9hq6DbBOQQ>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A5F8D6005A;
        Tue, 10 Sep 2019 07:27:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64e: Drop stale call to smp_processor_id() which" failed to apply to 4.9-stable tree
To:     christophe.leroy@c-s.fr, Chris.Packham@alliedtelesis.co.nz,
        chris.packham@alliedtelesis.co.nz, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Sep 2019 12:26:58 +0100
Message-ID: <156811481811893@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

