Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5213777BF
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 19:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhEIRQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 13:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhEIRQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 13:16:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60D2C06175F;
        Sun,  9 May 2021 10:14:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id k19so12015834pfu.5;
        Sun, 09 May 2021 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GdEsPts6/FPz2ykV0GJlUYI1XtzHN0Ot6bY7JwXZfAw=;
        b=r5pfr6Y/hYoLMuYvvRNNHKA64Ok3+jbrkRkIszOPN61ZMQratGRruFgiyxq+ooCaI1
         qjJD3bMHqmLnCNPAT8Q4VzngjBl7cBes7NxpCzNAYiECpk8VZkW7tiQNwciyHysSs2vP
         27lzLYJDmsCTe6h61tGPO1fGq7xaBGJe8Ieho7MgAAp+R6uhIHhv2hQMvdoDcqbpec7+
         CI2hD/3GkAKxgBIjSlkpKL9C/Es3OLaR73/pDvqcp7DEb0s+mBJje2VOilQJcnRySRU9
         1Yw89sSccgd/xSa8Ac3IzCS2wXYSWneX33H5O6W7nNeg7+Q4UYRP5bV85e/zB+5IEd5K
         jqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GdEsPts6/FPz2ykV0GJlUYI1XtzHN0Ot6bY7JwXZfAw=;
        b=Pq/85R91iFE+9dslZToAMoznqC9T7aJuuQZjfbSBpq6KdaIy9bz4LwReLA02VACpLh
         qCzh7icm1KQs4eUwu6/iWQBmT1HOiuVbumPIiPiR8Q3TzJyBk/UTV9FWnGRPT80v4FgJ
         fpyl6QaryXBTEP/1oEIqs5Oc98Pn6O0QXeVvOsVKUjJ22JYVVLFAS4BL8a1PRpg5Z0hi
         dwt188UkvO0/pNIYyMvDlE+kF6mxRusZtMIz5G7Lmrr7HP1rvjt72PelT5zLxuiNryG7
         REtSeOKojyAz/KM0v36aKAIqopdT+rxAKYRqpF85KUorN5xmyLimojQDXMb5dSt/qV2Z
         8H2Q==
X-Gm-Message-State: AOAM530XecfXjzhZkWCztdCxcxdD3lflCI/yybNav/2MHX13uwzlKGG+
        7r6xmlVk4H8GmGjLH63tDSGQ80BRZlg=
X-Google-Smtp-Source: ABdhPJyfTyhcaqaBiwtRrVzVgLHofeVtiicyzC7gqEaLV2wOpnXUqyRn4cBID+JEwF4g1xHRSnV6fQ==
X-Received: by 2002:aa7:9885:0:b029:28e:9f7f:f23 with SMTP id r5-20020aa798850000b029028e9f7f0f23mr21585188pfl.75.1620580495157;
        Sun, 09 May 2021 10:14:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w12sm2121834pff.42.2021.05.09.10.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 10:14:54 -0700 (PDT)
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
Subject: [PATCH stable 5.4 3/3] ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address
Date:   Sun,  9 May 2021 10:14:28 -0700
Message-Id: <20210509171428.1537572-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210509171428.1537572-1-f.fainelli@gmail.com>
References: <20210509171428.1537572-1-f.fainelli@gmail.com>
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

