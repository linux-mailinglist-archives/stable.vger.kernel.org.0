Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA81D7A20
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgERNho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:37:44 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51695 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgERNho (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:37:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 508841940A10;
        Mon, 18 May 2020 09:37:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vnuzox
        /o+7ClX0fjfwETanMhR1GtH6Xi2f6hOEJDMjc=; b=aIMV+qEjY7kBmpyqynkzLL
        L/Gm77aUet3PD7V8wv1epizo1MQFvzjuMcESMKZIqDqllC7BjQ1cCoqDCHjooKlf
        rWoXs7fVw0QEeJ/UzA8lIwn67Zam76btUAwWaAZvWlWqzEHYA5MwRPubB4jZKZ3I
        /e3FBRQjd3eFhGUvLIFI4YmIJ11WBYANGsn1jcagwCiTIXY39pzeVlU4tTSgir2D
        nrf0mC5l3fqfktqtyntg5FhbTIqU8YWj7paMiSD127/FYj5giwVlbBuLYkm0J8rj
        h/87ZqkCNL6I0r+ZEwz4UyUmWuW0LFTdSUpBvU1CfxqFlQyPvTUzyix5feMjz1zQ
        ==
X-ME-Sender: <xms:p4_CXhlhFqlzPpjh1-c9fOvypVMneoVIYZ-EVLfXwP4hbnotYRiZqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:p4_CXs3pxZJhc_jy318Y6Kwx9gGLixZixN65VI19Js-lZJczX4IgDw>
    <xmx:p4_CXnoSr5SORjU66mbwegNT9OX-LUNXx3cak-ps9i6i9EQNqoL4KA>
    <xmx:p4_CXhnmf7IECfXRICpCZrpgXizZ6chkaLK2XNLN856EgUV1TTxNOw>
    <xmx:p4_CXkipHmV2MHE0BIz077mW4ZJEcS-B8LdoNeiZZCyLLL_17sDC3A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E25A130663FF;
        Mon, 18 May 2020 09:37:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: fix the flush_icache_range arguments in machine_kexec" failed to apply to 4.14-stable tree
To:     hch@lst.de, catalin.marinas@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:37:33 +0200
Message-ID: <158980905320474@kroah.com>
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

From d51c214541c5154dda3037289ee895ea3ded5ebd Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 10 May 2020 09:54:41 +0200
Subject: [PATCH] arm64: fix the flush_icache_range arguments in machine_kexec

The second argument is the end "pointer", not the length.

Fixes: d28f6df1305a ("arm64/kexec: Add core kexec support")
Cc: <stable@vger.kernel.org> # 4.8.x-
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 8e9c924423b4..a0b144cfaea7 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -177,6 +177,7 @@ void machine_kexec(struct kimage *kimage)
 	 * the offline CPUs. Therefore, we must use the __* variant here.
 	 */
 	__flush_icache_range((uintptr_t)reboot_code_buffer,
+			     (uintptr_t)reboot_code_buffer +
 			     arm64_relocate_new_kernel_size);
 
 	/* Flush the kimage list and its buffers. */

