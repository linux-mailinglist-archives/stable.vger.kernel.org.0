Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26337BB32
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhELKrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:47:36 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33877 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhELKre (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 May 2021 06:47:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 264841219;
        Wed, 12 May 2021 06:46:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e6QgLB
        qYum02abzAXhoqHGsiX5RokqZhHe951HGZasY=; b=tkHih+aC2GBQYjDpfA3O9M
        auRjRL0h3uCb6Fma4KNF0SEANlPOz3Azgf6cKG1e0BsUeQwCjKs6HwPF1V7iyyQ6
        RI/8rIS1yke+J24op7FeTVWe4WsV36oyzKMgTkg4HwTyetpngmpOibSaTpYdOya5
        vqVeXFhO94aP9rUuNwMgBpod/EV44M/1aKT+skgLZgP1RBSBxkPouVBEnEZ9sP2c
        95/mtuyc02q1/5KCThprBeyHzx18xxbtASAl0O+ij/eBvLohSgENe6qCeiLZUSh+
        PlfRL3jKLYX81XdzId+GQV6Fmk9z92CM0BZArsB4dSDwkMh5xIKW4ariuacgCWSg
        ==
X-ME-Sender: <xms:AbKbYH2bIL-QIDFVPKnJ4BC9H_6gCw4guPNq0FUjW3XtIyDpZv7zKg>
    <xme:AbKbYGGexrHWg3HQbCFrT4S4VqpGo10zWqvk9wIUDg6l9yLlgheELaaSI614lu94c
    ok6v7JQFLb_qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AbKbYH7tqDpvBXic72A0xYJqbCyr_Ds_v9Heu7cQaSaaLITnmSNSrw>
    <xmx:AbKbYM2-VzhikaxToYsr_AkthwzVQGyJSSrXGn47WsdMD53j8AMnHQ>
    <xmx:AbKbYKEvCLpJ0AhM0gQkttfpY5BEZf2A9bygPF-IE9aZ1pjlQSSG4g>
    <xmx:AbKbYPQvs66a7VxGehE0HDM6_8AL5dA535hje3sAsfqo3zM6dw4TKLMBer8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read" failed to apply to 4.19-stable tree
To:     eric.auger@redhat.com, Stable@vger.kernel.org, gshan@redhat.com,
        maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:23 +0200
Message-ID: <162081638318160@kroah.com>
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

