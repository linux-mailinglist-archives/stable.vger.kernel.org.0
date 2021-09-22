Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358D0414E78
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhIVRB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhIVRBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:01:54 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E38C061760;
        Wed, 22 Sep 2021 10:00:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so2781476pjb.5;
        Wed, 22 Sep 2021 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s7wfjXtFAomlYgN8mUhDYQCW7K5EQ5gLWVAuo8ZUfD8=;
        b=l69JSOUmeeJduapWz/WvKn0j0en+hDCwOtCozxu7fqjEBLsxqDNtHY+F52kpKbVZ15
         Sj8MmYuBiwsFmwpmw0CB7PULOIfcfg9NdWYdOugif2sXlagaHS4a+5OCZTSy7h4iUSQ5
         JAGrf/qMZKeK1OWUm9JLTeg0hG9bavyN0O882Sdeqav4c9aFIYH2vW3XIN/3YbPAAZRx
         3511OJYxPDSmHO93aVLfmvzgABi89jmVW4uxGPJmOHcER+OF5VsNJDdxJ61QGrQJ3dk6
         VSc1WcsHwISNFt4WR1TVFahhfP+eVjGl0NroNJu+SU796/lGzwsEymtAYG1OZY5mlSmF
         DmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s7wfjXtFAomlYgN8mUhDYQCW7K5EQ5gLWVAuo8ZUfD8=;
        b=7rysuDFhEEKWBcMXHv1YjLKDT3pUC8sBrPodGo1ui99mY91QsGzJoGmlY2bHuUOO/u
         kz1g7Xkb8PuOZ2qeD+KtVf2lZ6WpxODykQkcZnlfYpQ+QgDo7to3clK45u2jyV6dMd++
         RSsT3XxziXYhv5lcSO8VEwCRfyhqS9+6HEcMw/jJdHEd6SLEZhFGXDxGMHe5VVBc1nxx
         AXKMYtQC104AUlebOpnwx/z1I7cQOBELHy8n4kix8iL1q+YHdG26IXGPl/Deeyp8LqzJ
         TQ9DFcty0kvis6XAoe2NcDxf4FCxmnrNbdSLLLvIaHNg+vDqaZ2Q7RqjM3B2IlotEjKZ
         dKyw==
X-Gm-Message-State: AOAM532muLIoTDWdloZL2GbZLn9Aw4lGYUkJs6Y8jhTTOV4hxU7WK4Zv
        DGrcrpQ+RVFo0CBk0/afnN/lBO1CQUk=
X-Google-Smtp-Source: ABdhPJzTwJVxYZYIcw2RniiX55Tl2YfXg5Wyi61X4drJE2HZrw6lzf9GBED/JziRI1HlkKG6OZpFOg==
X-Received: by 2002:a17:902:a50d:b0:13d:8d71:aa91 with SMTP id s13-20020a170902a50d00b0013d8d71aa91mr609471plq.24.1632330022190;
        Wed, 22 Sep 2021 10:00:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j23sm3196336pfr.208.2021.09.22.10.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:00:21 -0700 (PDT)
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
Subject: [PATCH stable 5.10 v2 2/4] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Wed, 22 Sep 2021 09:59:56 -0700
Message-Id: <20210922165958.189843-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922165958.189843-1-f.fainelli@gmail.com>
References: <20210922165958.189843-1-f.fainelli@gmail.com>
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

