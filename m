Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6E21DB13
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgGMQBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 12:01:01 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:57655 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729027AbgGMQBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 12:01:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 798EA609;
        Mon, 13 Jul 2020 12:01:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 13 Jul 2020 12:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FKNJ4J
        cxtQ4gI57VsSNTL725zbrYBDSxMivPz9DQxYk=; b=tip+MNwfmHUK+7mnMA5jPK
        kNuYw0OPpqrtam/2fzEygDO+D8+vxPeXL4mz+ajrbqPelqKgbbS4MUL2hm0gMQQp
        nYo6fLlYViM365tl3P25IOLowcv8C8DpvbdnvlZEM9CdNLc0GTpoeudkn1MXwPpK
        QPRKC6Ffc/YhINzfbDsCwR/szLRCAK8I14euisuTd20Ns13KPeOEmE0e5t2yJmw3
        +plSSmd5xqLBR5JnZegJiSg1maeQUjsvJZkeAOqogPTkh8set7QPNjsezQeUt5+Q
        XkncP+DreNSwvpOMyGa7fWOPCwtmVfU3zOe5a2vJJdmGnHAbv0ehmK5QLikE25dA
        ==
X-ME-Sender: <xms:O4UMX6-bTE1gHlSI9MFcJguFiwHDJ3WIucakwfIZgte8Dfyv_m-zQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:O4UMX6ufx0yggbRXxLtq8AA6C4Y1UaqA-Lv4zUi4KaoANs7IHDqBQw>
    <xmx:O4UMXwD2dn2PdJqu-RCNVHXF_TBy-UxECI98xhdfTKyrE95xwEU56A>
    <xmx:O4UMXycqjllk5gJFIHdulHe7MxsqbCjaayy9yyVh8XXembMK2e74Jw>
    <xmx:PIUMXxXTbMUC13L5wz13Z7YpazVUZ0uoNydxf546WPkR-TbWC5u6DrjVLwI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CCB93280067;
        Mon, 13 Jul 2020 12:00:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect" failed to apply to 5.7-stable tree
To:     steven.price@arm.com, james.morse@arm.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jul 2020 18:00:59 +0200
Message-ID: <1594656059728@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 66b7e05dc0239c5817859f261098ba9cc2efbd2b Mon Sep 17 00:00:00 2001
From: Steven Price <steven.price@arm.com>
Date: Wed, 17 Jun 2020 11:54:56 +0100
Subject: [PATCH] KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect
 with SVE

If SVE is enabled then 'ret' can be assigned the return value of
kvm_vcpu_enable_sve() which may be 0 causing future "goto out" sites to
erroneously return 0 on failure rather than -EINVAL as expected.

Remove the initialisation of 'ret' and make setting the return value
explicit to avoid this situation in the future.

Fixes: 9a3cdf26e336 ("KVM: arm64/sve: Allow userspace to enable SVE for vcpus")
Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200617105456.28245-1-steven.price@arm.com

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d3b209023727..6ed36be51b4b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -245,7 +245,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-	int ret = -EINVAL;
+	int ret;
 	bool loaded;
 	u32 pstate;
 
@@ -269,15 +269,19 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
-		if (kvm_vcpu_enable_ptrauth(vcpu))
+		if (kvm_vcpu_enable_ptrauth(vcpu)) {
+			ret = -EINVAL;
 			goto out;
+		}
 	}
 
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
+				ret = -EINVAL;
 				goto out;
+			}
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;

