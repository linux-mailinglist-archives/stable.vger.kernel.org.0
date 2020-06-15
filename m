Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E861F98C6
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgFONdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:33:41 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34343 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730602AbgFONdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:33:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8BDBC621;
        Mon, 15 Jun 2020 09:33:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=98vHTh
        yhRtHgad0Y8xOK9VrGzDMStRcpiNzeuTEORn0=; b=SHCPbPcxO/giKztqsym61M
        RsdJYTKX2HmhKDKxAf7hSAkbHzq2U9Bd2GkMFIi3rLbAuzgmkGyLi1SP3IREFZtO
        rmZJ1auTsy2u1AhjqE2HQp7k4ZW5PkLvh42+xVAcDC8DW+7xY4UMY/8szR0WcEnt
        rcgH/UDMtXFCLVYPEDvUEhyX5sdP6bYJ6nB4WGTd1uZgYHzPh3XWEVnQozcGLfhg
        N9drwSrWv+t5/BYTwYZjsXdnq76UnAi7FXX8wlZLspyZG5L8B5Vz3DUi79horZy/
        tOR18r7mkoCzxEJBIC8k8ZsV9EJWnHbykRHOElryShm+n419teH8gQm1GgZ7RQtw
        ==
X-ME-Sender: <xms:snjnXlNHeukwC8pJeOlk8AmpqbdJGDKInEHKgtYuNzIl_W_-gXo4og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheetudeuieekueejkeefkeevjeegueegvdduueelle
    fhveeigfdukedvteeigeehnecuffhomhgrihhnpegrmhgurdgtohhmnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:snjnXn8Mn0f-aO4yfcGGdW7iiyWiqzxjDMidS9-Vra5HL3qpOjOPrQ>
    <xmx:snjnXkTEZgKybCgMYilzscfl-2DFygE0ocsGdLbO6Mw3F9qNZnBi7A>
    <xmx:snjnXhsVqoUefKM9H_vgTG8YgcUt0-FAa_tUBIxFdSHru2az-TfJOg>
    <xmx:snjnXjqwYiMeK0FlXzzVJ8vObdwOYHcQTTwCqXM6Su2wtOhn6gkOrWnOGTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABD3C328005D;
        Mon, 15 Jun 2020 09:33:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/speculation: Avoid force-disabling IBPB based on STIBP" failed to apply to 4.19-stable tree
To:     asteinhauser@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:33:25 +0200
Message-ID: <159222800515682@kroah.com>
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

From 21998a351512eba4ed5969006f0c55882d995ada Mon Sep 17 00:00:00 2001
From: Anthony Steinhauser <asteinhauser@google.com>
Date: Tue, 19 May 2020 06:40:42 -0700
Subject: [PATCH] x86/speculation: Avoid force-disabling IBPB based on STIBP
 and enhanced IBRS.

When STIBP is unavailable or enhanced IBRS is available, Linux
force-disables the IBPB mitigation of Spectre-BTB even when simultaneous
multithreading is disabled. While attempts to enable IBPB using
prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, ...) fail with
EPERM, the seccomp syscall (or its prctl(PR_SET_SECCOMP, ...) equivalent)
which are used e.g. by Chromium or OpenSSH succeed with no errors but the
application remains silently vulnerable to cross-process Spectre v2 attacks
(classical BTB poisoning). At the same time the SYSFS reporting
(/sys/devices/system/cpu/vulnerabilities/spectre_v2) displays that IBPB is
conditionally enabled when in fact it is unconditionally disabled.

STIBP is useful only when SMT is enabled. When SMT is disabled and STIBP is
unavailable, it makes no sense to force-disable also IBPB, because IBPB
protects against cross-process Spectre-BTB attacks regardless of the SMT
state. At the same time since missing STIBP was only observed on AMD CPUs,
AMD does not recommend using STIBP, but recommends using IBPB, so disabling
IBPB because of missing STIBP goes directly against AMD's advice:
https://developer.amd.com/wp-content/resources/Architecture_Guidelines_Update_Indirect_Branch_Control.pdf

Similarly, enhanced IBRS is designed to protect cross-core BTB poisoning
and BTB-poisoning attacks from user space against kernel (and
BTB-poisoning attacks from guest against hypervisor), it is not designed
to prevent cross-process (or cross-VM) BTB poisoning between processes (or
VMs) running on the same core. Therefore, even with enhanced IBRS it is
necessary to flush the BTB during context-switches, so there is no reason
to force disable IBPB when enhanced IBRS is available.

Enable the prctl control of IBPB even when STIBP is unavailable or enhanced
IBRS is available.

Fixes: 7cc765a67d8e ("x86/speculation: Enable prctl mode for spectre_v2_user")
Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ed54b3b21c39..8d57562b1d2c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -495,7 +495,9 @@ early_param("nospectre_v1", nospectre_v1_cmdline);
 static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
 	SPECTRE_V2_NONE;
 
-static enum spectre_v2_user_mitigation spectre_v2_user __ro_after_init =
+static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
+	SPECTRE_V2_USER_NONE;
+static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 
 #ifdef CONFIG_RETPOLINE
@@ -641,15 +643,6 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 		break;
 	}
 
-	/*
-	 * At this point, an STIBP mode other than "off" has been set.
-	 * If STIBP support is not being forced, check if STIBP always-on
-	 * is preferred.
-	 */
-	if (mode != SPECTRE_V2_USER_STRICT &&
-	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
-		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
-
 	/* Initialize Indirect Branch Prediction Barrier */
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
@@ -672,23 +665,36 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
 			static_key_enabled(&switch_mm_always_ibpb) ?
 			"always-on" : "conditional");
+
+		spectre_v2_user_ibpb = mode;
 	}
 
-	/* If enhanced IBRS is enabled no STIBP required */
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	/*
+	 * If enhanced IBRS is enabled or SMT impossible, STIBP is not
+	 * required.
+	 */
+	if (!smt_possible || spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
 	/*
-	 * If SMT is not possible or STIBP is not available clear the STIBP
-	 * mode.
+	 * At this point, an STIBP mode other than "off" has been set.
+	 * If STIBP support is not being forced, check if STIBP always-on
+	 * is preferred.
+	 */
+	if (mode != SPECTRE_V2_USER_STRICT &&
+	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
+		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
+
+	/*
+	 * If STIBP is not available, clear the STIBP mode.
 	 */
-	if (!smt_possible || !boot_cpu_has(X86_FEATURE_STIBP))
+	if (!boot_cpu_has(X86_FEATURE_STIBP))
 		mode = SPECTRE_V2_USER_NONE;
+
+	spectre_v2_user_stibp = mode;
+
 set_mode:
-	spectre_v2_user = mode;
-	/* Only print the STIBP mode when SMT possible */
-	if (smt_possible)
-		pr_info("%s\n", spectre_v2_user_strings[mode]);
+	pr_info("%s\n", spectre_v2_user_strings[mode]);
 }
 
 static const char * const spectre_v2_strings[] = {
@@ -921,7 +927,7 @@ void cpu_bugs_smt_update(void)
 {
 	mutex_lock(&spec_ctrl_mutex);
 
-	switch (spectre_v2_user) {
+	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		break;
 	case SPECTRE_V2_USER_STRICT:
@@ -1164,14 +1170,16 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 {
 	switch (ctrl) {
 	case PR_SPEC_ENABLE:
-		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return 0;
 		/*
 		 * Indirect branch speculation is always disabled in strict
 		 * mode.
 		 */
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
@@ -1182,10 +1190,12 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		 * Indirect branch speculation is always allowed when
 		 * mitigation is force disabled.
 		 */
-		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return -EPERM;
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return 0;
 		task_set_spec_ib_disable(task);
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
@@ -1216,7 +1226,8 @@ void arch_seccomp_spec_mitigate(struct task_struct *task)
 {
 	if (ssb_mode == SPEC_STORE_BYPASS_SECCOMP)
 		ssb_prctl_set(task, PR_SPEC_FORCE_DISABLE);
-	if (spectre_v2_user == SPECTRE_V2_USER_SECCOMP)
+	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP)
 		ib_prctl_set(task, PR_SPEC_FORCE_DISABLE);
 }
 #endif
@@ -1247,22 +1258,24 @@ static int ib_prctl_get(struct task_struct *task)
 	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
 		return PR_SPEC_NOT_AFFECTED;
 
-	switch (spectre_v2_user) {
-	case SPECTRE_V2_USER_NONE:
+	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 		return PR_SPEC_ENABLE;
-	case SPECTRE_V2_USER_PRCTL:
-	case SPECTRE_V2_USER_SECCOMP:
+	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		return PR_SPEC_DISABLE;
+	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_PRCTL ||
+	    spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_PRCTL ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP) {
 		if (task_spec_ib_force_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
 		if (task_spec_ib_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
 		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
-	case SPECTRE_V2_USER_STRICT:
-	case SPECTRE_V2_USER_STRICT_PREFERRED:
-		return PR_SPEC_DISABLE;
-	default:
+	} else
 		return PR_SPEC_NOT_AFFECTED;
-	}
 }
 
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
@@ -1501,7 +1514,7 @@ static char *stibp_state(void)
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return "";
 
-	switch (spectre_v2_user) {
+	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		return ", STIBP: disabled";
 	case SPECTRE_V2_USER_STRICT:

