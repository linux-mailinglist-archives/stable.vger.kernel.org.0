Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF76378FF9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 16:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhEJN6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbhEJNxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:53:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907F5C0612EC;
        Mon, 10 May 2021 06:33:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p17so9116027plf.12;
        Mon, 10 May 2021 06:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GdEsPts6/FPz2ykV0GJlUYI1XtzHN0Ot6bY7JwXZfAw=;
        b=tApArNJG0m5HL6BFaZZIzhAn8a2UZfxTOv6G1Df6+CkTvtS5+0kOUjgawquqT25FTt
         2MASkt/xMkEGBpaITalcKLLfEwKrX0zKV9ijVu4QntbnBJdLb+4kRZmBeucEbBRzvRAc
         fKIA9tyT91piw+Fmhgy5pyZLj1ujYqclgpmXDvd9URQVrw0nzTrEuTdgUwKpRTBOQvGs
         7YdxwLrXGl7b+BhOnmyhXKxI8s3LLuSskmYk4V+nh1iiDrbWB3C3Y8Uq1kgkwO5rXL39
         8xqsPCy91LtscmFjtLZ2j1dSSEUfPypSWk8th+fEFXH3E1lsV2XYtn6MgHy8gnFZvgHc
         e9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GdEsPts6/FPz2ykV0GJlUYI1XtzHN0Ot6bY7JwXZfAw=;
        b=SCIOKDHlAMERBW1uzmQ8IsR44Wspo23dUH4TrGx///QLVukOw3MnWXx7N2uheCKHha
         9MvWaADxYyM2tug18t6mT4y380wxRUgmxIvf/ZgQaQcGH4HsufJQIbcK4djWp6zAsnQm
         mEP9hY3Yua6/GUzuK7Ej8TDjIyy3ic46YyY6RpFuJWumxrGQzlQV+VW4KxIhxf0x4r09
         5GAqeC4HxsfcsviWoHgao+QFWUZhiDEdIr3801QKzjZ6YNX3OmufphEuXCwnqMN1HdDY
         TDhhU3pOycsYZ2l/yG9aysUc4QE2w6KZ1cL3NAcMlnQOzBGjom3/tS7Rsc5M58nqGG0b
         wKJw==
X-Gm-Message-State: AOAM530iM52zfN6HN2nP1n652Idh0NjpWeegMBlSoP1fvUFQytYArbPQ
        26hDMJclEU59QO+RRrwhZlMVuttcWSw=
X-Google-Smtp-Source: ABdhPJzj7luZDanpLohMyeueroTg00hxLK0yiyn5bOR0gc17xYsleZPp3ARDo5RQYowDCfDNQkn6+A==
X-Received: by 2002:a17:90a:4615:: with SMTP id w21mr28299082pjg.50.1620653610549;
        Mon, 10 May 2021 06:33:30 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w127sm7906564pfw.4.2021.05.10.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:33:30 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Joel Stanley <joel@jms.id.au>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable 5.4 v2 3/4] ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address
Date:   Mon, 10 May 2021 06:33:20 -0700
Message-Id: <20210510133321.1790243-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510133321.1790243-1-f.fainelli@gmail.com>
References: <20210510133321.1790243-1-f.fainelli@gmail.com>
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
index d9bc70f25728..924285d0bccd 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1080,7 +1080,7 @@ void __init setup_arch(char **cmdline_p)
 	void *atags_vaddr = NULL;
 
 	if (__atags_pointer)
-		atags_vaddr = FDT_VIRT_ADDR(__atags_pointer);
+		atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
 
 	setup_processor();
 	if (atags_vaddr) {
-- 
2.25.1

