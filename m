Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311CF45E39F
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 01:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351199AbhKZAS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 19:18:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237052AbhKZAQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 19:16:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637885624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aHYTSvEaf35gtxIU/OdUXMVV96quCC++ChEzR9yL5d0=;
        b=LIsWZcuICIOMnx7Gn+phezwncdtnidzYlSKw8mVF+RB1qwhAv99Ih0gqFENRKf8wpnxh5o
        kNO9TPA2JYXa86eK1bkcl1mMdHCPw6uGjUZiyGIJ+xJXUZjb7oWuO+BP8HaztCHvs+V2Og
        XQlAkJvzR3jXuovFIPk7+8WuVVMnrRE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-K7_ssj8aPZaom3JZKcQnEw-1; Thu, 25 Nov 2021 19:13:43 -0500
X-MC-Unique: K7_ssj8aPZaom3JZKcQnEw-1
Received: by mail-wr1-f72.google.com with SMTP id d3-20020adfa343000000b0018ed6dd4629so1411366wrb.2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 16:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aHYTSvEaf35gtxIU/OdUXMVV96quCC++ChEzR9yL5d0=;
        b=d9fQ7S4b4zowMRQZ2snpCUpszLI5INOcL7WWO5vK46uBKbuliCEaGgOg93QHLhsqKv
         wqvqVf1oyyp8TMIxrsp3sEZ3EXIN+lqP9TJWkBlqzElovrvFiAm3CjpJR9Od+1SHWDc3
         xrNLksdTifOUqk0CZU6yRFejK9JZNlKF1XMXFN+uvfQuh0CHIg1Gfcws+B4yaxCCYMGt
         UIIjODOYJDvyFE9E2jCxpJ6HtAswy26TNwMx9MO5lYwQIvMInyzlIrny1jqm5WZorEUr
         GV7TE8zBlkhAzSCA/lFL9Hke6CSPuUGwrytfiY7Fm6+3Zl3qN6mP72TMOAGy7hE5utbX
         GYaw==
X-Gm-Message-State: AOAM533EpqBg8iub7ndvtjg+v+O5vo0w7Cdbd2qeyKKgoFU0KxKRtzyV
        ziMAVCxtmxSEXUjNBTVjAqan15qPYNF6rf5gVdY2hf75kBv2jbNFYv9gUZSFlF2Hf4Q008SfOUS
        dsT51uPWRXiStyrkQ
X-Received: by 2002:adf:dc12:: with SMTP id t18mr11013267wri.566.1637885622045;
        Thu, 25 Nov 2021 16:13:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoZG+YdMkwdiPxwlrZTBFxCXXKIKLYVcyqaOTO6tv8VqV0xmHfGjnG9iHtSwOjpJh8BXAkyg==
X-Received: by 2002:adf:dc12:: with SMTP id t18mr11013235wri.566.1637885621813;
        Thu, 25 Nov 2021 16:13:41 -0800 (PST)
Received: from minerva.home ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id a12sm4005540wrm.62.2021.11.25.16.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 16:13:41 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, x86@kernel.org
Subject: [PATCH] efi: Move efifb_setup_from_dmi() prototype from arch headers
Date:   Fri, 26 Nov 2021 01:13:32 +0100
Message-Id: <20211126001333.555514-1-javierm@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup
for all arches") made the Generic System Framebuffers (sysfb) driver able
to be built on non-x86 architectures.

But left the efifb_setup_from_dmi() function prototype declaration in the
architecture specific headers. This could lead to the following compiler
warning as reported by the kernel test robot:

   drivers/firmware/efi/sysfb_efi.c:70:6: warning: no previous prototype for function 'efifb_setup_from_dmi' [-Wmissing-prototypes]
   void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
        ^
   drivers/firmware/efi/sysfb_efi.c:70:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void efifb_setup_from_dmi(struct screen_info *si, const char *opt)

Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

 arch/arm/include/asm/efi.h   | 1 -
 arch/arm64/include/asm/efi.h | 1 -
 arch/riscv/include/asm/efi.h | 1 -
 arch/x86/include/asm/efi.h   | 2 --
 include/linux/efi.h          | 6 ++++++
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index a6f3b179e8a9..27218eabbf9a 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -17,7 +17,6 @@
 
 #ifdef CONFIG_EFI
 void efi_init(void);
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index d3e1825337be..ad55079abe47 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,7 +14,6 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 #else
 #define efi_init()
 #endif
diff --git a/arch/riscv/include/asm/efi.h b/arch/riscv/include/asm/efi.h
index 49b398fe99f1..cc4f6787f937 100644
--- a/arch/riscv/include/asm/efi.h
+++ b/arch/riscv/include/asm/efi.h
@@ -13,7 +13,6 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 #else
 #define efi_init()
 #endif
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 4d0b126835b8..63158fd55856 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -197,8 +197,6 @@ static inline bool efi_runtime_supported(void)
 
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
-
 extern void efi_thunk_runtime_setup(void);
 efi_status_t efi_set_virtual_address_map(unsigned long memory_map_size,
 					 unsigned long descriptor_size,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index dbd39b20e034..ef8dbc0a1522 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1283,4 +1283,10 @@ static inline struct efi_mokvar_table_entry *efi_mokvar_entry_find(
 }
 #endif
 
+#ifdef CONFIG_SYSFB
+extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
+#else
+static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt) { }
+#endif
+
 #endif /* _LINUX_EFI_H */
-- 
2.33.1

