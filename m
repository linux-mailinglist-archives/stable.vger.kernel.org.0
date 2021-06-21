Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E633AE77F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFUKrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:47:53 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:45909 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhFUKrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:47:53 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id CC4BB1940A88;
        Mon, 21 Jun 2021 06:45:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Jun 2021 06:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dMOVNk
        c98oPEATZJ2j2h3VSp/DeSKecV5twbAjV88lg=; b=r/9Mdlfx4riAz8NdJ4ulwz
        o5vWi0drORYL6ew4fvZctvVfPaUaeFZnG8Jwuj+/zB0xliIQf8FD/9NBLTaBLwTz
        ViGRx3davMHY6dNvRDkp8ZR8oGWWRkGr+Sk4ppi249WCDfKvAdu/HD0TZVQCuYPo
        VnB2tQj2wg6e8kvtdY7beY8blX3BuoSDA5kiSUWQeOtrXaHajU19weWV6r7SGRbg
        VC7P+XKsVpty7InuEbbTAlOUc/qhvUoeoHjxq5Sp8EffKOohuyeHY4eIm3yCxB+b
        QmV2DXJXs2x3mgeLQ16JEUgZFi4EaTqQNDmMWC8Xam+sHWeg8t5tRHhoKvlJSD+A
        ==
X-ME-Sender: <xms:0m3QYDQ960B-K7_HhSaoVUVwsPcOkn6wrSEa_GBWqd9qodTwMx3jAQ>
    <xme:0m3QYEzjC8llwuNkWIW6Pp0MMCX8QbGuirUKvis6_hOFkYqoAvE9kv9hjJyrpjK0L
    3QE0B852eSzNA>
X-ME-Received: <xmr:0m3QYI1ntrGZeQcfri8BPVc2WG2VQ_AligT9yuZR4fBZ1mYtpmcenTvldEGQZiubJLUs8sXz74toCm72PC9fIlHINt82hTSv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0m3QYDAxkoxGmpwzdGdtus7_zDI7ZewK80gf3aNZ62EOrispXxnhzw>
    <xmx:0m3QYMjV82bAL0IIC5kFvmKuVUYOfqZP0bu4DlxO2e37dVk17pCILQ>
    <xmx:0m3QYHpSKu2aoj3p5KNLtFAjZceTx-1NvPBYBlwh1P2xtbt3KirlJw>
    <xmx:0m3QYFvN-HLCALawxGVuIDQesF5kSJ7p0Wk8FjI3gaGtrMHH10PHbw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:45:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Call SEV Guest Decommission if ASID binding fails" failed to apply to 4.19-stable tree
To:     alpergun@google.com, marcorr@google.com, pbonzini@redhat.com,
        pgonda@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:45:35 +0200
Message-ID: <162427233514222@kroah.com>
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

