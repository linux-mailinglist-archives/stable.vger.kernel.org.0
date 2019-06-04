Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6A34244
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfFDIz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:55:28 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41845 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfFDIz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:55:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F3A3A3A12;
        Tue,  4 Jun 2019 04:55:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:55:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KaKxxa
        vL9kP5qZWKunOxylgwRtxqQKdBGfac7Kxf4JU=; b=HG3R/Ixn+R4ChK5TXlwCr5
        +pqrUmyLh/Ofc+64EvjZdS4q+pvLlySP8QtzItlxNXtwxHMHrulXLVHCVhLdOK2l
        ELMF84k/HMJ0fb1r8kUeXL+oQdJFmdJpnMu7r6mygUeQt9iXivTWn4CK2jCXpEmd
        VXTxvzpFEVGSOnNgPr1BJeLwClM7xP8AKv0LkKFgyuUegut+gQCKTIFvEh0FvpU8
        7eeebim7dpwtiDv39BQVTy4Mtw4EJEDX8R+25J9+kHU+UXx7hVJvNxmPtYyhqtQN
        tMXQX088ful4TP1QcaDsro+prFqDaGvKctUOKRnYcI+xa8H5ag3bvyGVMh7o0G7Q
        ==
X-ME-Sender: <xms:_jH2XBAul8M2Z6uWCm2au1HRgXegRKmQZ92ceGMVxbpW4Z7QevN6XQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:_jH2XDzypRLSwveYBrd5nKE_vJAInzBi7ntWGRJ1fB1wDhTs8fKgLg>
    <xmx:_jH2XHn4RCF1PzXtg9BAm4jLxzk5tBFudIkoiATeQo_v4upnFNLOMw>
    <xmx:_jH2XAGLJS4IFXjtVKs0w4tGLyE8qVBdrdVKcJtuIm9uYrhY3qC48w>
    <xmx:_jH2XESF7WMhFkkQKz9yc8VYN82rYhhjNREXCAUd-wjUGjAbAlfcIQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E74F5380083;
        Tue,  4 Jun 2019 04:55:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: s390: Do not report unusabled IDs via" failed to apply to 4.19-stable tree
To:     thuth@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, drjones@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:55:16 +0200
Message-ID: <15596385168014@kroah.com>
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

From a86cb413f4bf273a9d341a3ab2c2ca44e12eb317 Mon Sep 17 00:00:00 2001
From: Thomas Huth <thuth@redhat.com>
Date: Thu, 23 May 2019 18:43:08 +0200
Subject: [PATCH] KVM: s390: Do not report unusabled IDs via
 KVM_CAP_MAX_VCPU_ID

KVM_CAP_MAX_VCPU_ID is currently always reporting KVM_MAX_VCPU_ID on all
architectures. However, on s390x, the amount of usable CPUs is determined
during runtime - it is depending on the features of the machine the code
is running on. Since we are using the vcpu_id as an index into the SCA
structures that are defined by the hardware (see e.g. the sca_add_vcpu()
function), it is not only the amount of CPUs that is limited by the hard-
ware, but also the range of IDs that we can use.
Thus KVM_CAP_MAX_VCPU_ID must be determined during runtime on s390x, too.
So the handling of KVM_CAP_MAX_VCPU_ID has to be moved from the common
code into the architecture specific code, and on s390x we have to return
the same value here as for KVM_CAP_MAX_VCPUS.
This problem has been discovered with the kvm_create_max_vcpus selftest.
With this change applied, the selftest now passes on s390x, too.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190523164309.13345-9-thuth@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 6d0517ac18e5..0369f26ab96d 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1122,6 +1122,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 	case KVM_CAP_MIPS_FPU:
 		/* We don't handle systems with inconsistent cpu_has_fpu */
 		r = !!raw_cpu_has_fpu;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3393b166817a..aa3a678711be 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -657,6 +657,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 #ifdef CONFIG_PPC_BOOK3S_64
 	case KVM_CAP_PPC_GET_SMMU_INFO:
 		r = 1;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e5e8eb29e68e..28ebd647784c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -539,6 +539,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_NR_VCPUS:
 	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_S390_BSCA_CPU_SLOTS;
 		if (!kvm_s390_use_sca_entries())
 			r = KVM_MAX_VCPUS;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index acb179f78fdc..83aefd759846 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3122,6 +3122,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 	case KVM_CAP_PV_MMU:	/* obsolete */
 		r = 0;
 		break;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 90cedebaeb94..7eeebe5e9da2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -224,6 +224,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 	case KVM_CAP_MSI_DEVID:
 		if (!kvm)
 			r = -EINVAL;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 301089a462c4..ca54b09adf5b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3151,8 +3151,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_MULTI_ADDRESS_SPACE:
 		return KVM_ADDRESS_SPACE_NUM;
 #endif
-	case KVM_CAP_MAX_VCPU_ID:
-		return KVM_MAX_VCPU_ID;
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
 	default:

