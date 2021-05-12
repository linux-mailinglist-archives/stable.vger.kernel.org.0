Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF19237BAC9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhELKh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:37:57 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51857 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:37:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 0A61A7ED;
        Wed, 12 May 2021 06:36:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=REfKLb
        1HLoQqBnpijd1ujIyjOWt/jniFrB8KkwgWSKI=; b=IghPWwAz+Ap2C/67AbZOdM
        1tq6OtbwIjiW5nDVDkDGWfZovB3/wqS1GJD/K/JGNiT/8WEqvQOTu5pRK7P64oJg
        DZ4dNLsDvAPzrE461lU8yodEnYe813xah9g9OTVhoUwF9nx2iYUsK1vKpkQQ6mB1
        yPtD7DcKXPjIzZLUKOD6BnJi6HfAbO8J0QSPq1CykylpZ4QpAzL6SIbVzqh4omBZ
        lOAEIPIBUv9RrLaSGO+nnWlFpKkPjksDNQ37jF9U6FiWq+A+y9WuRhXsu9zB+eyt
        yD1m+SvR2wNznF424iE7meK94CyVlRZL6LOW8S/VbeKbm1O5SkLTiiiaWerxGUrg
        ==
X-ME-Sender: <xms:wK-bYBVWph9iTnJu2zl9o-BfDlMwpzCzcIXrizS68wwM6Yp5caPpcQ>
    <xme:wK-bYBmhe8THcG1_z-uRkKVhLsBsN7sM7sGNDJs4g_53m1MLd5gyqPkm5V9o2mVOr
    isYP_bA13a6Jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wK-bYNZlzONYk-mDzOI2XcN95Le8y3N3mWkIUu3-GH0j12oUfP2y4w>
    <xmx:wK-bYEUMsVvZxiVmQ7ni7iDvHV-_GIexg3SnOWxBEHubvlPcStCJZQ>
    <xmx:wK-bYLn7R31C0zh9oKLp9CbMx4z8Zwk3JOaC1hJRMmIfHRFXTZS5RQ>
    <xmx:wK-bYDt7wYRXN8eLbJhjIHG-lIuwweo5aPA0y_ADkhZ1Lug8kJ7s4Kvzi5Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:36:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Move RDPID emulation intercept to its own enum" failed to apply to 4.19-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:36:31 +0200
Message-ID: <1620815791124205@kroah.com>
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

From 2183de4161b90bd3851ccd3910c87b2c9adfc6ed Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:23 -0700
Subject: [PATCH] KVM: x86: Move RDPID emulation intercept to its own enum

Add a dedicated intercept enum for RDPID instead of piggybacking RDTSCP.
Unlike VMX's ENABLE_RDTSCP, RDPID is not bound to SVM's RDTSCP intercept.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-5-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 77e1c89a95a7..8a0ccdb56076 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4502,7 +4502,7 @@ static const struct opcode group8[] = {
  * from the register case of group9.
  */
 static const struct gprefix pfx_0f_c7_7 = {
-	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdtscp),
+	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdpid),
 };
 
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 0d359115429a..f016838faedd 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -468,6 +468,7 @@ enum x86_intercept {
 	x86_intercept_clgi,
 	x86_intercept_skinit,
 	x86_intercept_rdtscp,
+	x86_intercept_rdpid,
 	x86_intercept_icebp,
 	x86_intercept_wbinvd,
 	x86_intercept_monitor,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46573b862638..4a625c748275 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7437,8 +7437,9 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
+	 * Note, RDPID is hidden behind ENABLE_RDTSCP.
 	 */
-	case x86_intercept_rdtscp:
+	case x86_intercept_rdpid:
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
 			exception->vector = UD_VECTOR;
 			exception->error_code_valid = false;

