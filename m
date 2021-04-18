Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD06D3634A0
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhDRKfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:35:18 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:49183 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhDRKfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:35:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 012151940719;
        Sun, 18 Apr 2021 06:34:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 06:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LV7Edi
        XMpfKg1RI8uRqAaGmaF6/KW3oU1dTbDpW1yz8=; b=PbI8IO3SOzAdAs4eILOV3b
        7xrYlciW2NflF60ZKGZc7b3W1S1rzNWfcOH/W1WXue9qQ54TpAl5Qquzo6XmTnN8
        3Tex3n/Qls00S084hZAPi9iHl+stKXb7q4uAx44OehvlOSHnKHDJLgZ2TAhfkgGS
        H2uoGXD6djcJE1lIENhRU1ChYGEq8TfZf76nGRFOpsWyaPW7ImT8qgw/3Jan6uLU
        7+8N98YRcWQlwb4yybIM9zWdPB343dQT9SemqpuW4EuoySxL1lZFKTgXqClMJWkq
        grnSxFbIPqkxaRzIqjlNMYqNofpA73HKSI2o7Tvg2VajYkWhyq1L33+wzWjZhdZw
        ==
X-ME-Sender: <xms:Rgt8YFuicrkgn-A-hMGC7RUiiFLNN5JzfSuwCzPSW6rK37w06-CPfQ>
    <xme:Rgt8YOf-htGoh-UVaAkJDr4s7t87hUVVaYyGLbbip3kVSMphYzF4YzgtviIkTHFxc
    L5wSugeE5Sxiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Rgt8YIxq0sVZz35QhrPZRUp_nu6Ep6TUmjKQXkv-Lti7kdyWrsHQWA>
    <xmx:Rgt8YMORRCyXpHcp1cUxCDgpKBClfbIolF2z1jFoHYF8PfG8Br7RdQ>
    <xmx:Rgt8YF8GLyo9ORUM2qInirz-cseq35W_ArW6jXHe-F0N15bEqy9REg>
    <xmx:Rgt8YHny5JSij-4uYeRMBGskCpLpNxfRmPu4aNitUjLTS3-CxTX4mw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1A2F240057;
        Sun, 18 Apr 2021 06:34:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array" failed to apply to 5.10-stable tree
To:     reijiw@google.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 12:34:37 +0200
Message-ID: <161874207766162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 04c4f2ee3f68c9a4bf1653d15f1a9a435ae33f7a Mon Sep 17 00:00:00 2001
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 13 Apr 2021 15:47:40 +0000
Subject: [PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array
 index

__vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
an array access.  Since vcpu->run is (can be) mapped to a user address
space with a writer permission, the 'ndata' could be updated by the
user process at anytime (the user process can set it to outside the
bounds of the array).
So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.

Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20210413154739.490299-1-reijiw@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf8287d4a7..29b40e092d13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6027,19 +6027,19 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
 	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+		int ndata = 3;
+
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
-		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
 		vcpu->run->internal.data[1] = exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
 		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
-			vcpu->run->internal.ndata++;
-			vcpu->run->internal.data[3] =
+			vcpu->run->internal.data[ndata++] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
-		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
-			vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.ndata = ndata;
 		return 0;
 	}
 

