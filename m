Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F10937BB3E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhELKs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:48:59 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:45045 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230160AbhELKs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:48:59 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id D5D1D12BE;
        Wed, 12 May 2021 06:47:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=efPfI5
        q7uOx6rwEOZ4t0Jk9vv27AVEkNaiNCLuIOIbs=; b=A1GKcQgn9zcAc4i24ARY5O
        YIzjHg5PZ2Hiln/mou81Qfi3XeNLmOCXAaLZXttQHDX6Aji/Dnf5gcfEQ41y/gyw
        k2yH9OydeszFZMCeion9aRcZThx0KaSDpCEBFQrQfLKPuZY2Lq1t7mzCGVp0ZkxQ
        Pqd49KlM/a9x/i/+9mJwPl2bExcYyQF107QjjCOi8d1hk3c5T7wsIO4dLvh6ro4W
        1gmmcETPVfDdiAsl+V2SAV8ULe2qORFjs0AXinlgxg3xDZdMMtDY7tV1YXyz8PzC
        6+nR/D9K8GuFvOwezeQz5M/U05i2Pe1CqNuc87MWcSpI/8qgY1PjXTthyKeu8kjA
        ==
X-ME-Sender: <xms:VrKbYE_frb4l9NB5V4K9_Uffs1Dtc78ZVgJXhnhzBaFicSPEJtg_kg>
    <xme:VrKbYMsqcw3MUAEGaYUSSWn6ZmFyd7tRlyNyP8BJiUlnSo_t-olRBhihs_27si2QH
    o4353XO8ksY8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VrKbYKDy_6bEL4-6clbnP989FQC5Mo8jwv5fGxgvgnUrqLwthLAlig>
    <xmx:VrKbYEd6Wb-Xty-Wr9w7VN-twiIbznm2yNLpQ0FiBH8Q7uNnN-cM9Q>
    <xmx:VrKbYJOerGSd4KBCFHDXBXqDu9MtnHemeMy8cE52LbukuwRjW_DAJw>
    <xmx:VrKbYH3nFB6GUYOYcj000j9jfjrrru8NNgsE6EX__duVjn3Lthee2SAkwp8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:47:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read" failed to apply to 5.4-stable tree
To:     eric.auger@redhat.com, alexandru.elisei@arm.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:47:40 +0200
Message-ID: <162081646096133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 53b16dd6ba5cf64ed147ac3523ec34651d553cb0 Mon Sep 17 00:00:00 2001
From: Eric Auger <eric.auger@redhat.com>
Date: Mon, 5 Apr 2021 18:39:34 +0200
Subject: [PATCH] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read

The doc says:
"The characteristics of a specific redistributor region can
 be read by presetting the index field in the attr data.
 Only valid for KVM_DEV_TYPE_ARM_VGIC_V3"

Unfortunately the existing code fails to read the input attr data.

Fixes: 04c110932225 ("KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION")
Cc: stable@vger.kernel.org#v4.17+
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210405163941.510258-3-eric.auger@redhat.com

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 44419679f91a..2f66cf247282 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -226,6 +226,9 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
 		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
 		if (r)
 			return (r == -ENODEV) ? -ENXIO : r;

