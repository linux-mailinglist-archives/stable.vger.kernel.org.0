Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CF723A27D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 12:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgHCKHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 06:07:36 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:58751 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgHCKHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 06:07:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BC1E5849;
        Mon,  3 Aug 2020 06:07:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 03 Aug 2020 06:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xCynW9
        cR29m2XoqPbwWMq5709zd2fjjog4vu8ZqZe+g=; b=iXU72vvucUJIfrBHQv0NO3
        ZyllaFMXZ6ZuI2vzwCfrsvqW6ZMKMzfqVOsdvGxqWFXqQJbFFwGO4kjlJ2g6OEq+
        YvhEbYYsSUpFFyBM8RlRfcVIW2pzLeiVbyuL+uYH4CxqA3bOeXhhryv1R+plA4kf
        FoRpJ+DTYaJ9g4D+iFpkp8tSY/sPQai04/0MipPQjQem8WrEijeKrkAgaGXZoRgg
        jShNATxA0qo8u501MzRcIZij0X2NYqh5hfGHJvI18EZSR5FQItzx0Ijqew6EFuVO
        vW+MqCCkZxao/RB5hVmyMo58d+JBLavep2/yqendH21gsgFiEv2JSdc14DWl00GQ
        ==
X-ME-Sender: <xms:5uEnX0BFbvgLUdDyA_6fhzWGWRcrjToV0T04TiPHEbcMnsdqTlSI9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:5uEnX2gYIXi2Iuf8EyJLIQtBRTBQaShGffi8kqwlk6ebYXySNYvfpg>
    <xmx:5uEnX3ksRYmSPLWfwInpAwujZeqXw50Ca7peE2H6LF-Z7Gh4kbeqrQ>
    <xmx:5uEnX6wR2Mq8ZHYLERPIVV7FN9nKbfH4YK85soakul_BO7WmIt7oGA>
    <xmx:5uEnX67_U2UcuXAKFc_4KhqyFIrjNL4Jl8RT1wz25EhClFJHYT7OuErAvyY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E35C130600A3;
        Mon,  3 Aug 2020 06:07:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Fix disable pause loop exit/pause filtering" failed to apply to 4.19-stable tree
To:     wanpengli@tencent.com, lihaiwei@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Aug 2020 12:07:08 +0200
Message-ID: <1596449228218155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

