Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49E037BB45
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhELKtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:49:33 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:45803 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:49:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 28A251317;
        Wed, 12 May 2021 06:48:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xP7+c0
        Hp/+ICW2Fiw2E0zcUs0vlQjTQp9X/9JswxxTY=; b=c5dtcWpoFo+8T52FvPjfQS
        LfRU1c5/VplvpeCnE8Ff2JMOiCa1CAafWn1+syk/nKozKynkRl2wBW3PdMk5CgWQ
        1taJcWq8c+XqY4DNQxYiQX1oWXrowapIzveWjgCzAYsDZUgjlJITbUssK5loYmjc
        HE52tmi/EWe9whEoBOEQ3FNfkHUvknBOUPwbaHGcGPO7jOvH44CFuw4mWwLnCWF7
        c+NpwsCq9n0Q9umQURETyT1TfNQbAHVAC7X6WyOK+Vfs/gEOaBiI46gfYFWNLvJV
        +o1bZ+FWQ6xV0sjtctoYraOgufGcobnB8J+DerkEjPlBXsWjeCM/b3yt8cxHeDVg
        ==
X-ME-Sender: <xms:eLKbYKE9VAuPcMKXboeCTaj1VACXIO3agU4Q69-wEXJn9zkdjX0NHQ>
    <xme:eLKbYLX_njh96OnNPxeo9m95Nztrmg50kkw_C362u6RMkYZs1-IPTGLiGyaOoDtZK
    nQG4wzsRpSseA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:eLKbYELWq52HEz7UE5gIYZX3bvYTieTUfUzBlBMAmpzn862vv9Lg-g>
    <xmx:eLKbYEHyZIpZzga9wCfem6nQDT-JoinMkgO255zCnDy2Ek2wXjqZ6Q>
    <xmx:eLKbYAVQ0Yw_m7FZXEIrpFYteittKxuguh2CEyTqDscFYcHsr9bBfw>
    <xmx:eLKbYJe5ECuLBedQuqaqLkf5G7r89Nktj9gWtBYwef5Nv_QerQditHVbIUY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:48:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: selftests: Always run vCPU thread with blocked SIG_IPI" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, peterx@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:48:14 +0200
Message-ID: <1620816494219217@kroah.com>
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

From bf1e15a82e3b74ee86bb119d6038b41e1ed2b319 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 20 Apr 2021 04:13:03 -0400
Subject: [PATCH] KVM: selftests: Always run vCPU thread with blocked SIG_IPI

The main thread could start to send SIG_IPI at any time, even before signal
blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
blocked.

Without this patch, on very busy cores the dirty_log_test could fail directly
on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).

Reported-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ffa4e2791926..81edbd23d371 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -527,9 +527,8 @@ static void *vcpu_worker(void *data)
 	 */
 	sigmask->len = 8;
 	pthread_sigmask(0, NULL, sigset);
+	sigdelset(sigset, SIG_IPI);
 	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
-	sigaddset(sigset, SIG_IPI);
-	pthread_sigmask(SIG_BLOCK, sigset, NULL);
 
 	sigemptyset(sigset);
 	sigaddset(sigset, SIG_IPI);
@@ -858,6 +857,7 @@ int main(int argc, char *argv[])
 		.interval = TEST_HOST_LOOP_INTERVAL,
 	};
 	int opt, i;
+	sigset_t sigset;
 
 	sem_init(&sem_vcpu_stop, 0, 0);
 	sem_init(&sem_vcpu_cont, 0, 0);
@@ -916,6 +916,11 @@ int main(int argc, char *argv[])
 
 	srandom(time(0));
 
+	/* Ensure that vCPU threads start with SIG_IPI blocked.  */
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIG_IPI);
+	pthread_sigmask(SIG_BLOCK, &sigset, NULL);
+
 	if (host_log_mode_option == LOG_MODE_ALL) {
 		/* Run each log mode */
 		for (i = 0; i < LOG_MODE_NUM; i++) {

