Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1918837BB23
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhELKqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:17 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34783 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhELKqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id BC60D12D8;
        Wed, 12 May 2021 06:45:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wvZ68m
        q4u7a+Lya3q+3fBCD3irWuTFwQ9+BeIvuGcG0=; b=k9WCIwvieqCQ8tQHpOwEb/
        KIsCv2Vx3B6FB3a/++4szMbp79PMavnKaTV+f5Xyvi0ZAPtKlnmIaQFouTt6iN+D
        MRe4n3dCOkKmHkiXnj65b7Uctysj2nIYeXNQA5MWsoPBG1VoWqO7sUTiy9bat73o
        srLSV2Jl9qNGqg3LJooMYh7PjprY8QdNDFIi4Vnyz2V4bnQYzd4pRuGMjmNx3HUA
        RTHD67lbfstRxf88YWr9vVMkPTzkHBOHCX67LvJ7RlBwI2XlqfPsA1bxsE4t2QWR
        6euIW2qkISAGmvm8dzFoKqxsgwpSSrXxxYfF0Pu0grU9s3IWKGqw6Djr/Ek/b/YQ
        ==
X-ME-Sender: <xms:tLGbYA-0P2BA8JE3F9G4pKzfqKjJ9ojNdHsEcjFjrj8RckdAIO9HPg>
    <xme:tLGbYItAr37RUJBUFXZoJkEmfbVBsi-cBx9jZf_MaOe747rMqxiN9Chsr4PC7aqEp
    IqCV1lPPw3SDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgfejgfeggfelvddtffelkeeggeffffetlefftdeuhf
    ehffeuffejtdehtdeggfehnecuffhomhgrihhnpegsrghsvgdrrggunecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tLGbYGC1H2boZzyIpjwBl6AUhXI_StnRq5vEVnbjN4Zj-NsT0oEY9g>
    <xmx:tLGbYAfm17H35_dzy21sMG556UDq0j0bs3Cb3Lmfm1_odgK6ch0CTg>
    <xmx:tLGbYFP_Tg4P0Jf47zxrL26o58amtD8B2bO_kV8QmTmGMC9okqFe0A>
    <xmx:tLGbYHUe6tpcKthKM8yD_EiFRBqWB4Ue996ny0_U3Te3M5Ko2mhN5wZvkdg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Defer the MMU reload to the normal path on an EPTP" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:44:56 +0200
Message-ID: <162081629619971@kroah.com>
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

From c805f5d5585ab5e0cdac6b1ccf7086eb120fb7db Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:57 -0800
Subject: [PATCH] KVM: nVMX: Defer the MMU reload to the normal path on an EPTP
 switch

Defer reloading the MMU after a EPTP successful EPTP switch.  The VMFUNC
instruction itself is executed in the previous EPTP context, any side
effects, e.g. updating RIP, should occur in the old context.  Practically
speaking, this bug is benign as VMX doesn't touch the MMU when skipping
an emulated instruction, nor does queuing a single-step #DB.  No other
post-switch side effects exist.

Fixes: 41ab93727467 ("KVM: nVMX: Emulate EPTP switching for the L1 hypervisor")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-14-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bd1343a0896e..d74abd778429 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5481,16 +5481,11 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 		if (!nested_vmx_check_eptp(vcpu, new_eptp))
 			return 1;
 
-		kvm_mmu_unload(vcpu);
 		mmu->ept_ad = accessed_dirty;
 		mmu->mmu_role.base.ad_disabled = !accessed_dirty;
 		vmcs12->ept_pointer = new_eptp;
-		/*
-		 * TODO: Check what's the correct approach in case
-		 * mmu reload fails. Currently, we just let the next
-		 * reload potentially fail
-		 */
-		kvm_mmu_reload(vcpu);
+
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 	}
 
 	return 0;

