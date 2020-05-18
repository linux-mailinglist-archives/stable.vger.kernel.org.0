Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875571D7A1F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgERNhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:37:37 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53363 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgERNhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:37:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0FBBF19409FC;
        Mon, 18 May 2020 09:37:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JIuH0C
        1AhBzX11+OsbMOZ6OkCYdX8QgCtRVK9Hw91o8=; b=M9IALzhLJqsf+0SenAzOPX
        gK+oS77mKsyDV5ckCz5YYI4IoKxS0rTVbHst9ZqpJ+HTljJ9FV1wKRSoPeulpZc7
        nzlP4JwJB0ictVarYH6mr6vXE5De4H15GltLgRtd/KRnH8Yk+DdWqsN81m3l6Q7K
        Ed/t/06zR3mQsKklk71aBnYR3XH9dWb75ypQDI1ynbqpDGEWmeJAwPz64e9j+ZvN
        ob8Hec1mWHfM9ZzPRAz5MYqxSlyXOsFC4y270ImTlAAXNA20IEvXEmrOwLR674O/
        UY8oJZn7lTTE7FqT5SCqVsafMMJlboGDhwu4xj3dVddySLbqjmktE19+gtoXwZ9w
        ==
X-ME-Sender: <xms:n4_CXqzlt22sm4VRSQ2vz-3hpSuaSOEIUhL1BVdcVhhhQreVq4YsMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:n4_CXmRuKxo05kJ24U2xGeqSlF4KLDEhDXsj77yY9yVPGHoivOILow>
    <xmx:n4_CXsUwPJ0ZGBeFasu98yRaaBxV4_C8ETdmzJcxIsgxG2nifNW1ig>
    <xmx:n4_CXggu8RbVZThGNtEBuLjQmJLyJZs8b2VPOxdOrcA0DSOqzprxbg>
    <xmx:oI_CXr-JYdmCte_PvZoESE7ZmkzxhpxzhIynDuJi26hcXDn78_X_Zg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 286E030663FA;
        Mon, 18 May 2020 09:37:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: fix the flush_icache_range arguments in machine_kexec" failed to apply to 4.9-stable tree
To:     hch@lst.de, catalin.marinas@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:37:33 +0200
Message-ID: <158980905396228@kroah.com>
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

