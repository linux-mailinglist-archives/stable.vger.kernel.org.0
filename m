Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CAE1F995D
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgFONzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:55:17 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39167 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728510AbgFONzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:55:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id F3F2842A;
        Mon, 15 Jun 2020 09:55:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Or8RTj
        CvgsKiIuqdZgN1231FEvQ5LntnlIYAdn4LEoA=; b=IT69ocPeJ4TVgOXEq56nTV
        Ftd2xZXnReGj48mcH0LZ/fXBT2oowuMLPmxzuejMs2RMx0rlgncQ5SdPahyZI5YH
        YQ9ykKYmMcJwfCvErm60ajQTkT4hAnqu1ZRgF9KK4fgskmF+0CQWImEH+/AcMZuh
        HKq4M9lhmlC61dGqT7tx+vaoqmolYyEH7iYF/K9DAeKrBmvA63uzmXk1Yc0j8qkf
        hON8wAqaSH1hLjOOKHTaCS3mN3mx3pDdkelEE5AdJYS523Ims4Cn8lvNCnaf27w1
        Q0sSiuleulG0BiZE9Ptl417sRxszlEMfB5QKiY0fVRl5z41rJV9qJdj6RDmwNs+w
        ==
X-ME-Sender: <xms:wn3nXms6NbYPYWvjSEMXTjDgJqXwHpZeacBsJHQav3pqXTDje-yVwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:wn3nXrcdwFPWARZyw2pR4kuH_biUHCERw-M7ITLajq4bDL-wEtS-eg>
    <xmx:wn3nXhxpk1G2rgUB47svgUZnyIeXFV-pU4iuIT02wbRVQM0aJ602hw>
    <xmx:wn3nXhNV5p4b6FBJg_cIZS19n6iXQCZ1A_4QlQlmfq4sXL0B4j0YSQ>
    <xmx:w33nXrENos9FV-pmW3Q9d9e8eiE7wItYhsnVfILKjjmtkpXV57OnjkAA_MY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9847F3280059;
        Mon, 15 Jun 2020 09:55:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities" failed to apply to 5.6-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:55:02 +0200
Message-ID: <1592229302136141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0abcc8f65cc23b65bc8d1614cc64b02b1641ed7c Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Sat, 23 May 2020 19:14:54 +0300
Subject: [PATCH] KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities

Even though we might not allow the guest to use WAITPKG's new
instructions, we should tell KVM that the feature is supported by the
host CPU.

Note that vmx_waitpkg_supported checks that WAITPKG _can_ be set in
secondary execution controls as specified by VMX capability MSR, rather
that we actually enable it for a guest.

Cc: stable@vger.kernel.org
Fixes: e69e72faa3a0 ("KVM: x86: Add support for user wait instructions")
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200523161455.3940-2-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 89c766fad889..9b63ac8d97ee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7138,6 +7138,9 @@ static __init void vmx_set_cpu_caps(void)
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+
+	if (vmx_waitpkg_supported())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)

