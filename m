Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0858579097
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfG2QRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:17:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38785 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbfG2QRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 12:17:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BFFFE22185;
        Mon, 29 Jul 2019 12:17:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 12:17:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=E7gwMD
        XvO8jdaP6GdtCnlbaKZunb0KFg9JMEXLfdEl8=; b=GTmxZS5vuefeX5rub4DRrr
        uNjaJj9CQy7rIpsWNo8GO1LDmBjxSmq75HAB9/FvQW3ZxmoCHcEiWf6YCAN+vl0v
        s9TYvNqI/xOIxDYUP0abqtZQWdqJjuLF1eSIoZAFdai4QqOuB40t5SfzfNaFcYd/
        mJcSAamclP4ILpMj4FRG0QTukywyPHs78Bnz6AyBP/z44JfnKWNa+hgLHZeiNEot
        AYDSoO4WWM5GPBW0+gAVF4oVQwBJtUKSxYnRItu0Ho83FdGNI8st099lrBEvcNXl
        HP3lOzX93XqEr1+3kI6ByqI9UnR3+OSwECiyxfNEPjb3+k12JV+RTuzlJm6jTueg
        ==
X-ME-Sender: <xms:Cxw_XVz2mw6Cy2i7Z2h0oIrEGS77dgPVOpS2uQSpukqLdveV4JqvkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Cxw_XWBcBKOCmlFrEZfNF9r-ZAcSiadDMu3qLr4-0xUGnj13QGrKJw>
    <xmx:Cxw_XbeziUtNblcoDL1qqYQjnwlROmPIHV180wePWbT790wRhJLkxA>
    <xmx:Cxw_XYll1E3UamEWHKnlN7epUG9mGux2I1d29SznvY6iuzHE5T38SA>
    <xmx:DRw_XSUnUwLfg5vmpNsoD3fEzPh6Dgf2-nsh4neGvpqVLSHKhq0_pQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6362380085;
        Mon, 29 Jul 2019 12:17:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/mm: Limit rma_size to 1TB when running without HV" failed to apply to 4.19-stable tree
To:     sjitindarsingh@gmail.com, david@gibson.dropbear.id.au,
        mpe@ellerman.id.au, sathnaga@linux.vnet.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 18:17:12 +0200
Message-ID: <15644170325254@kroah.com>
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

From da0ef93310e67ae6902efded60b6724dab27a5d1 Mon Sep 17 00:00:00 2001
From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Date: Wed, 10 Jul 2019 15:20:18 +1000
Subject: [PATCH] powerpc/mm: Limit rma_size to 1TB when running without HV
 mode

The virtual real mode addressing (VRMA) mechanism is used when a
partition is using HPT (Hash Page Table) translation and performs real
mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this mode
effective address bits 0:23 are treated as zero (i.e. the access is
aliased to 0) and the access is performed using an implicit 1TB SLB
entry.

The size of the RMA (Real Memory Area) is communicated to the guest as
the size of the first memory region in the device tree. And because of
the mechanism described above can be expected to not exceed 1TB. In
the event that the host erroneously represents the RMA as being larger
than 1TB, guest accesses in real mode to memory addresses above 1TB
will be aliased down to below 1TB. This means that a memory access
performed in real mode may differ to one performed in virtual mode for
the same memory address, which would likely have unintended
consequences.

To avoid this outcome have the guest explicitly limit the size of the
RMA to the current maximum, which is 1TB. This means that even if the
first memory block is larger than 1TB, only the first 1TB should be
accessed in real mode.

Fixes: c610d65c0ad0 ("powerpc/pseries: lift RTAS limit for hash")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190710052018.14628-1-sjitindarsingh@gmail.com

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 9a5963e07a82..b8ad14bb1170 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1899,11 +1899,20 @@ void hash__setup_initial_memory_limit(phys_addr_t first_memblock_base,
 	 *
 	 * For guests on platforms before POWER9, we clamp the it limit to 1G
 	 * to avoid some funky things such as RTAS bugs etc...
+	 *
+	 * On POWER9 we limit to 1TB in case the host erroneously told us that
+	 * the RMA was >1TB. Effective address bits 0:23 are treated as zero
+	 * (meaning the access is aliased to zero i.e. addr = addr % 1TB)
+	 * for virtual real mode addressing and so it doesn't make sense to
+	 * have an area larger than 1TB as it can't be addressed.
 	 */
 	if (!early_cpu_has_feature(CPU_FTR_HVMODE)) {
 		ppc64_rma_size = first_memblock_size;
 		if (!early_cpu_has_feature(CPU_FTR_ARCH_300))
 			ppc64_rma_size = min_t(u64, ppc64_rma_size, 0x40000000);
+		else
+			ppc64_rma_size = min_t(u64, ppc64_rma_size,
+					       1UL << SID_SHIFT_1T);
 
 		/* Finally limit subsequent allocations */
 		memblock_set_current_limit(ppc64_rma_size);

