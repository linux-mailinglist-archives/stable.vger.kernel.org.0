Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3480E312FC1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhBHKzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:55:00 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:32953 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhBHKvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:51:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B5038970;
        Mon,  8 Feb 2021 05:49:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6mtJ36
        YEhcOzLO5ZbJZ+gRcB2jFLpJqbZEvrfE17zS4=; b=sAMS28Va3SR5ghWoY2S39U
        PgjG9n2iE6AuOWYEC9ysS6gge37PDIik2hvz0wwdODK8s91yQ9xVaZYgMZETdkbO
        4qqix1gzV1z+kSufSOrkIQxtjz1xpFzdtEqDB6hlnFr9h9aOXUvz9qV5HkKtBwn7
        Ck+D7dN5LW0XDGC5yi5vBtC2qg8o9QMFg146fVv0Eb9u7Hxh7me9LSnVcEqdK9my
        k/vbx8mjgO6swyBiQKReBfv6ziN5N8SZfLAzdanepGmor+wggE3KAgQFV3+s1Z0R
        UbL5pzrA/ly2PoTerOMGwFNLm07Gm5VOeF42gw7vc3ApJYEaxo6yo/ACjZDb9Qnw
        ==
X-ME-Sender: <xms:UhchYD8lha_sfoDtzQCYoFjFXcHSNd19JZkiiXTWwB_md9KX-ICTPQ>
    <xme:UhchYPuRMZvwI8NmsYWXrRuhpCdlkItzjoBYkvZ_UZaXUXYY5G4lNPnKNZZDNTjPd
    ZiB5mgv-DpvfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:UhchYBACB9JRFPGmdLf7a4ljuacEpzkoMSM2Y5qq_8Eg7BrnQzGxmA>
    <xmx:UhchYPesecTLe-CB8dtziwqoq-G1oiGaTwkoVEpx6eFdZdLL2FFfhQ>
    <xmx:UhchYINTLNtMWaDWrTrP6RdjI91IqNf0gBy8V7Oygcj5aOTSUBGHgg>
    <xmx:UhchYDbpGTnW--J02WAK68evS5ZDSgy85YOeKzio7H6pbNW5fi7-n9FaKP0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B8511080063;
        Mon,  8 Feb 2021 05:49:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if" failed to apply to 5.4-stable tree
To:     pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:49:45 +0100
Message-ID: <1612781385193221@kroah.com>
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

From 7131636e7ea5b50ca910f8953f6365ef2d1f741c Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Jan 2021 11:45:00 -0500
Subject: [PATCH] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if
 tsx=off

Userspace that does not know about KVM_GET_MSR_FEATURE_INDEX_LIST
will generally use the default value for MSR_IA32_ARCH_CAPABILITIES.
When this happens and the host has tsx=on, it is possible to end up with
virtual machines that have HLE and RTM disabled, but TSX_CTRL available.

If the fleet is then switched to tsx=off, kvm_get_arch_capabilities()
will clear the ARCH_CAP_TSX_CTRL_MSR bit and it will not be possible to
use the tsx=off hosts as migration destinations, even though the guests
do not have TSX enabled.

To allow this migration, allow guests to write to their TSX_CTRL MSR,
while keeping the host MSR unchanged for the entire life of the guests.
This ensures that TSX remains disabled and also saves MSR reads and
writes, and it's okay to do because with tsx=off we know that guests will
not have the HLE and RTM features in their CPUID.  (If userspace sets
bogus CPUID data, we do not expect HLE and RTM to work in guests anyway).

Cc: stable@vger.kernel.org
Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc60b1fc3ee7..eb69fef57485 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6860,11 +6860,20 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		switch (index) {
 		case MSR_IA32_TSX_CTRL:
 			/*
-			 * No need to pass TSX_CTRL_CPUID_CLEAR through, so
-			 * let's avoid changing CPUID bits under the host
-			 * kernel's feet.
+			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
+			 * interception.  Keep the host value unchanged to avoid
+			 * changing CPUID bits under the host kernel's feet.
+			 *
+			 * hle=0, rtm=0, tsx_ctrl=1 can be found with some
+			 * combinations of new kernel and old userspace.  If
+			 * those guests run on a tsx=off host, do allow guests
+			 * to use TSX_CTRL, but do not change the value on the
+			 * host so that TSX remains always disabled.
 			 */
-			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			if (boot_cpu_has(X86_FEATURE_RTM))
+				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			else
+				vmx->guest_uret_msrs[j].mask = 0;
 			break;
 		default:
 			vmx->guest_uret_msrs[j].mask = -1ull;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76bce832cade..b05a1fe9dae9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1394,16 +1394,24 @@ static u64 kvm_get_arch_capabilities(void)
 	if (!boot_cpu_has_bug(X86_BUG_MDS))
 		data |= ARCH_CAP_MDS_NO;
 
-	/*
-	 * On TAA affected systems:
-	 *      - nothing to do if TSX is disabled on the host.
-	 *      - we emulate TSX_CTRL if present on the host.
-	 *	  This lets the guest use VERW to clear CPU buffers.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_RTM))
-		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
-	else if (!boot_cpu_has_bug(X86_BUG_TAA))
+	if (!boot_cpu_has(X86_FEATURE_RTM)) {
+		/*
+		 * If RTM=0 because the kernel has disabled TSX, the host might
+		 * have TAA_NO or TSX_CTRL.  Clear TAA_NO (the guest sees RTM=0
+		 * and therefore knows that there cannot be TAA) but keep
+		 * TSX_CTRL: some buggy userspaces leave it set on tsx=on hosts,
+		 * and we want to allow migrating those guests to tsx=off hosts.
+		 */
+		data &= ~ARCH_CAP_TAA_NO;
+	} else if (!boot_cpu_has_bug(X86_BUG_TAA)) {
 		data |= ARCH_CAP_TAA_NO;
+	} else {
+		/*
+		 * Nothing to do here; we emulate TSX_CTRL if present on the
+		 * host so the guest can choose between disabling TSX or
+		 * using VERW to clear CPU buffers.
+		 */
+	}
 
 	return data;
 }

