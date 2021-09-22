Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD0413F92
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhIVClm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhIVCll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:41:41 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD349C061574;
        Tue, 21 Sep 2021 19:40:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w6so783226pll.3;
        Tue, 21 Sep 2021 19:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s7wfjXtFAomlYgN8mUhDYQCW7K5EQ5gLWVAuo8ZUfD8=;
        b=RrdaRtL+TtoI29WBLxlGBga57N6PzPhZN6B3X0DPUasfi43uYJQ+qhJBf7Ho4HgtwQ
         Wc4m7okXw+TrzRFU7K/QSdZcGUlPY2pG37jYE8jIQUbsf43RdpPFCeynplBbxM4BRoZl
         8SkF3DaQFR+3CXRTFxS33fkH1icAKy5lub7+AGd+DCzvAP+9VCpcvKn0hC7ExoRkKSh8
         79y0mZQNs+UDW6DKbQ8bgCslyMAJ2ubfbnz96NJjQzwm+cGbEIIx09F57jdBjA1Oa0y9
         Z1FdoWTLuuOg9ElnzS3MFKe/z2gjVvFr1w3+QhrS+Xi5HgDYRGPpS3ovEQs/rCyK4Db9
         a/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s7wfjXtFAomlYgN8mUhDYQCW7K5EQ5gLWVAuo8ZUfD8=;
        b=NZVsh2SsjpLy1H0Icxf8C958j1TlAqUcymNnaLPNoHKgUxfZoz1MIdENfDkMvmWPjy
         Z8jLAtf+4WL3sFzuWqr/HfPQQeSXWS8BgNyBgoYcFLxvbHWFTYEX79/e5vsEK8h+oZ20
         qHKva+HJosY2ACD8yQDTa+oigdEqtdpaEPUpxaP6DM/60s4o8fjgtTKp8dTmnVgtD74F
         egYpo+5nz6vx02fsM/5MXmIi3NOXSYEANQfYkBYSalviO5L7n2ZW9TgWTnnOtRG1F/In
         eMOEunzVBQzu67V8j8Uc2JEDjVTxfp6odJt1wbu2JS1aDvBmIvQfPXcp2R8IDHwAkjAh
         9I8A==
X-Gm-Message-State: AOAM532bOsWkK1116tnvo+Fil2gv/4Nwt2D1xPdo8TDH9wvpQH2n/SYz
        hvegM4op7D/Cc+nkc/lVqlCr0tI9MpM=
X-Google-Smtp-Source: ABdhPJxbvZcAzNPok0i2Acse6R9rJzahxSib3VOXtHXifLK1HROnSuxLKkyVm0nzvoidAesCWB8B4A==
X-Received: by 2002:a17:902:9a49:b0:13a:430d:7e8b with SMTP id x9-20020a1709029a4900b0013a430d7e8bmr30497260plv.50.1632278411969;
        Tue, 21 Sep 2021 19:40:11 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g19sm3805321pjl.25.2021.09.21.19.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:40:11 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 5.10 2/3] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Tue, 21 Sep 2021 19:39:46 -0700
Message-Id: <20210922023947.59636-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922023947.59636-1-f.fainelli@gmail.com>
References: <20210922023947.59636-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 890cb057a46d323fd8c77ebecb6485476614cd21 upstream

Will be used in the following patch. No functional change.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/insn.h |  8 ++++----
 arch/arm/kernel/ftrace.c    |  2 +-
 arch/arm/kernel/insn.c      | 19 ++++++++++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/insn.h b/arch/arm/include/asm/insn.h
index f20e08ac85ae..5475cbf9fb6b 100644
--- a/arch/arm/include/asm/insn.h
+++ b/arch/arm/include/asm/insn.h
@@ -13,18 +13,18 @@ arm_gen_nop(void)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link);
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn);
 
 static inline unsigned long
 arm_gen_branch(unsigned long pc, unsigned long addr)
 {
-	return __arm_gen_branch(pc, addr, false);
+	return __arm_gen_branch(pc, addr, false, true);
 }
 
 static inline unsigned long
-arm_gen_branch_link(unsigned long pc, unsigned long addr)
+arm_gen_branch_link(unsigned long pc, unsigned long addr, bool warn)
 {
-	return __arm_gen_branch(pc, addr, true);
+	return __arm_gen_branch(pc, addr, true, warn);
 }
 
 #endif
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 9a79ef6b1876..61de8172a044 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -70,7 +70,7 @@ int ftrace_arch_code_modify_post_process(void)
 
 static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
-	return arm_gen_branch_link(pc, addr);
+	return arm_gen_branch_link(pc, addr, true);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
diff --git a/arch/arm/kernel/insn.c b/arch/arm/kernel/insn.c
index 2e844b70386b..db0acbb7d7a0 100644
--- a/arch/arm/kernel/insn.c
+++ b/arch/arm/kernel/insn.c
@@ -3,8 +3,9 @@
 #include <linux/kernel.h>
 #include <asm/opcodes.h>
 
-static unsigned long
-__arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_thumb2(unsigned long pc,
+					     unsigned long addr, bool link,
+					     bool warn)
 {
 	unsigned long s, j1, j2, i1, i2, imm10, imm11;
 	unsigned long first, second;
@@ -12,7 +13,7 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 4);
 	if (offset < -16777216 || offset > 16777214) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -33,8 +34,8 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 	return __opcode_thumb32_compose(first, second);
 }
 
-static unsigned long
-__arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_arm(unsigned long pc, unsigned long addr,
+					  bool link, bool warn)
 {
 	unsigned long opcode = 0xea000000;
 	long offset;
@@ -44,7 +45,7 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -54,10 +55,10 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link)
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn)
 {
 	if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
-		return __arm_gen_branch_thumb2(pc, addr, link);
+		return __arm_gen_branch_thumb2(pc, addr, link, warn);
 	else
-		return __arm_gen_branch_arm(pc, addr, link);
+		return __arm_gen_branch_arm(pc, addr, link, warn);
 }
-- 
2.25.1

