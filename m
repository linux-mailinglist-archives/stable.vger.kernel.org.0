Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D13A378FFD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhEJN6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbhEJNxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:53:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DFC0612ED;
        Mon, 10 May 2021 06:33:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gx21-20020a17090b1255b02901589d39576eso3782976pjb.0;
        Mon, 10 May 2021 06:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SWc6HvBPJvv2dkce5ud+kbAsCLR0AEFXu+aa6as3WtI=;
        b=RYQEnGEMhpGjvohnk2yQjpWAbJ8bTMQdWfcTL7H678yAe8WA8MT6WwVlhApozlBfu7
         rV63Wi1f73OnVRBIfQu1fdgj3/O8xRMUUz6l4tWPCK5Pcx3GaoNc+hhdUm/guRnbd/EP
         2gZD/RBVSF02kDXw5SwSu7GDl8bucgAr0ljCjgYBxHOhV9gstO/ZpUpDGRlLOzSvo3Dl
         WXjTHW6WuUFfOiCdcFZxGI6uszimldO8rc5ZTZtNV4ZxMJBaYVEaYfoi6ncrubJonDo2
         4KP+uiz+h6VdPTun5x06QAWEx3LjlXwkZD2NQowW3AuLE3dU6Y0qDvN2qsRhFA75shEg
         mXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SWc6HvBPJvv2dkce5ud+kbAsCLR0AEFXu+aa6as3WtI=;
        b=E62H+Gpvt6XdD1yd9UBoOcx0KVH60lhwPL7iBJGFZ0A5nj8ajAETxWYhqFVF3g34PR
         7cOCdQv4jTfxZDx1+UdfWYDJRZnOua+Xs6mTyfrF12SmfZmCqrsxU9xWqfgqOTPTD6nB
         ovsv7/oudzSEsKb35oUFqZ2h9+cOED4ov5xmlyNDeN3NkRltAlEirGy8DeG7HOJGJTkl
         8kWrEX/MCrNhrpN1exeRpkLLPkEGhqj2t63tHvUgDs9RlCSHZTVo5gYlOCdAa8zhWjLZ
         euBycbdeLLpzivqXL+iKRarZRsZv53XJBjx7h1yJaorHkaZkXxMV02wuaqO/GyVACOkD
         /xNg==
X-Gm-Message-State: AOAM532vyj4duXKRRT675IO4uRx1eIN/Ry+yKDOdv7SH5ErGadCT8gCL
        tUSVTbi5NPtAfSFWU0ZNPKS/x/gv2zU=
X-Google-Smtp-Source: ABdhPJz5zGBsiedFPuOElsetInFE8TbXFegdd8SF+sdd6CJEMJsKqSMEetYIXPAzp7MJI1rVupRvpA==
X-Received: by 2002:a17:90a:3948:: with SMTP id n8mr28760783pjf.32.1620653612080;
        Mon, 10 May 2021 06:33:32 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w127sm7906564pfw.4.2021.05.10.06.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:33:31 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable 5.4 v2 4/4] ARM: 9027/1: head.S: explicitly map DT even if it lives in the first physical section
Date:   Mon, 10 May 2021 06:33:21 -0700
Message-Id: <20210510133321.1790243-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510133321.1790243-1-f.fainelli@gmail.com>
References: <20210510133321.1790243-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 upstream

The early ATAGS/DT mapping code uses SECTION_SHIFT to mask low order
bits of R2, and decides that no ATAGS/DTB were provided if the resulting
value is 0x0.

This means that on systems where DRAM starts at 0x0 (such as Raspberry
Pi), no explicit mapping of the DT will be created if R2 points into the
first 1 MB section of memory. This was not a problem before, because the
decompressed kernel is loaded at the base of DRAM and mapped using
sections as well, and so as long as the DT is referenced via a virtual
address that uses the same translation (the linear map, in this case),
things work fine.

However, commit 7a1be318f579 ("9012/1: move device tree mapping out of
linear region") changes this, and now the DT is referenced via a virtual
address that is disjoint from the linear mapping of DRAM, and so we need
the early code to create the DT mapping unconditionally.

So let's create the early DT mapping for any value of R2 != 0x0.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/kernel/head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 4f49e8c71ef1..5ceed4d9ee03 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -274,10 +274,10 @@ __create_page_tables:
 	 * We map 2 sections in case the ATAGs/DTB crosses a section boundary.
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
-	movs	r0, r0, lsl #SECTION_SHIFT
+	cmp	r2, #0
 	ldrne	r3, =FDT_FIXED_BASE >> (SECTION_SHIFT - PMD_ORDER)
 	addne	r3, r3, r4
-	orrne	r6, r7, r0
+	orrne	r6, r7, r0, lsl #SECTION_SHIFT
 	strne	r6, [r3], #1 << PMD_ORDER
 	addne	r6, r6, #1 << SECTION_SHIFT
 	strne	r6, [r3]
-- 
2.25.1

