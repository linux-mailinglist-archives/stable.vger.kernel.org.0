Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36251CF345
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgELL0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:26:53 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:36113 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgELL0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:26:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 257531940B06;
        Tue, 12 May 2020 07:26:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 May 2020 07:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zAWkY7
        uMLmfglbeYuazAyFFYOM+PHtAJxxddtUXUwps=; b=mVkYZ2y7AGJwGay5fdeGg5
        G4SjHjSaoc2fV4ErfVkGBIDjQtdn3F6TOh0jKksWe7katgkE95pX0vHJ5jgBvnH3
        gTVUHltlwIstkjOL4penkPKDPhS8kMKE92+jPcQGvYmKR9pUHnaViBSDIQnmT92B
        8i8chFSHZSXu0lkh9qaOhx17e9HhSqjR5VSdpLidtIQFrHWHcjkBcD4venNUpU9v
        wpKzZB/EuCNPzC+B0lEctNT9689ls2WFwLa59W1XsN7V1pKgs1FO5S7y/8Bw4NoM
        t6rAb4/ExN2kgINXlcew3a/0aSFK4f84AxnTwCPXalJsUUdSxfL5LIJOLkmzwD8A
        ==
X-ME-Sender: <xms:_Ie6XoKCxA4sKbRUcj8wPdyKOWVcakV-NGEJvzobv-7QOZg50vhmOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_Ie6XoJ5uiof92myBNZ41l87LB8hdWu_8ou-izYwb6dbKrBiGmM-1Q>
    <xmx:_Ie6XovgyHHvGCfrbGewCREPUTKRPQWm9EgMskpgkGezWIr5tzF8HQ>
    <xmx:_Ie6XlbpS7v7RodvNyL8p2mAu7EGVOhSEL58AZSusP9OqMufS5Vlkw>
    <xmx:_Ie6XmyJeokdpnHGbXmW-jvcZB8yVBbl8_1IqSlc2tMVBFoeNfmwhA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8D183280063;
        Tue, 12 May 2020 07:26:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: hugetlb: avoid potential NULL dereference" failed to apply to 4.9-stable tree
To:     mark.rutland@arm.com, catalin.marinas@arm.com,
        kyrylo.tkachov@arm.com, stable@vger.kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 May 2020 13:26:42 +0200
Message-ID: <158928280292134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 027d0c7101f50cf03aeea9eebf484afd4920c8d3 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 5 May 2020 13:59:30 +0100
Subject: [PATCH] arm64: hugetlb: avoid potential NULL dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The static analyzer in GCC 10 spotted that in huge_pte_alloc() we may
pass a NULL pmdp into pte_alloc_map() when pmd_alloc() returns NULL:

|   CC      arch/arm64/mm/pageattr.o
|   CC      arch/arm64/mm/hugetlbpage.o
|                  from arch/arm64/mm/hugetlbpage.c:10:
| arch/arm64/mm/hugetlbpage.c: In function ‘huge_pte_alloc’:
| ./arch/arm64/include/asm/pgtable-types.h:28:24: warning: dereference of NULL ‘pmdp’ [CWE-690] [-Wanalyzer-null-dereference]
| ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro ‘pmd_val’
| arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro ‘pte_alloc_map’
|     |arch/arm64/mm/hugetlbpage.c:232:10:
|     |./arch/arm64/include/asm/pgtable-types.h:28:24:
| ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro ‘pmd_val’
| arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro ‘pte_alloc_map’

This can only occur when the kernel cannot allocate a page, and so is
unlikely to happen in practice before other systems start failing.

We can avoid this by bailing out if pmd_alloc() fails, as we do earlier
in the function if pud_alloc() fails.

Fixes: 66b3923a1a0f ("arm64: hugetlb: add support for PTE contiguous bit")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Kyrill Tkachov <kyrylo.tkachov@arm.com>
Cc: <stable@vger.kernel.org> # 4.5.x-
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index bbeb6a5a6ba6..0be3355e3499 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -230,6 +230,8 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 		ptep = (pte_t *)pudp;
 	} else if (sz == (CONT_PTE_SIZE)) {
 		pmdp = pmd_alloc(mm, pudp, addr);
+		if (!pmdp)
+			return NULL;
 
 		WARN_ON(addr & (sz - 1));
 		/*

