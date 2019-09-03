Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABECBA72A7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfICSk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:40:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37275 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICSk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:40:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A72D922106;
        Tue,  3 Sep 2019 14:40:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z5KqtB
        qz9H8Psc0BnbRJMXgn4AqVt/qXem9IjOmE7Bs=; b=1qEbw7VAW6i8Y60RvEqe/e
        VYK8TkxazuWWemhL8g+r2o3Y1GEkZKu6q+stkfFZ86YWHlFwYzm6DPibKnP4phaO
        MAcPGmF9Jq3gPtOiw2yjfq5c0bTeYbfPBDwafaPsmbgeZbfPVXhZqU/E0lgR8b8G
        nuwbNL5zTlj/t2s0kNfUHEGAWGAaPaefipB5kVpksTGKNl09Bluu2qiRaL9WYuNI
        KfYvcTSAMTo3id1KMucyHOpq5j04tRWUAHr6O3GWva3fHUnYno3I5w0WlpaRzKEX
        NMZ44nlqeh9RJ0LaXMF7P0OnOHddp5ws0w42caUYrjPTAgQkehR0Kbx4h9GXximA
        ==
X-ME-Sender: <xms:uLNuXSCgM7-43f4KPOwp1bJEJW9ATeh1k6oJuJ58L4Gz9fK5lHNnXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:uLNuXeebcYKeQRiXzeEysPiW_59K8DwrcHE2MXlUdkNfK4_nylpehQ>
    <xmx:uLNuXf_e6lbFuQh6wcBjdNMxjgfv5oQ0SXHgp-J-4B5Nz0vySstztA>
    <xmx:uLNuXeEy4J6TGCDLRC0FXiPEHsOOo_Cu9lnrjX4YQ8_bk6j8N9pC3A>
    <xmx:uLNuXQhzSWwVY9XJLo4inSjQ8JUNBLBvpTxU6A47qlCsYjDnbLmpzw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4144CD6005B;
        Tue,  3 Sep 2019 14:40:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0" failed to apply to 4.19-stable tree
To:     maz@kernel.org, andre.przywara@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:40:55 +0200
Message-ID: <156753605576100@kroah.com>
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

From 82e40f558de566fdee214bec68096bbd5e64a6a4 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Wed, 28 Aug 2019 11:10:16 +0100
Subject: [PATCH] KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0
 as WI

A guest is not allowed to inject a SGI (or clear its pending state)
by writing to GICD_ISPENDR0 (resp. GICD_ICPENDR0), as these bits are
defined as WI (as per ARM IHI 0048B 4.3.7 and 4.3.8).

Make sure we correctly emulate the architecture.

Fixes: 96b298000db4 ("KVM: arm/arm64: vgic-new: Add PENDING registers handlers")
Cc: stable@vger.kernel.org # 4.7+
Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3ba7278fb533..b249220025bc 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -195,6 +195,12 @@ static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	vgic_irq_set_phys_active(irq, true);
 }
 
+static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	return (vgic_irq_is_sgi(irq->intid) &&
+		vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2);
+}
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
@@ -207,6 +213,12 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/* GICD_ISPENDR0 SGI bits are WI */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			vgic_put_irq(vcpu->kvm, irq);
+			continue;
+		}
+
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq->hw)
 			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
@@ -254,6 +266,12 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/* GICD_ICPENDR0 SGI bits are WI */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			vgic_put_irq(vcpu->kvm, irq);
+			continue;
+		}
+
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (irq->hw)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 6dd5ad706c92..1059ce2ebfdf 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -184,7 +184,10 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		if (vgic_irq_is_sgi(irq->intid)) {
 			u32 src = ffs(irq->source);
 
-			BUG_ON(!src);
+			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
+					   irq->intid))
+				return;
+
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
 			if (irq->source) {
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index c2c9ce009f63..f7a4219f4617 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -167,7 +167,10 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
 			u32 src = ffs(irq->source);
 
-			BUG_ON(!src);
+			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
+					   irq->intid))
+				return;
+
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
 			if (irq->source) {

