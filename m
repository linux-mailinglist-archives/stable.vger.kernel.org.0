Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0112237BB0A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhELKo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:44:28 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60251 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230268AbhELKo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:44:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 19450131B;
        Wed, 12 May 2021 06:43:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QOTZ1H
        CFPzV4fH5sL49LvrKDoTZOjqFQkYyZQTOtnA0=; b=kOr1u/WHiE5CC5prUCbexh
        YPV5sde6sOSoYp0/Dri7974LhUvfnfCVqPjizyMnh4quF9pkECcMFi5qpurxpFnj
        9qiq3Y3x3QbNNxJ/3GJJtW2ZBHL3eknZvseDrubjZIis/VIT5FM7KcpZYVlHGGgc
        I4DAFYFXyoexyN68f8wK/VLglJQVsuWO2EtfBhS2NQYqJVRwHFuEEX5uASfA2JDe
        h6rgAAnJp9hXAlajLFRJniCiD4US8YzVD1CbyIA4MVw2ERe27f5blNckwmcVMpmM
        Ye+uyBQ67iys6TNys6H0IdEKyxCwCnNOfHWCYDYEJ4Rm3/PcUemmy0/kA66N+I3g
        ==
X-ME-Sender: <xms:RrGbYFmEZg6e2eE1BsAAUVbXSWF2kJoTOoTi1gbgNrJ-CM5yXmN6Fg>
    <xme:RrGbYA1skLRcltgsl0OlPND-r85gj6bt30RwBLizhiOdvn_8j5b-SRPY9HZHefePr
    fVIdoKur56LMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepuddvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:RrGbYLoH7nvKLWzef0u2Nkvrmt1NNWUeTHc1KllyOA2XNW1B_3JE5Q>
    <xmx:RrGbYFnSpU8L5cw0JYTswUhoQFt4Zbq9LhKCLOxJdhPcEXVNglUkOA>
    <xmx:RrGbYD1K5jjSWFHnrLZu12wTWFcPSg-FvR5Ld-4ldSok-5WJ7iLsaQ>
    <xmx:RrGbYM9vOQu8_sBBDrTHih4lD_UWTKGJXvV9fB7CzXzVIWhB1_B5eQcDlb8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:43:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:43:03 +0200
Message-ID: <1620816183123148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6f2b296aa6432d8274e258cc3220047ca04f5de0 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Apr 2021 15:34:01 -0700
Subject: [PATCH] KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP
 unsupported

Inject #GP on guest accesses to MSR_TSC_AUX if RDTSCP is unsupported in
the guest's CPUID model.

Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210423223404.3860547-2-seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd8c333ed2dc..9ed9c7bd7cfd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2674,6 +2674,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_TSC_AUX:
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
 			return 1;
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
 	/*
@@ -2892,6 +2895,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
 			return 1;
 
+		if (!msr->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			return 1;
+
 		/*
 		 * This is rare, so we update the MSR here instead of using
 		 * direct_access_msrs.  Doing that would require a rdmsr in

