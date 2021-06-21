Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176C33AE781
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUKsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:48:04 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:37307 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhFUKsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:48:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 933EF1940A32;
        Mon, 21 Jun 2021 06:45:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 06:45:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Jmu6GG
        Iwv+c0z48LLr0J1HJf/7/5O6RpTGIksJRf8yk=; b=tkK+dQ9Q+iyvUyRekqrRiA
        U7ECxejRm2yF1KyleVW4t1y5FLM/9GBAEbMEG6+ysPQNP2p6q5uDmNMjdwoRiil6
        rWj9DhomPc2/pjznczhOnkJ4RtkJ90J2dKeSCkwP4ydpYCrAd5LsHz7sgylnBnrT
        PYMLaPPHrqgb78vQpAMAk4qLGRaJs/8KbSukIh+fqzFKyDdMJzHhaTCnpnPl8xrD
        uMVClxB4S7phQ+F85RcSuKyi/q5vXajaAWgfux0U547T0SOY0jYeWNrRHkOPjq55
        rZaH4CpFEBe0meIxQeR1M2JMgsjOle5o+WPizUA7/gzQh0NuzwN++5OPNKd4fLqw
        ==
X-ME-Sender: <xms:3G3QYHKYpr95SjvG1vSk9nw-JqjkO7j7_np27yAwhhkZRq5XZocrJw>
    <xme:3G3QYLJw8_OvaHUADd2Z8mvk3DoMXIdudfe72fMX_JaXRwRBCNiV0Nzn3ltedpGFC
    b8hBPDcfiaSSQ>
X-ME-Received: <xmr:3G3QYPs_X81MU_vd0G60vORq6yWOfDYTshXOX2U1dC8Fu6tmoTMnaneCKUcpj83-sr1h5L9mZb_xl0L3uYUp0YeAVjrs2aA_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3G3QYAYsUe_5FMJO5xgokRohUbl8zJ_pbF53Gz_ahoe3-iZeNP91cA>
    <xmx:3G3QYObm6NguQahbljg61dGPVqrtjV7AOhkDh_sqNTjv9rabTltEjA>
    <xmx:3G3QYECQi2umH37G_NdeW9f-H4swkTPD6GGuLPgUAP1CoaGFRsxGpQ>
    <xmx:3G3QYOG9fQpMqaZ-6j90MYWR75I6HZm8HxS6gjGgZioVLhtF9bOkZw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:45:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Call SEV Guest Decommission if ASID binding fails" failed to apply to 5.12-stable tree
To:     alpergun@google.com, marcorr@google.com, pbonzini@redhat.com,
        pgonda@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:45:37 +0200
Message-ID: <1624272337212178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 934002cd660b035b926438244b4294e647507e13 Mon Sep 17 00:00:00 2001
From: Alper Gun <alpergun@google.com>
Date: Thu, 10 Jun 2021 17:46:04 +0000
Subject: [PATCH] KVM: SVM: Call SEV Guest Decommission if ASID binding fails

Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
fails. If a failure happens after  a successful LAUNCH_START command,
a decommission command should be executed. Otherwise, guest context
will be unfreed inside the AMD SP. After the firmware will not have
memory to allocate more SEV guest context, LAUNCH_START command will
begin to fail with SEV_RET_RESOURCE_LIMIT error.

The existing code calls decommission inside sev_unbind_asid, but it is
not called if a failure happens before guest activation succeeds. If
sev_bind_asid fails, decommission is never called. PSP firmware has a
limit for the number of guests. If sev_asid_binding fails many times,
PSP firmware will not have resources to create another guest context.

Cc: stable@vger.kernel.org
Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
Reported-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Alper Gun <alpergun@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210610174604.2554090-1-alpergun@google.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e0ce5da97fc2..8d36f0c73071 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -199,9 +199,19 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	sev->misc_cg = NULL;
 }
 
-static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+static void sev_decommission(unsigned int handle)
 {
 	struct sev_data_decommission decommission;
+
+	if (!handle)
+		return;
+
+	decommission.handle = handle;
+	sev_guest_decommission(&decommission, NULL);
+}
+
+static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+{
 	struct sev_data_deactivate deactivate;
 
 	if (!handle)
@@ -214,9 +224,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_guest_deactivate(&deactivate, NULL);
 	up_read(&sev_deactivate_lock);
 
-	/* decommission handle */
-	decommission.handle = handle;
-	sev_guest_decommission(&decommission, NULL);
+	sev_decommission(handle);
 }
 
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -341,8 +349,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	/* return handle to userspace */
 	params.handle = start.handle;

