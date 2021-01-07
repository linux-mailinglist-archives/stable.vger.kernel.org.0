Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF342ED5B1
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 18:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbhAGRbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 12:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728891AbhAGRbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 12:31:11 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB19BC0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 09:30:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g15so5396818pgu.9
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 09:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8X7AeS8ogU2ApNgoLbqDEiV+8z00LcQbO21cEd1qiBk=;
        b=vMQi7NwssqJ6QpCdFwOe0QpIEWuL2GsC96JRIh6n7IYFju3CgsRF/p/a9chrHstZ07
         Rf8W3PR/yiaIKsIH08Ju7l6Xnml1JxLfGJHFOFG4W7o214fvstHhTCcTkMxmgciSRDp7
         4g+u6QUpSBHuhZvCpZ+7rFJKkfYGCNgnvJrw4EhdDe0WEDVl+I91vSlmPgJ7YGrZytFC
         9yfl+to1KoPyNWTGmtHftFMz/u7cnXzocAP2nsW+GTsfRn+DuYKxl+eHOG3nKfydQX4Y
         5rENI5gb/oDQkVKAh68Xrn8eFAA5fvjcfQq+TbHHYMGWDrH4ZuGeUjHnwETJhB8u8+en
         kOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8X7AeS8ogU2ApNgoLbqDEiV+8z00LcQbO21cEd1qiBk=;
        b=UvBt+N986UHmdu0nyxY+7RHVV1VPeQJ+IU5cIOSboEswWntIDEvb7vVr9ApNb9r/o0
         +T4hv4uFfN7Bta+jnBjkOnpyfHcmsV3hrOuZ5NOizRoHDCeD+fMZjGuiDrEe/wDMgsq3
         +OtiqsqGceNkldZZtEMyGSU3TD8tdGSS5wQDuKlxi8Blx8cF0Cu25z5847s2CJX49qtn
         zpoJfHyj3KOz1e2VYlwJECZI4KyUD+oh+AMZuViQ2Gv/RqzVZBE9KuovagBVIaGvWL6j
         Ghio8R7Ugjp6A5cnrJFsYFoVrsJQR6th5acOmwAv+OdAi3PAEI2J8Z6GMaEjaGCou5el
         8I7g==
X-Gm-Message-State: AOAM531918kwnaMDq4SV42lkggIPow0lavXFF4MamB/Lllc9tSWjxi7p
        oMGoAwjoCVO8UCDRS5v5yNs=
X-Google-Smtp-Source: ABdhPJye+o3sLN+++kc9ZXGpKdut1k5LtnhhM/2QZnWSxwrA1S8zSLVVwloeThjwbt3nruCuCfgyuw==
X-Received: by 2002:a63:1e1a:: with SMTP id e26mr2904692pge.66.1610040630357;
        Thu, 07 Jan 2021 09:30:30 -0800 (PST)
Received: from [127.0.0.1] ([14.33.99.63])
        by smtp.gmail.com with ESMTPSA id s13sm6894268pfd.99.2021.01.07.09.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 09:30:29 -0800 (PST)
From:   Jinoh Kang <jinoh.kang.kr@gmail.com>
Subject: Re: [BACKPORT] xen/pvh: correctly setup the PV EFI interface for dom0
To:     stable@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        PGNet Dev <pgnet.dev@gmail.com>,
        Roger Pau Monne <roger.pau@citrix.com>
References: <1558349221210204@kroah.com>
 <20190527121138.41800-1-roger.pau@citrix.com>
Message-ID: <aeeaf95b-765d-7bd1-e156-4b26d3dca739@gmail.com>
Date:   Thu, 7 Jan 2021 17:30:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <20190527121138.41800-1-roger.pau@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch had slipped through the cracks, yet it still applies cleanly
to v4.19.165.

It would be much appreciated to have this patch queued.

------------------ original patch ------------------

>From -  Mon Sep 17 00:00:00 2001
Subject: [BACKPORT] xen/pvh: correctly setup the PV EFI interface for dom0
Date: Mon, 27 May 2019 14:11:38 +0200
From: Roger Pau Monne <roger.pau@citrix.com>

commit 72813bfbf0276a97c82af038efb5f02dcdd9e310 upstream

This involves initializing the boot params EFI related fields and the
efi global variable.

Without this fix a PVH dom0 doesn't detect when booted from EFI, and
thus doesn't support accessing any of the EFI related data.

Reported-by: PGNet Dev <pgnet.dev@gmail.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: stable@vger.kernel.org # 4.19+
---
 arch/x86/xen/efi.c           | 12 ++++++------
 arch/x86/xen/enlighten_pv.c  |  2 +-
 arch/x86/xen/enlighten_pvh.c |  4 ++++
 arch/x86/xen/xen-ops.h       |  4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 1804b27f9632..30edb9bc58e2 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -170,7 +170,7 @@ static enum efi_secureboot_mode xen_efi_get_secureboot(void)
 	return efi_secureboot_mode_unknown;
 }
 
-void __init xen_efi_init(void)
+void __init xen_efi_init(struct boot_params *boot_params)
 {
 	efi_system_table_t *efi_systab_xen;
 
@@ -179,12 +179,12 @@ void __init xen_efi_init(void)
 	if (efi_systab_xen == NULL)
 		return;
 
-	strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
-			sizeof(boot_params.efi_info.efi_loader_signature));
-	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
-	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
+	strncpy((char *)&boot_params->efi_info.efi_loader_signature, "Xen",
+			sizeof(boot_params->efi_info.efi_loader_signature));
+	boot_params->efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
+	boot_params->efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
 
-	boot_params.secure_boot = xen_efi_get_secureboot();
+	boot_params->secure_boot = xen_efi_get_secureboot();
 
 	set_bit(EFI_BOOT, &efi.flags);
 	set_bit(EFI_PARAVIRT, &efi.flags);
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 782f98b332f0..0f8da4aebe7b 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1399,7 +1399,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	/* We need this for printk timestamps */
 	xen_setup_runstate_info(0);
 
-	xen_efi_init();
+	xen_efi_init(&boot_params);
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/enlighten_pvh.c b/arch/x86/xen/enlighten_pvh.c
index dab07827d25e..f04d22bcf08d 100644
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -14,6 +14,8 @@
 #include <xen/interface/memory.h>
 #include <xen/interface/hvm/start_info.h>
 
+#include "xen-ops.h"
+
 /*
  * PVH variables.
  *
@@ -79,6 +81,8 @@ static void __init init_pvh_bootparams(void)
 	pvh_bootparams.hdr.type_of_loader = (9 << 4) | 0; /* Xen loader */
 
 	x86_init.acpi.get_root_pointer = pvh_get_root_pointer;
+
+	xen_efi_init(&pvh_bootparams);
 }
 
 /*
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 0e60bd918695..2f111f47ba98 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -122,9 +122,9 @@ static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
 void __init xen_init_apic(void);
 
 #ifdef CONFIG_XEN_EFI
-extern void xen_efi_init(void);
+extern void xen_efi_init(struct boot_params *boot_params);
 #else
-static inline void __init xen_efi_init(void)
+static inline void __init xen_efi_init(struct boot_params *boot_params)
 {
 }
 #endif
-- 
2.20.1 (Apple Git-117)
