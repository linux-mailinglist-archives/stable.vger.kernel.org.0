Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74B537BB0C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhELKol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:44:41 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34081 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKok (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:44:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 62130E89;
        Wed, 12 May 2021 06:43:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:43:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aqUL1Y
        2Bg0D3BuEkPMxzAQcNvvkZ+Z183Iu7EWT1RhQ=; b=hFPfXK8PImOhPHFuDDXnFE
        Ggz28gjudqNFxS5XwwxzUhSy0yLaKziZDqtePn8ESJthL/IrGxwYiffqU92Dh3io
        NeDc3deyFXaWJstBhUSGJGGBKcKadfx/ljy8CKeCJBjPVJkfAB6krl9SnWu1Zfya
        DvQCFx81Q84avgqrbdV2L2SqpFWFGuJzFo0F6PKGdEPOAIdyWwKNkvr9Qcv2V/IU
        I7cZs/ruLrjBM1P6QbBa3KZSd40XfGjXFFa2FXuMOM/JtctcTvBGph7mzSQTEw43
        bNOtdh6X/0plh3nVkSgwUQE39yl57st5RbqSq9R5Cn816mGp2ecDnLcKXSrCNZrg
        ==
X-ME-Sender: <xms:U7GbYNVBHrvoJAJ2r7assaJJHMyRx0kjgBMTJ8mlCakNQHENoUuYgw>
    <xme:U7GbYNmBWYlsPXU83FmHwIawUBI7QKWQh1Ve1QomyBDUHRxMjcnWZLiRd4eNycf2q
    cEUr9DZl6qeVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:U7GbYJaXMb8oU4KSZG1qwXAhh6-PrgC7VjCE9Uiny2S65SgY3fmabQ>
    <xmx:U7GbYAW7eQ0rVbEle0lVQUUqY04-wGmarpzyuaHmQy8cZWj_Jr01Ww>
    <xmx:U7GbYHnjuhUnLHTmNuD5fRMl-d6rZ7FRU_sq3e9T7wSRBSwf-YTYqg>
    <xmx:VLGbYGvRha0vNkCdEVYXJM5w8wvlAzNbjLNSrXRnmVyZqzdLRtT1vR_nwDg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:43:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Make sure GHCB is mapped before updating" failed to apply to 5.11-stable tree
To:     thomas.lendacky@amd.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:43:30 +0200
Message-ID: <1620816210208245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3ba26ecfb569f4aa3f867e80c02aa65f20aadad Mon Sep 17 00:00:00 2001
From: Tom Lendacky <thomas.lendacky@amd.com>
Date: Fri, 9 Apr 2021 09:38:42 -0500
Subject: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating

Access to the GHCB is mainly in the VMGEXIT path and it is known that the
GHCB will be mapped. But there are two paths where it is possible the GHCB
might not be mapped.

The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
However, if a SIPI is performed without a corresponding AP Reset Hold,
then the GHCB might not be mapped (depending on the previous VMEXIT),
which will result in a NULL pointer dereference.

The svm_complete_emulated_msr() routine will update the GHCB to inform
the caller of a RDMSR/WRMSR operation about any errors. While it is likely
that the GHCB will be mapped in this situation, add a safe guard
in this path to be certain a NULL pointer dereference is not encountered.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Message-Id: <a5d3ebb600a91170fc88599d5a575452b3e31036.1617979121.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d7a923712ca9..bb4bf5ffb104 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2104,5 +2104,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
+	if (!svm->ghcb)
+		return;
+
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6c39b0cd6ec6..4fc1f16505db 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2757,7 +2757,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!sev_es_guest(vcpu->kvm) || !err)
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
 	ghcb_set_sw_exit_info_1(svm->ghcb, 1);

