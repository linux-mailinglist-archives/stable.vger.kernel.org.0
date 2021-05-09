Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595BE3777D2
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEIRcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhEIRcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 13:32:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAFBC061573;
        Sun,  9 May 2021 10:31:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j12so5584892pgh.7;
        Sun, 09 May 2021 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNMN409vhgmIJzMSgLO/z7XdlSTjFBeziZjCWQllPk4=;
        b=P+OMkYQ7A+sLfxZZmzEuMGJxRlvGVCuZbkjdTScwF8J7B5pwMK0Mk1B+IfeRFgfySG
         wbZWbu6PvqIe01dViRENocFkhT6KjxQ9vPMKzLVztgUHAbQc8YEJ/cdHpjBDrQ1t74kt
         oBAeKGTimWUuHSAedCR8++7/PIpttMvxpxBZ32RqYGsjN0vgj4fmXsIi0/QSm61tzYTK
         J8erTgUpFncH71EUOSa1xgtr3TPPzbAaAnE0+KH2VtWKv9s/a9yRGjs4kGAoptax26Jt
         NoOcfDg9EzM6UipOdZ7tcla74LkUrfuYIUWnQkAwJUA3dAnlF+X7ZM02e2lxUPwStk5m
         0Daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNMN409vhgmIJzMSgLO/z7XdlSTjFBeziZjCWQllPk4=;
        b=YOe8KpS+b8Z7h90EfYHRk5hkuI/l/135f/AtBO1kT/quIyU4rGBdT1sxt8X7PKo22H
         R60SU33j1zAXTk1WbHrV5KTJBby+tzZnPSXSOVZpqG1lB3jrj0iPH7DYCSApnO4Yalvg
         BdR5TRbi120UNX16B1KB8DAtuylr0NTUnCy305UqB+A/aaDdZVZmjNhCtBhnJiASbpNo
         jOv9EIXn1tGXKbndrmaSKTmR2hTajdbaglPWUp0bZfiyQ9DnImpqYqcL9S/ozAoRUBJP
         lXeeGIkp6DKCvDBedqCI5/es2BV5bDeJeg9pIY2DFElcp9Graiy4gMqQy6tV18KChjHb
         O/5A==
X-Gm-Message-State: AOAM533XiHJWYhHfrIfdzTNgnjrhta6j0edb599d+f8Cfn37z5LaPYPO
        BauoFWCUH3BiHIBrpmsYWsViiSiKhAQ=
X-Google-Smtp-Source: ABdhPJy24QQy2Q++3mjtv0Ha+BD4/fNVUFleMBiLcP1fKnKXsC7A1rDCVIZRJF6XJDHO0A6HihMWDg==
X-Received: by 2002:a63:3d87:: with SMTP id k129mr21102328pga.57.1620581460390;
        Sun, 09 May 2021 10:31:00 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d129sm2637918pfa.6.2021.05.09.10.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 10:30:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Joel Stanley <joel@jms.id.au>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.10 3/3] ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address
Date:   Sun,  9 May 2021 10:30:29 -0700
Message-Id: <20210509173029.1653182-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210509173029.1653182-1-f.fainelli@gmail.com>
References: <20210509173029.1653182-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit fc2933c133744305236793025b00c2f7d258b687 upstream

Commit

  149a3ffe62b9dbc3 ("9012/1: move device tree mapping out of linear region")

created a permanent, read-only section mapping of the device tree blob
provided by the firmware, and added a set of macros to get the base and
size of the virtually mapped FDT based on the physical address. However,
while the mapping code uses the SECTION_SIZE macro correctly, the macros
use PMD_SIZE instead, which means something entirely different on ARM when
using short descriptors, and is therefore not the right quantity to use
here. So replace PMD_SIZE with SECTION_SIZE. While at it, change the names
of the macro and its parameter to clarify that it returns the virtual
address of the start of the FDT, based on the physical address in memory.

Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/memory.h | 6 +++---
 arch/arm/kernel/setup.c       | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index bb79e52aeb90..f717d7122d9d 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -68,8 +68,8 @@
 #define XIP_VIRT_ADDR(physaddr)  (MODULES_VADDR + ((physaddr) & 0x000fffff))
 
 #define FDT_FIXED_BASE		UL(0xff800000)
-#define FDT_FIXED_SIZE		(2 * PMD_SIZE)
-#define FDT_VIRT_ADDR(physaddr)	((void *)(FDT_FIXED_BASE | (physaddr) % PMD_SIZE))
+#define FDT_FIXED_SIZE		(2 * SECTION_SIZE)
+#define FDT_VIRT_BASE(physbase)	((void *)(FDT_FIXED_BASE | (physbase) % SECTION_SIZE))
 
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
@@ -111,7 +111,7 @@ extern unsigned long vectors_base;
 #define MODULES_VADDR		PAGE_OFFSET
 
 #define XIP_VIRT_ADDR(physaddr)  (physaddr)
-#define FDT_VIRT_ADDR(physaddr)  ((void *)(physaddr))
+#define FDT_VIRT_BASE(physbase)  ((void *)(physbase))
 
 #endif /* !CONFIG_MMU */
 
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 694aa6b4bd03..f90479d8b50c 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1086,7 +1086,7 @@ void __init setup_arch(char **cmdline_p)
 	void *atags_vaddr = NULL;
 
 	if (__atags_pointer)
-		atags_vaddr = FDT_VIRT_ADDR(__atags_pointer);
+		atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
 
 	setup_processor();
 	if (atags_vaddr) {
-- 
2.25.1

