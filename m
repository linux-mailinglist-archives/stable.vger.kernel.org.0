Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7D394C61
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 15:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhE2Nyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 09:54:31 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:57267 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhE2Ny3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 09:54:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id E49581940C5F;
        Sat, 29 May 2021 09:52:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 29 May 2021 09:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fmaohJ
        d5/4fwlZgE9HGpc+Za2B1hGz5RV6pY7qMUVRQ=; b=cj9n9y1JHpmMyOAB4PYhSm
        IfJt4Lpz5I87Y5c+h7GNqRYFSpo32WRy9mArg1MR7fZfKXj4mA4Ambw+Qp3OBTaz
        blALAErGlLAAKfIdfnwBKXrTHetfM9H97UOkZbeUQt4eu0Y2PzxEDzr1+gBry6WI
        FOm/o7CmssZo2dEwiMyEidHnJuNa6CmXb4eXx/CbkbE6lVeKDGA4UItUvnt/Nq7Q
        4ITmf3cK101JFkoKMXrUML2ofbGOwUyhNHGaIVmrv00vgFrN/ZkDvMOKaUydhe6n
        4CJWbTefFeEeSl8cWLWLsrpUMDYDmi6uhfkeIWqnvn1WUsGgD0PeeGiqSjqt87ww
        ==
X-ME-Sender: <xms:NEeyYBq35pnEcO8Bvmky4BjHbxyl2DrLZ2-huiotnBPijBnbq1rN3g>
    <xme:NEeyYDpuq2_bdCkHfRa1RttQ4LlbKnXeLlgj22bI1360ne1q4bQNUcXgytzjWts8Z
    dCQ3zm6D07WDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NEeyYONi3nFFPAVnLyU5lCqVKCt3K5DfYa_XEv1iS47K7fMCnx7n8g>
    <xmx:NEeyYM54r5CF01FnPiDytND9lk6NmCOeWmdevVAGh9hVvOi5A5qrZw>
    <xmx:NEeyYA5Ia39tUJPx-nBi-7qbBkLBKPL7ps3hV2eOo_iJU97S8qAHtw>
    <xmx:NEeyYOnEc2wVRnBAOO-ENJIpHuqULvqoJ3GAO4VaEQ--DbiuqKLcjA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 09:52:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: mm: don't use CON and BLK mapping if KFENCE is enabled" failed to apply to 5.12-stable tree
To:     Jisheng.Zhang@synaptics.com, catalin.marinas@arm.com,
        elver@google.com, mark.rutland@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 15:52:50 +0200
Message-ID: <162229637024181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e69012400b0cb42b2070748322cb72f9effec00f Mon Sep 17 00:00:00 2001
From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Tue, 25 May 2021 10:45:51 +0800
Subject: [PATCH] arm64: mm: don't use CON and BLK mapping if KFENCE is enabled

When we added KFENCE support for arm64, we intended that it would
force the entire linear map to be mapped at page granularity, but we
only enforced this in arch_add_memory() and not in map_mem(), so
memory mapped at boot time can be mapped at a larger granularity.

When booting a kernel with KFENCE=y and RODATA_FULL=n, this results in
the following WARNING at boot:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/memory.c:2462 apply_to_pmd_range+0xec/0x190
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc1+ #10
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
[    0.000000] pc : apply_to_pmd_range+0xec/0x190
[    0.000000] lr : __apply_to_page_range+0x94/0x170
[    0.000000] sp : ffffffc010573e20
[    0.000000] x29: ffffffc010573e20 x28: ffffff801f400000 x27: ffffff801f401000
[    0.000000] x26: 0000000000000001 x25: ffffff801f400fff x24: ffffffc010573f28
[    0.000000] x23: ffffffc01002b710 x22: ffffffc0105fa450 x21: ffffffc010573ee4
[    0.000000] x20: ffffff801fffb7d0 x19: ffffff801f401000 x18: 00000000fffffffe
[    0.000000] x17: 000000000000003f x16: 000000000000000a x15: ffffffc01060b940
[    0.000000] x14: 0000000000000000 x13: 0098968000000000 x12: 0000000098968000
[    0.000000] x11: 0000000000000000 x10: 0000000098968000 x9 : 0000000000000001
[    0.000000] x8 : 0000000000000000 x7 : ffffffc010573ee4 x6 : 0000000000000001
[    0.000000] x5 : ffffffc010573f28 x4 : ffffffc01002b710 x3 : 0000000040000000
[    0.000000] x2 : ffffff801f5fffff x1 : 0000000000000001 x0 : 007800005f400705
[    0.000000] Call trace:
[    0.000000]  apply_to_pmd_range+0xec/0x190
[    0.000000]  __apply_to_page_range+0x94/0x170
[    0.000000]  apply_to_page_range+0x10/0x20
[    0.000000]  __change_memory_common+0x50/0xdc
[    0.000000]  set_memory_valid+0x30/0x40
[    0.000000]  kfence_init_pool+0x9c/0x16c
[    0.000000]  kfence_init+0x20/0x98
[    0.000000]  start_kernel+0x284/0x3f8

Fixes: 840b23986344 ("arm64, kfence: enable KFENCE for ARM64")
Cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20210525104551.2ec37f77@xhacker.debian
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6dd9369e3ea0..89b66ef43a0f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -515,7 +515,8 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
-	if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
+	if (rodata_full || crash_mem_map || debug_pagealloc_enabled() ||
+	    IS_ENABLED(CONFIG_KFENCE))
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*

