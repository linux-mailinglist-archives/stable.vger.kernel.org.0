Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8390726442A
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 12:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgIJKd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 06:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgIJKd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 06:33:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5993AC061573;
        Thu, 10 Sep 2020 03:33:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so3998213pgl.10;
        Thu, 10 Sep 2020 03:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=n5bejNfhnwg4ZD6VA0P2oapc248CaAsST/crmsvS6LA=;
        b=DAe9S+dXyHd8nHH/FsQQ5tioon9wlXS94y2osIBQy+LDGwwKYfSjtVxMVxLL8nYYtS
         Mh2+f1Clro6SEFmlTr9hwL/RsfzVOV2eMjMHJ9cp+//Ye8jJFfLyjZyPXPwLct8Pcben
         PIzcNbrZ6IEQ7SUJAp7gzh/5aVrK+VuQYsi2uK3AW+IdnlB4z/qL5rUF5fdjQvG+XvSo
         pogTA4s7sz8bgnclF/zdc3g0L05phrKhxZ4LyLQt1bQkEMKPCf+Aaqi2GGSStqm/PQjs
         obmtlyA0t2Km1DMYOBQKl4V2KNFDPE6RegBR8kPnucHqp8LxOO/5OiW3bQgcDLxr6O4p
         zddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=n5bejNfhnwg4ZD6VA0P2oapc248CaAsST/crmsvS6LA=;
        b=sO8N9w8+JarPzG3eCQuTblDtdktlYfZ/n153pQ8t2uUhOYFo5o3dl87BJy6jwL6AZf
         Aqs5w1ivoyPi1mkgjJUmoIO0aQ8zftCezI0gdJeRK9qbAGeS3TWWr9TubynP4g52pgwP
         LhmRTZOQxb5B9qNF5eH1/dQa9Oocd9pbRZUIMig8eQm3gwekcL3dIA8N78qj4UTrOspV
         xTifdECYAhKSlySWzo1haXvqpq1tkSJMTtRgugBkEG8ZCMuqc7ukiOtdPwJN7M0f3D5D
         MJFMUWmiWLuCVTCtZzgZpIi+1yYYy3yTq+fbQYgz4H1tz9B7VNfePNX77UaQ9lxKUncD
         86Dw==
X-Gm-Message-State: AOAM531p7ZIRiysUeD4c7avmmPq9S0H2oklf7lZ6+f7rNBqF1yVJg6C1
        0UslW83dzKWEZ3B6VCwGY3Q=
X-Google-Smtp-Source: ABdhPJxoQxBqPWLHTAFbLDAOl8r51m9uR9FkMGkNvHuBRPaf4/3IoDSpWshdI9Ddwk+YXWi+XZSqBw==
X-Received: by 2002:a62:7a53:: with SMTP id v80mr4680246pfc.129.1599734036685;
        Thu, 10 Sep 2020 03:33:56 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id f12sm1972065pjm.5.2020.09.10.03.33.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 03:33:56 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: MIPS: Change the definition of kvm type
Date:   Thu, 10 Sep 2020 18:33:51 +0800
Message-Id: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MIPS defines two kvm types:

 #define KVM_VM_MIPS_TE          0
 #define KVM_VM_MIPS_VZ          1

In Documentation/virt/kvm/api.rst it is said that "You probably want to
use 0 as machine type", which implies that type 0 be the "automatic" or
"default" type. And, in user-space libvirt use the null-machine (with
type 0) to detect the kvm capability, which returns "KVM not supported"
on a VZ platform.

I try to fix it in QEMU but it is ugly:
https://lists.nongnu.org/archive/html/qemu-devel/2020-08/msg05629.html

And Thomas Huth suggests me to change the definition of kvm type:
https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03281.html

So I define like this:

 #define KVM_VM_MIPS_AUTO        0
 #define KVM_VM_MIPS_VZ          1
 #define KVM_VM_MIPS_TE          2

Since VZ and TE cannot co-exists, using type 0 on a TE platform will
still return success (so old user-space tools have no problems on new
kernels); the advantage is that using type 0 on a VZ platform will not
return failure. So, the only problem is "new user-space tools use type
2 on old kernels", but if we treat this as a kernel bug, we can backport
this patch to old stable kernels.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/kvm/mips.c     | 2 ++
 include/uapi/linux/kvm.h | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index d7ba3f9..9efeb67 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -138,6 +138,8 @@ extern void kvm_init_loongson_ipi(struct kvm *kvm);
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	switch (type) {
+	case KVM_VM_MIPS_AUTO:
+		break;
 #ifdef CONFIG_KVM_MIPS_VZ
 	case KVM_VM_MIPS_VZ:
 #else
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 29ba8e8..cfc1ae2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -790,9 +790,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
-- 
2.7.0

