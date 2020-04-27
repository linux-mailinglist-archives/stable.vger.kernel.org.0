Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897C91BAB7C
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 19:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgD0Rk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 13:40:58 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:51355 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgD0Rk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 13:40:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A1E7D1940E55;
        Mon, 27 Apr 2020 13:40:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 13:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=naKwge
        SJYkm37Gmgy/GWWRk2Iangk2+y8+sz6t8xmbg=; b=KpQ5/f1hNVblTEdGGGRy44
        ZFlPp4iYSgHUbecV9Y31wBBj1pePDisqFZVyKrU7RI5yhXw0Hh7E7fBETn0owMG6
        zsJKdHZnDq3bCvhoTQ6gMakuq+jDKc8ihbl+HLlm2ZlsFWNDDV+0Mm9bq6DSsBx8
        OayarV6PFwxbhOOSA5HGfgtBKLuf3osJpqm2G5g6XbjPWdGjpE1TDhiru8jr5/pD
        iezX7RpQnOsBe7oFvjW+rAA9eewOVFUO1BdfmVQb+SSYlf50rQyxX5owVqDViNUQ
        5c8tZPU2DtXk+154tNHaR9BoV0Eu9c6+mw1BYRppRyn2RflEs+MdsBP+JVBZzhkA
        ==
X-ME-Sender: <xms:JxmnXgtfR5ewASxxjrGnx--OPlGlXKAN87biHwu95oTwjjNsugL7rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JxmnXptaNiAmAAQ_JeuvnMykm-8CgfmO2PJtuCRPeg9M9VLB5tg61w>
    <xmx:JxmnXlZeWJnWKxm0zj2LYi_xuDbd21z9Vw0FNitMfUF4xrxVtaWSNA>
    <xmx:JxmnXjigyK2hCsOXQcwPBXA0-mObKWn_MFPUHpJiSFSA6Uf2BpiByg>
    <xmx:KBmnXvF2WYf6CjAkWlNSDaWRa8iy4q3AlwxG73CZJpUEzhx9fPDuVg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5588D3065E77;
        Mon, 27 Apr 2020 13:40:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/8xx: Fix STRICT_KERNEL_RWX startup test failure" failed to apply to 5.4-stable tree
To:     christophe.leroy@c-s.fr, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 19:40:49 +0200
Message-ID: <158800924923469@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From b61c38baa98056d4802ff5be5cfb979efc2d0f7a Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Mon, 20 Apr 2020 05:37:42 +0000
Subject: [PATCH] powerpc/8xx: Fix STRICT_KERNEL_RWX startup test failure

WRITE_RO lkdtm test works.

But when selecting CONFIG_DEBUG_RODATA_TEST, the kernel reports
	rodata_test: test data was not read only

This is because when rodata test runs, there are still old entries
in TLB.

Flush TLB after setting kernel pages RO or NX.

Fixes: d5f17ee96447 ("powerpc/8xx: don't disable large TLBs with CONFIG_STRICT_KERNEL_RWX")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/485caac75f195f18c11eb077b0031fdd2bb7fb9e.1587361039.git.christophe.leroy@c-s.fr

diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index 3189308dece4..d83a12c5bc7f 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -185,6 +185,7 @@ void mmu_mark_initmem_nx(void)
 			mmu_mapin_ram_chunk(etext8, einittext8, PAGE_KERNEL);
 		}
 	}
+	_tlbil_all();
 }
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
@@ -199,6 +200,8 @@ void mmu_mark_rodata_ro(void)
 				      ~(LARGE_PAGE_SIZE_8M - 1)));
 	mmu_patch_addis(&patch__dtlbmiss_romem_top, -__pa(_sinittext));
 
+	_tlbil_all();
+
 	/* Update page tables for PTDUMP and BDI */
 	mmu_mapin_ram_chunk(0, sinittext, __pgprot(0));
 	mmu_mapin_ram_chunk(0, etext, PAGE_KERNEL_ROX);

