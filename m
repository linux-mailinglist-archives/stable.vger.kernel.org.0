Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE5E3AE782
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhFUKsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:48:06 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:56193 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhFUKsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:48:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6435A1940A84;
        Mon, 21 Jun 2021 06:45:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 21 Jun 2021 06:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eYurkJ
        wvLHAE45Tw5lB+xzBq4DTVhu8pwLWPYKJDzzs=; b=Eh+ttSDD4MlNEydLQRtRbk
        0TpdMj65tGuQVxSe4WGE271vDCH2YRSdk5AqV/w9DM1jXxazfLuOsgppd/l3nZ8P
        8idj/HPvYdx73/wjy2dbR4Mc0YsLjiU07ljda2zcx+RzSq+LcB5BXtCzUVHUCOZS
        6ts2+xU/ISCWoVMYDlvWdfdSVzV/gy7QkVh5TuAdoWj1H3JxKpIiJyVLMm5tZaFa
        o9KQm5Uz6ccLJ7GLXCqRKZGnzlQbjgZx/+V3szHggS0ZVJ54NuLJlN8xkEtMqyE7
        dc9FS3rMk7k/kq07ms8xaPqZLj6beAb9aw1gM907mb/1cG5KCzxlXtOjzfiuAtSg
        ==
X-ME-Sender: <xms:323QYA7boQiBImr3W4EYdHtsmUbPdhj3k7jO8APSxisahB1-SeKoGg>
    <xme:323QYB71lnQ4NrZVFGbsm5KTpf9iYhDiGsDoy2DxpfQmPhYQYpwap4jCzexhYDOOd
    sivqvcKsU8roQ>
X-ME-Received: <xmr:323QYPephzcn2FK1jpkXNviLP5UN2t22tt6ybkpKbVs3MiVWE-as4ZZokTsq6fAzRYAexlZJkQsuC9xLT5tiWm64gyJP0PHT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:323QYFK0Dq57BPBQr5GuramI2fMh3wWWalt9GiHkKjd6EJ5_oJa3Qw>
    <xmx:323QYEI3IOao_pYhql8GDzt0k4YNDXOhrmdr9ZriyfrCUgxg_G3S_A>
    <xmx:323QYGxvG5vMMgh574Zfq7gstFbXOs7SYdwjPGeTXW1H8BFaEI3zsg>
    <xmx:323QYI3WAR1Jl8nX4bk-ImP8m0SsmFPuZYSUufJ-70_P4TzZowvL3w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:45:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Call SEV Guest Decommission if ASID binding fails" failed to apply to 5.10-stable tree
To:     alpergun@google.com, marcorr@google.com, pbonzini@redhat.com,
        pgonda@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:45:37 +0200
Message-ID: <162427233720782@kroah.com>
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

