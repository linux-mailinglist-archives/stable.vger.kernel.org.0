Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED01237BB33
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhELKrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:47:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39985 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhELKrm (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 May 2021 06:47:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 21CD812B6;
        Wed, 12 May 2021 06:46:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CBM315
        VBgZ8X9ykUeG1NFQ++JA2rX7FDcb4XLm3QuWY=; b=izgbaVDsUMYtMoAb4w7cak
        vImjkvIII5A6WWNmrUzl6U6PWgIZb7I4KhnuMDb6+cXoir6KPBiGah4IWFLmR0eD
        8g/B0hmQSUy9nyAgmtjSPE9kBsrp7VtNFosWOs7jc9zQ2mzaB/rwp6DEOWFXh0Yg
        JKZQwGtem0XpgQJVTrA0paxLYcVBpMpzWiQmZWgAlOJbrErP3dvkGGfnmM9Ewcnh
        DjIc5AgHCTmdYYdB9dfQPw/QawVnAVwhNKU6zVMalvS1pH8Igj32k7Y0+eqbIik6
        0M5Ze0BJZVnIyUiDei1OIz3WE1Rc3O/ZrKsRwTmLhed0G6inyVc3TmfE1vXaoz1A
        ==
X-ME-Sender: <xms:CbKbYLZWN2bM7PMN-Yuxg0PS3qB98shqOWZebMGYqX94-Zgp58Ns6Q>
    <xme:CbKbYKaLNUnJEHQ2ZSKnuH7ISrpyANtov00Ajy-mpexYjFBuiW5m-9XeoxkuQXXzS
    qdmDiAfu8bedw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CbKbYN_xq-9ZVYc6d68pdFf4raTY46mgS-BTRXwjyy4mquHI-TXXUw>
    <xmx:CbKbYBrC-ydK8PfjEs8KKSJbAfNUkI4ts2Gw80i2cnCWZbuFcxa4-g>
    <xmx:CbKbYGrF0O5KvUjLb6kwuK1pe54c8dt6G2TMb5I6zyeAWRrZO2nkUQ>
    <xmx:CbKbYN1Vo47G-23PB5u3ZRGAMseTOvlqX5w-YydtSb08vTZPBv98KDlGp_k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read" failed to apply to 5.4-stable tree
To:     eric.auger@redhat.com, Stable@vger.kernel.org, gshan@redhat.com,
        maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:24 +0200
Message-ID: <1620816384135235@kroah.com>
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

From 94ac0835391efc1a30feda6fc908913ec012951e Mon Sep 17 00:00:00 2001
From: Eric Auger <eric.auger@redhat.com>
Date: Mon, 12 Apr 2021 17:00:34 +0200
Subject: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read

When reading the base address of the a REDIST region
through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
redistributor region list to be populated with a single
element.

However list_first_entry() expects the list to be non empty.
Instead we should use list_first_entry_or_null which effectively
returns NULL if the list is empty.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: <Stable@vger.kernel.org> # v4.18+
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 2f66cf247282..7740995de982 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -87,8 +87,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
 			goto out;
 		}
-		rdreg = list_first_entry(&vgic->rd_regions,
-					 struct vgic_redist_region, list);
+		rdreg = list_first_entry_or_null(&vgic->rd_regions,
+						 struct vgic_redist_region, list);
 		if (!rdreg)
 			addr_ptr = &undef_value;
 		else

