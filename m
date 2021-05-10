Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03C1378E88
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbhEJN3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240762AbhEJNXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:23:04 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7135C06175F;
        Mon, 10 May 2021 06:21:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c17so13596044pfn.6;
        Mon, 10 May 2021 06:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tl7s734YASKJ3u2oeYhTRanwUBfl3NVcj5cenpAt2BA=;
        b=RDNUTjjWuPi6DrAVXk8S4EwXsMHELJPuIrLV/GV2tDwYTZFG3kponlg/mD8htKAyyF
         l7ey9CPgxtsQmt+SKIeXQqZf0RDK5L4bIpU2aTmB3pdJwQg10YYuzIWbMuTVz+t3I26m
         /bB9ZUiSM7i3rLGqwTeBrqbblqUAX6JuNb10VUTLGtGZo/h0w8WyNGFozhZcq1I9zP6k
         1WxYPMP7mFlac3OmtpUnzJGjOVZEqugQeWazlVMnRMYTe7daWLp/P1BGkEGxNu9SxSys
         Y6kPDxBLRslvFbe7zk9KG7lS1VLuGswJnYcxz7uYKn1E7YGJ22wBJ5lF3bDzdNroD+wu
         Z3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tl7s734YASKJ3u2oeYhTRanwUBfl3NVcj5cenpAt2BA=;
        b=CyxdxYaQvM4COkvPBT+V9syVHQgmiWWcG2PFkfxYDHfA6QCkvMIKG+bABEkTBryR0f
         M8H4TLCo1AAN4fWlmwElBlvCzCsN/PNIHmSCzJEDAJYQU4zWZMACItvv/+h6RSdF9Em0
         fiOFZkhIjwMO9vEoUHrrA9mOrg/NYJm412ZXYNgYy9bq4jxgEZZufgEU8yxp74xKaogz
         5I4fobHxwu08rubFU9lGjjTNF0S4iNKbgDn8Ow2fXNAHGNePxaT1TtDQ9u+9VceaC84O
         9q8DrPnI9VOp4fYgcZlotN0jSSWjQhx3EsfA2nk6t4/cRp8ZMJNn20KSV8AmiOCLvsjw
         xb2w==
X-Gm-Message-State: AOAM531omSJfwKlRAjDw4F9u66FbDSD7P62397Acz/90a8KJVjJrUKA5
        PM8YWSYNtrwBKKwTdUI8Fm9HkgPqI7U=
X-Google-Smtp-Source: ABdhPJwgpvW8eWnj+FLU83e1o6few5DdpVIj8azOzsaa1GO2bWm6iQV+eSPlzZo49yqqgnor60zVUg==
X-Received: by 2002:a63:490:: with SMTP id 138mr24777071pge.99.1620652918900;
        Mon, 10 May 2021 06:21:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n8sm11129351pgm.7.2021.05.10.06.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:21:58 -0700 (PDT)
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
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.10 v2 4/4] ARM: 9027/1: head.S: explicitly map DT even if it lives in the first physical section
Date:   Mon, 10 May 2021 06:21:11 -0700
Message-Id: <20210510132111.1690943-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510132111.1690943-1-f.fainelli@gmail.com>
References: <20210510132111.1690943-1-f.fainelli@gmail.com>
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
index 8cd968199e2c..4af5c7679624 100644
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

