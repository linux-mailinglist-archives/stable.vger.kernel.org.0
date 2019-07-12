Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647A366640
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfGLFaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37243 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so4207612plr.4
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D7dDso9mEizkFlSNIpcQXEVsYMAg+0dXCi9osCif4dQ=;
        b=SHX7e7FubaU7wyT+0UYJDMKcleNuApOH3nQjSdAAJSgKC8Q+xG65Uzre6wh+7Sf1o3
         W+qVNTVWlECArHmOnif3X4WWMWuL5pI07rLChElsvGHJFDCihXEoQfg95FS4j5+Dr5bc
         c/ga9/JS/1+6kWpJGDkBOWcY54FXVwqT5/1S+bPCpOKqTwJjITMrmJByIWxeuuYKWq22
         sm87pvXFxIDBVpEslQEvWHvl2pRxE+K0YB+gz5O8ECmtQYbNlMnE1fHDyJSwLTxraHym
         T6L/4VWus1+kiQFadEKTHBtw/FX2wmeSV3WzH4Gk0aNApRRHiO9JSPgUYP4UjP/QsgPq
         d+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7dDso9mEizkFlSNIpcQXEVsYMAg+0dXCi9osCif4dQ=;
        b=c7uZqUZlimDZYouiywVpxV5jpJyZbpESc+B3tLfQraWr/JKBiPJBeOyBG+gd82Asuu
         mqj6m7cXjaOaABozry2xQ658EG9QYpm56vAI7qz5hzLoc3F6BHDqGR0fbialpMeAO9SS
         bm5lnAm+s7gHw1+ece9rUVG3mle5YNu9OmeMDCSjBbWASTAIq7c5DsChh0KCSRUv+mn6
         DEnNTQId2yaIBx6PjSJ+kONrD+qPiABmiSZE5L1OYZO+4WtRC6JRBZgU9KXhj6+6dNqs
         Lq3SBnQa7aNg+qqfbOHbj25SiZLj1zSPmwc6Gn5TDOdIqFBRls5c0OkLFssmoCGC3GRk
         sYBg==
X-Gm-Message-State: APjAAAUC/SjWMJGq/XGIz0DFFPLCQuQ02tZvluyC4Y4FRPAC4pAp5Tf1
        UXXz86F6D89B4FKEY75RhBgj2sO+5zw=
X-Google-Smtp-Source: APXvYqyIaG/7Rrm/kLEPryUwj4JWmUkr4V8IhVlPS2BmeeOp9j54WkRyBNl7cKrjGq7h53MpgS18mA==
X-Received: by 2002:a17:902:8d97:: with SMTP id v23mr8886449plo.157.1562909415500;
        Thu, 11 Jul 2019 22:30:15 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id w2sm3669852pgc.32.2019.07.11.22.30.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:15 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 28/43] arm64: cputype: Add missing MIDR values for Cortex-A72 and Cortex-A75
Date:   Fri, 12 Jul 2019 10:58:16 +0530
Message-Id: <70bec6c6d4248724df18ac5b7a0719d7d9733e9b.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit a65d219fe5dc7887fd5ca04c2ac3e9a34feb8dfc upstream.

Hook up MIDR values for the Cortex-A72 and Cortex-A75 CPUs, since they
will soon need MIDR matches for hardening the branch predictor.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Add A73 values as well ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cputype.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index f43e10cfeda2..2a1f44646048 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -77,14 +77,20 @@
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
 #define ARM_CPU_PART_CORTEX_A57		0xD07
+#define ARM_CPU_PART_CORTEX_A72		0xD08
 #define ARM_CPU_PART_CORTEX_A53		0xD03
 #define ARM_CPU_PART_CORTEX_A55		0xD05
+#define ARM_CPU_PART_CORTEX_A73		0xD09
+#define ARM_CPU_PART_CORTEX_A75		0xD0A
 
 #define APM_CPU_PART_POTENZA		0x000
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
 
 #define MIDR_CORTEX_A55 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
+#define MIDR_CORTEX_A72 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
+#define MIDR_CORTEX_A73 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
+#define MIDR_CORTEX_A75 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
 
 #ifndef __ASSEMBLY__
 
-- 
2.21.0.rc0.269.g1a574e7a288b

