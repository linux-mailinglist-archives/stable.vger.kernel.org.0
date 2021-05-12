Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE15937BAFE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELKnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:43:14 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36743 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:43:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C818F1940435;
        Wed, 12 May 2021 06:42:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4jc4ky
        rY2wjdgFDPAblb02sCk9PPHsmTrjIG8cxSUiI=; b=oT1ZkaoH0+qOcm6KE1ukef
        ah+XxMj9/UeHTJwLAOwNvNB9f7sEF5xcuCpY6zfhP52B+rvwwzVkGPgjlJb06vb1
        3FPuk+8l5tRTxVtM7ovFdU7XmhVHxUR6akIxEHJsT0JwOgl1Fae0sSZzfLL9WT3Q
        ROQUMEEfpAhjFvvGSAX+8AYXaGgyiXhx4QH8AAf29hbqMVKmKsczoBHOIoPE+U5e
        iDCMXcwffYM0jPcO4LX8DRrpux4KF7B22GNADFYP/O/v6ooY/p/GYHVJJzQjRQDg
        vLu3kcvTNXrFGJ6uojkAwc9nW8SIcTKijcDt21ULCNXdVbXW05dyFiiSX6DkBFdg
        ==
X-ME-Sender: <xms:_bCbYPgKizR2oO1vtWRAXtyBRFDaO6j71vsQW0ATiMEV5SI0L9-hcQ>
    <xme:_bCbYMCXpL9AHkw9tFSDWJXkAEBBSUkkBg8wwOMFDAl0tCknPqyOE2Xch-e76D0ig
    Z9NDkEKseIeKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_bCbYPF0y9XZPa0gug5YAMqAKJZBqwCVpplMRZfJphq6PZl9VYYzzA>
    <xmx:_bCbYMS8wOOGmxcYOONVlFqk-NPFwDlulgf9siTeDRQBPAorjaPn7Q>
    <xmx:_bCbYMw7nFvoZL7pnSSah_xBkoF1HXt_l7hJoAgV6RBVQRS722Jcrg>
    <xmx:_bCbYH92ju0nw2KbHC-pw7Ov_TdY0nxrwPZB6A_lytRsFmoNC6mVjg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:42:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs" failed to apply to 4.19-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:42:04 +0200
Message-ID: <162081612412076@kroah.com>
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

