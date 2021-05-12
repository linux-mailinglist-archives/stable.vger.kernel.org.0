Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337A637BA3A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELKWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:22:45 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:37025 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:22:41 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id EFDE511E7;
        Wed, 12 May 2021 06:21:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RzhgCC
        Vy+bxKEa553gyyz9PbwwNg3D79Uvg76YoAmic=; b=gQnHvJozdEovxx6UeOjQw3
        BGt3qqG69jRA4Bddp2KKqTFqz81LikjC9MbtrQ6gH0DTrXY9LDHBgQV9RC3hzYJQ
        MQlnuLnkiVHFhBQrIVph3lAcn/tVHM9N7qbBwOydBU6QT3Rczb0lVP5Ebc0EBx1U
        dL4sWj75aLcTN6TE+diaL9F8U784c1URQoHNYbYVFxOAuct6LmpG+oRDBBZh0fW0
        kT8aAERrXrcvkLX7K6S5mHGeqgXEhwZgE3bp6nZf/Ycx3T1LEVQMaoNB1qweXz1R
        Kmk7hbwx2TYznrovvByqXlbCs2y0tjNqNCo0PoJLhX46Jsk82VgCBJhvRVjRsdoA
        ==
X-ME-Sender: <xms:KKybYAhKc85Vlg26jwzfH3PGzXQZ_SF31-6XEI7u1d5_-Jlv4HKLiw>
    <xme:KKybYJDR7_JcBVL9pnTcx-WdYs_c8Fng5uTNR_OEE2TztYbP8_Mi1rSP0iu67vJRe
    VB43fD5D1lwlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KKybYIHyg-5XRaP1r04VlnRsihLtC9lMwQYo9R7nsuxxq-LVk65z1w>
    <xmx:KKybYBST3ct5Cc2LrOc5jI8GRVe3LGXU0MNLIqt_RrBZqyREDeVqUw>
    <xmx:KKybYNxbLwr2oQlZp7J7PvB8WIYQGx3mRTNcziviaGyjZh6v2z-dPw>
    <xmx:KKybYLZ-kgY8SiaQRk9a9ui1-oMPa-0vORj_23ZeQH1FTZAfXN_aW6gxxNg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:21:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: s390: split kvm_s390_logical_to_effective" failed to apply to 4.9-stable tree
To:     imbrenda@linux.ibm.com, borntraeger@de.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:21:26 +0200
Message-ID: <1620814886253179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From f85f1baaa18932a041fd2b1c2ca6cfd9898c7d2b Mon Sep 17 00:00:00 2001
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Date: Tue, 2 Mar 2021 13:36:44 +0100
Subject: [PATCH] KVM: s390: split kvm_s390_logical_to_effective

Split kvm_s390_logical_to_effective to a generic function called
_kvm_s390_logical_to_effective. The new function takes a PSW and an address
and returns the address with the appropriate bits masked off. The old
function now calls the new function with the appropriate PSW from the vCPU.

This is needed to avoid code duplication for vSIE.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: stable@vger.kernel.org # for VSIE: correctly handle MVPG when in VSIE
Link: https://lore.kernel.org/r/20210302174443.514363-2-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index f4c51756c462..2d8631a1f23e 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -36,6 +36,29 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 	return gra;
 }
 
+/**
+ * _kvm_s390_logical_to_effective - convert guest logical to effective address
+ * @psw: psw of the guest
+ * @ga: guest logical address
+ *
+ * Convert a guest logical address to an effective address by applying the
+ * rules of the addressing mode defined by bits 31 and 32 of the given PSW
+ * (extendended/basic addressing mode).
+ *
+ * Depending on the addressing mode, the upper 40 bits (24 bit addressing
+ * mode), 33 bits (31 bit addressing mode) or no bits (64 bit addressing
+ * mode) of @ga will be zeroed and the remaining bits will be returned.
+ */
+static inline unsigned long _kvm_s390_logical_to_effective(psw_t *psw,
+							   unsigned long ga)
+{
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
+		return ga;
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
+		return ga & ((1UL << 31) - 1);
+	return ga & ((1UL << 24) - 1);
+}
+
 /**
  * kvm_s390_logical_to_effective - convert guest logical to effective address
  * @vcpu: guest virtual cpu
@@ -52,13 +75,7 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
 							  unsigned long ga)
 {
-	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
-		return ga;
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
-		return ga & ((1UL << 31) - 1);
-	return ga & ((1UL << 24) - 1);
+	return _kvm_s390_logical_to_effective(&vcpu->arch.sie_block->gpsw, ga);
 }
 
 /*

