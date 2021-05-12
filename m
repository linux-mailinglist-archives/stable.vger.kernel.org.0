Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A984E37BB3D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhELKs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:48:58 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40715 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230160AbhELKs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:48:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 12B9C12A6;
        Wed, 12 May 2021 06:47:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D2gxZd
        m0q22gjB1LaKUfJWNsrrptbllFyzFp0LRue6A=; b=UtpMcjUkDa57ji4j02qyOZ
        K2u6usTQQHWlkdSZCNpJ8XvYPaYU9CWBaGP0iWE2xELLuuxpGtTVtHk+SFcE+mPi
        08tvV4CNzfV7CWXLzf659wp1wMBmMtcqYq9Gn3oij4qYIs7KqM25Ii3ECVONbHlm
        OC+LS6+KB57OQrs8ecfm3npI0KGRXqmRgIdLuPHAE281AW8pU7pKX+y9sIYMaDJM
        QHL/lUSixmq+tWpxyXWTRS6k9ZhffpN7w5iEeOPOpelIxIMu0aNz3s7sAOHTEQv8
        3m1TZZ1lcbbYmQ3V9gAfpm3AzdkExykVIRDvGnhK3mWybBU3vKRyV1Lvqwwoxwhg
        ==
X-ME-Sender: <xms:TrKbYFDOShl03bKwwHUAiPYy_wSOvx0pQ1hvQaK89FhZPc3c5Lo3-A>
    <xme:TrKbYDjU69PGObdCCdcQaSnpDD_o8FZIXaFqrkiFwjt4uMt-5PEl8FOGaQ_yCEJwS
    1R0qbl9CFGUHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TrKbYAkEFEf6DOyuBiwKCTrzM-oX_qNgfIB-BdMWSSpEWba_2FO0UA>
    <xmx:TrKbYPw5VQrg0FuwunnscBZcjtSE2z65tU0RlCL2f1uO5Fj3bSN2uA>
    <xmx:TrKbYKTc9TAqvvHjmJNd3cl07NMnNx3p-eG6jPiHgeLGmnOp-UoqqQ>
    <xmx:TrKbYNIIw0TWyNtznr7WxKTnLLKtsGi7ZVndjTcFhsvHeR53o47GSUvpmIM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:47:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read" failed to apply to 4.19-stable tree
To:     eric.auger@redhat.com, alexandru.elisei@arm.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:47:40 +0200
Message-ID: <1620816460119220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

