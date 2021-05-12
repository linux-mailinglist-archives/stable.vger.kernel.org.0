Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77FE37BB01
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhELKnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:43:22 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46017 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:43:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 73550194043B;
        Wed, 12 May 2021 06:42:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5miMd1
        YFJKQOEgBFKElybvM4jiRidC+5DXrrA6p4O5U=; b=VtTeS7JnRa8U3NEkYPUJIh
        ImhFBDbjNbSOnEpUQ1bVy1/lIMcbqqJXoWDdgk/qErVTNE+op8jaHYrDR0UDvaGS
        zczrP+eGpFCzETjnghcSi3G6hLYankWXcB8R4Gzw3e7mwYnHD/ZvD4s1DmJQkTJE
        mH9ESLz4pDlZKhoX15gPT6OJrmu/m5oii44YYZpbfOzRTpR5N9CXOjJSHofT/xYN
        o9jVS28Iw7jnd92YlsIDwMXbyxJJOd9RlYYEs5of1OQDZ2v6nNfLiYbbTVCvZnA7
        Hjjv1iSMHQ02rpQQkVpmsiWsDPTXVHnAZt0Jc8d2eHRk2FYLxVrtRRw8DFq+UWUw
        ==
X-ME-Sender: <xms:BrGbYNnkJfnIpCrEhhbZc-jh0_VFw1lIzYXLP9XiatlcVHSzXdzphw>
    <xme:BrGbYI2Cv44C51fWhGBQ5K3I1h5zVJoG2cVMhj21OVpbthLPKKBvmIH3KU0Hw5HjS
    r44yh0KRLjDFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BrGbYDqcMW5jxEVFousm8PRmJWpH2aFGiZuRSQSKcsvtpf2SY8lLLQ>
    <xmx:BrGbYNkM1xM7fGJaYkhZRO2TU0g7uNZPsDUk9sLHMWTuzNT4NPg-4w>
    <xmx:BrGbYL0ya-oAVW6Z4FDv10R90__fxB6igJ1ITh-WEA7K32GtLeu_bg>
    <xmx:BrGbYJD6cEEL18whrBhJFoL7xh7C6-xUVUbCslt_469S-gj7DyjM6Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:42:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs" failed to apply to 5.4-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:42:04 +0200
Message-ID: <162081612445186@kroah.com>
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

From 8727906fde6ea665b52e68ddc58833772537f40a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Mar 2021 20:19:36 -0700
Subject: [PATCH] KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs
 are created

Reject KVM_SEV_INIT and KVM_SEV_ES_INIT if they are attempted after one
or more vCPUs have been created.  KVM assumes a VM is tagged SEV/SEV-ES
prior to vCPU creation, e.g. init_vmcb() needs to mark the VMCB as SEV
enabled, and svm_create_vcpu() needs to allocate the VMSA.  At best,
creating vCPUs before SEV/SEV-ES init will lead to unexpected errors
and/or behavior, and at worst it will crash the host, e.g.
sev_launch_update_vmsa() will dereference a null svm->vmsa pointer.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210331031936.2495277-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 97d42a007b86..824bc7d22e77 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -182,6 +182,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	bool es_active = argp->id == KVM_SEV_ES_INIT;
 	int asid, ret;
 
+	if (kvm->created_vcpus)
+		return -EINVAL;
+
 	ret = -EBUSY;
 	if (unlikely(sev->active))
 		return ret;

