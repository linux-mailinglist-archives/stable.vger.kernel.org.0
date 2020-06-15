Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B251F995E
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgFONz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:55:26 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34071 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729973AbgFONzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:55:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B13506C5;
        Mon, 15 Jun 2020 09:55:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4ftho4
        +VKiQx2J0vcGwhoWhCzdWdPNDsxp8zuma7BqM=; b=FXZkq2/wfDMKknTzYUT9u/
        AORZDlSEi9HyJlCAKiV8Odsa7Hhi8LBZdMjJhTE9xerNqdqeBPBQZ0RSndX6c0GO
        AzArZD7mJHIFuzN8XAh2d4sOhE4xAmK7TxylnlDXbqGf0B9GFmlCks03YU+iy+Sc
        ibN/wqY3G9oBVK9zQsxB4bnK4lpG1yWs7uaWUICOYGQxcMwPmbFx1KxxClsPUykX
        10OH9TgtkU0Xu0DZWVBjPEqj869e1/4n6Yj7CtvkbLx/olxG2YtbKeUE3uQJqPT2
        3OF3B6Mr+sauhwKNzUygHYK4C6R0K6WRknLVBYTeWIC/F+1ijykShQka2lYI4zsQ
        ==
X-ME-Sender: <xms:y33nXmmTHBCsCj2_zE3Ci75HbtldUWMaQfCL8aTzuUf8DQxj8Epe2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:y33nXt01XcOUeuaSCz0vM-ACVuBBl3h0EYxXHeYuPqfQgxbdCxV3BA>
    <xmx:y33nXkrVMDI3D37Fru54bfvWeNR6Z8uc-apBOTNJ4OZsaFiKbhfrzA>
    <xmx:y33nXqm4hk-nEA_zgC7_e_-PUfyDxneB7ipDlKRrDy82dDGyn8vHVg>
    <xmx:y33nXp-Rw76rzmFGVzgHAMAB0InW1CYO0dHS8-_lZ308X-OsEFo56XQQxlU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EFE433280065;
        Mon, 15 Jun 2020 09:55:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities" failed to apply to 5.4-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:55:03 +0200
Message-ID: <15922293031966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

