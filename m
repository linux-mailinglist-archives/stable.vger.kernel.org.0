Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E101CF4B0
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgELMra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 08:47:30 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:51957 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729880AbgELMr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 08:47:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BB596194081F;
        Tue, 12 May 2020 08:47:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 May 2020 08:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jOyeOD
        jmBR9t+gsd4mr93+CBP0cUX/meDB3fBcCs+K8=; b=oOkYvA34XSseCNkBabMIax
        vsk7Kwgsn1T2DIUApjEZDFrU08UMI9+LxInKJ4KnoV32Dg4B2dwbL85pkD81DEnv
        sDF7LjKIbsQug5HPgzGgu1ko5GShCUXI2tHi5DuTiLB5gANxLAQzaSoLdoWPm5JO
        Hyvhml79RNaeQug5hUob3iMQ5aeYRZF8CKkuEbT6HlDS6Y8b8NgIOCdOQt1BJWXv
        uA6G1RjN2tRgFchQxNU7hF/JjCWAksevO1bzk6gkh1J6g1UNcL7XVNqsZWQg9hvT
        Oqay1RUvwppL2F8GDkJpoM1AN7NO3gOQviX7qRbBaGwzEeCK/rlQhVtY4ZazD7eg
        ==
X-ME-Sender: <xms:3Jq6XqIHpwkIPzER81NnJXyIZCUKgP8EipaMMl95RPosAqrjgNz6_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3Jq6XiLoR_rYWPjtAChIEU9vQT0-U8zzDqjmfAAhT0kRAMoJNTLVQA>
    <xmx:3Jq6Xqu65J0BE5IUTUncgLB-fueTL06IG9rm_XOvLHFmm4MVzYteEw>
    <xmx:3Jq6XvaIoF6Olttv1FLNBX8DZrMGQiwYCXW2kWvTuhgPVCtE0GicUg>
    <xmx:3Jq6Xj09IAfemnBlTR3yhNCfoN5IYYQ9rW6RbQB8_o1EW8oP7Td8YQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38F6730662C7;
        Tue, 12 May 2020 08:47:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kvm: x86: Use KVM CPU capabilities to determine CR4 reserved" failed to apply to 5.6-stable tree
To:     pbonzini@redhat.com, jmattson@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 May 2020 14:47:20 +0200
Message-ID: <158928764039116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 139f7425fdf54f054463e7524b9f54c41af8407f Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 5 May 2020 09:40:46 -0400
Subject: [PATCH] kvm: x86: Use KVM CPU capabilities to determine CR4 reserved
 bits

Using CPUID data can be useful for the processor compatibility
check, but that's it.  Using it to compute guest-reserved bits
can have both false positives (such as LA57 and UMIP which we
are already handling) and false negatives: in particular, with
this patch we don't allow anymore a KVM guest to set CR4.PKE
when CR4.PKE is clear on the host.

Fixes: b9dd21e104bc ("KVM: x86: simplify handling of PKRU")
Reported-by: Jim Mattson <jmattson@google.com>
Tested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..8d296e3d0d56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -926,19 +926,6 @@ EXPORT_SYMBOL_GPL(kvm_set_xcr);
 	__reserved_bits;				\
 })
 
-static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
-{
-	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
-
-	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
-		reserved_bits &= ~X86_CR4_LA57;
-
-	if (kvm_cpu_cap_has(X86_FEATURE_UMIP))
-		reserved_bits &= ~X86_CR4_UMIP;
-
-	return reserved_bits;
-}
-
 static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
@@ -9675,7 +9662,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
-	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
+#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
+	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
+#undef __kvm_cpu_cap_has
 
 	if (kvm_has_tsc_control) {
 		/*
@@ -9707,7 +9696,8 @@ int kvm_arch_check_processor_compat(void *opaque)
 
 	WARN_ON(!irqs_disabled());
 
-	if (kvm_host_cr4_reserved_bits(c) != cr4_reserved_bits)
+	if (__cr4_reserved_bits(cpu_has, c) !=
+	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
 	return ops->check_processor_compatibility();

