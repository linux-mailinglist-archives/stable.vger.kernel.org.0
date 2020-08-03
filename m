Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC923A27C
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 12:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgHCKH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 06:07:26 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56371 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgHCKH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 06:07:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7247532B;
        Mon,  3 Aug 2020 06:07:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 03 Aug 2020 06:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=g0aAxY
        AyrQ2fEPhX5UobD9ghwwzE4tM71MN7KN42RVE=; b=P8M08CrdCvUGIAyXWdrucz
        jn4v0qa5ZZQ+kCE7lj/IKUAa6n2f6AXZvD2eHKurRHmslQDShiqZTn7hwq3i1WKQ
        Hrx2xzpaE5fr0c1npM79Ob9Z+lfbTvAKHhi0SLkufsKoFYVoABzffwSNXK86HxMc
        /S7KRAr1cjV2KjI/HF837vKbLHLo77C/IAHP4p/j4zv41G5z17L1YW1D8ilF2dJo
        TFxIEyYj1imhqm/1lEq0l8DE16h/vHDQ8Gpy9LK+2BkOZWyI3EoAdgAGuiv3RCn1
        3EnGyu+QXOnLlbNnY4x7pUXkR+a6BxN1Vv2l01/uM9Sawmd6YHVaSeFEfDXhGsyQ
        ==
X-ME-Sender: <xms:3OEnXyMsCK3zOoWeXYyfapk5eSUQeK-ObXPm8AeO2v3IzK2XGzZ1vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3OEnXw9ZXFbQEWpcDlCTi_jHluFUiZd9l4BBVicABvxWnIO5gcqQsA>
    <xmx:3OEnX5S9idDr8A1unw3lAxmrEip1qkWd4qppLnCk5k22HIdjzI_MJg>
    <xmx:3OEnXyscTOxEaEbvDNgG6oLjQfletWpug2NnRHlFsWuq4gqYwRU0ug>
    <xmx:3eEnXyl5Mekh0gVgBtEehdy-ncmV17o_EvlR_WA2ZtUPt2LtWLStwsD2bYw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48BDF3280067;
        Mon,  3 Aug 2020 06:07:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Fix disable pause loop exit/pause filtering" failed to apply to 5.4-stable tree
To:     wanpengli@tencent.com, lihaiwei@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Aug 2020 12:07:08 +0200
Message-ID: <159644922811550@kroah.com>
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

From 830f01b089b12bbe93bd55f2d62837253012a30e Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Fri, 31 Jul 2020 11:12:21 +0800
Subject: [PATCH] KVM: SVM: Fix disable pause loop exit/pause filtering
 capability on SVM

'Commit 8566ac8b8e7c ("KVM: SVM: Implement pause loop exit logic in SVM")'
drops disable pause loop exit/pause filtering capability completely, I
guess it is a merge fault by Radim since disable vmexits capabilities and
pause loop exit for SVM patchsets are merged at the same time. This patch
reintroduces the disable pause loop exit/pause filtering capability support.

Reported-by: Haiwei Li <lihaiwei@tencent.com>
Tested-by: Haiwei Li <lihaiwei@tencent.com>
Fixes: 8566ac8b ("KVM: SVM: Implement pause loop exit logic in SVM")
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1596165141-28874-3-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd78ac5..5bbf76189afa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
-	if (pause_filter_count) {
+	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool in_kernel = (svm_get_cpl(vcpu) == 0);
 
-	if (pause_filter_thresh)
+	if (!kvm_pause_in_guest(vcpu->kvm))
 		grow_ple_window(vcpu);
 
 	kvm_vcpu_on_spin(vcpu, in_kernel);
@@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (pause_filter_thresh)
+	if (!kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 }
 
@@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
 
 static int svm_vm_init(struct kvm *kvm)
 {
+	if (!pause_filter_count || !pause_filter_thresh)
+		kvm->arch.pause_in_guest = true;
+
 	if (avic) {
 		int ret = avic_vm_init(kvm);
 		if (ret)

