Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7102F37BB44
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhELKtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:49:23 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33545 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:49:23 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 95FB312ED;
        Wed, 12 May 2021 06:48:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xf92X1
        g30/igMRzOghoMffX+0g6KH9ouhVfK8HFrHLA=; b=nKH4VOWfbBrkqTO7fcu9/R
        qCOD3H4eCfljFtavc/dnfTVKul9zxpF9htpZFygPWr+fDj55z0ql46xjIdrvR7aX
        8aBvJ5ceCkuezHEXKMh9dMY6dsetwoWzpJZP2F+ghPAcI9FPMm3eNptcRnjR0CMS
        JxBl+2bO2XGozHWL9/HQOpGmcggBc79mhNLXG7xuYam2WMHb9jQ7NUTfWPGMdFsy
        NlYZ+29ia3muCWTIFd+SNRclK3Qshsqv3J8OW+ntfGwpnNnI9sLLrCK5ZWw/hoeA
        NmXuQS2UeDX1b6nNB+z/9RYV2gN8vfVk/qe/uxKsoIMkWTryYuiPJ3sjyaPB0phA
        ==
X-ME-Sender: <xms:b7KbYBl5IkkgEMBJ43sqTHJ_uRCDSLOY0xR6W3_npia8JlyOT-VgGg>
    <xme:b7KbYM0hfLVLUgbrWu666ddUsLuNyi1IpTNQWGUaPrZChNx0QDOEaZ_mnlPCehIzu
    gPaAeFnLgKkLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:b7KbYHrqlLKmqCSgiE4onUoAJ4HBlKw_s0V1wjk85o_TBEFS94_2Yg>
    <xmx:b7KbYBnebA1R-lusszadphPuPZeMkuRoTJuXUwwuyHEWUM1-E5mzlA>
    <xmx:b7KbYP3KNDBVSRVmVZBZ6JdjpF0qZ2UEV49Yo9SEKntwWX3oQn_dqw>
    <xmx:b7KbYM8cw1QL5J-tAdVFhL2r4QxyGaSB7LP-1YULOMYddcwSQ9MvKIOSVb4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:48:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: selftests: Always run vCPU thread with blocked SIG_IPI" failed to apply to 5.4-stable tree
To:     pbonzini@redhat.com, peterx@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:48:13 +0200
Message-ID: <162081649345162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

