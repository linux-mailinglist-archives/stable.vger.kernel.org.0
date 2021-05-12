Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47B837BB21
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELKqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:14 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:59129 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhELKqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:14 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 4B48C12DD;
        Wed, 12 May 2021 06:45:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kqterB
        F92iMUK46tZOTG0TErM5wlcuvb6EvF1TURTPU=; b=cs73j+YAfX1BftMNEjJ/ZF
        WIbmAVKAvM50xjbF39PpNYHbekRgVPkApG8om4MrMQnlzkSwxqxGm95waWYfJR1C
        wpMhXVE/eOEP5Qy3ZoSjboY93AL9cvMvvlnyXYs4u2Rm4cscmcryl5iV/UYO1TsK
        nEHw7e6IevAb/63fUyDOvn4eFSBfVzBgchgyZeJIG+o80E6441Gogjcoe3X9DvIV
        7MavdqESaG3s9/1qTf0JjY/pEa+AmPEXZMCXmayxSVUNoM5n4VJbnY7sjka/G3/V
        xJ9JyP+xbKv+IvYOQC/pkTKAn39rfFnqu3tLkON5vpogBSunFPwmuTt/IpcdsnFw
        ==
X-ME-Sender: <xms:sbGbYAxYC8uyq4ksNSxtW5zmQTVclDPLAGA_Pwnx3c53njl5Xwz4Eg>
    <xme:sbGbYERh9X_Ec17bpntj3RFCx2GZMDWFX93kB4GxYDRIFU5Zr9b8sGY4_Z1vZYuN9
    IAAfZoSnchA-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgfejgfeggfelvddtffelkeeggeffffetlefftdeuhf
    ehffeuffejtdehtdeggfehnecuffhomhgrihhnpegsrghsvgdrrggunecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sbGbYCXa7YqbfTuGsxYVnkXCyBSAC3BOjz1O-hoahL7aw3K4dSGIeg>
    <xmx:sbGbYOiLQk5wrk2pHlwBA-m9mmo9SK5Zu9xgg4QKsnB5-bCzZutK8g>
    <xmx:sbGbYCDGK4L0bm1Ye46hY0u19HaV9m4aCSnORDcMm-d7mXpuwqO77A>
    <xmx:sbGbYNo2zE15s6M5RhpTV5cQB7iPxpgIXrxGoFabebNdS8GavtZz4B6OJKM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Defer the MMU reload to the normal path on an EPTP" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:44:56 +0200
Message-ID: <162081629638108@kroah.com>
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

