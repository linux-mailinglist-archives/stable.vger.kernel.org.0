Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CABA18D9
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfH2LgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41830 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfH2LgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id 196so1857010pfz.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D7dDso9mEizkFlSNIpcQXEVsYMAg+0dXCi9osCif4dQ=;
        b=ARrmgjAQyWJ3A4H4QgsubRRxM85gcS37EsYBleh0p2pXl6UY9hbPYZcOyuJR3mVRa9
         +QWoqI+LoqVQna7nhm7rI1cOu0XOtVBblELb8gpt7GtH7GBQ0foQJEzZIzr88uCClaBz
         qqFVG+I6NBY9BKoxQvSXqR735A5i1oKRwChtj3giEyO112Yb7ZenwG7LdlyGoK36dazL
         i3RsOyEsdSdbIKPtB6BV3CiElXyPRHj2rPUdopOYNYkggTMGIbFMNZn4/cQOvl5+Lalf
         aTpS/LgRJqgkQBfqjcrbCbJO0To4tgT8DZMiY8o1G3IakSjVFzJigRQkKNepKEymVTz/
         shNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7dDso9mEizkFlSNIpcQXEVsYMAg+0dXCi9osCif4dQ=;
        b=RFvaObLP3q/IlrFwwDVp9S12u9m7bUHYd3j12s4+3kTrslh199h1lQFSVzlsMW9OJV
         c836eWsV7T2az5A/Zytf+KeBBRPjAPVAWz7va7/gK7OaCm9feVDFg9V6XiE1DhYCh0W3
         PYnqqQfQe8HG6gVU1FoCKN6Rd8hmQo1q4X+8R3QJgzddm7rMYpMNgBAsN4Q4lYqosbzg
         AQbOvUgyLHGL8VNGDKHgd7QyDwFcGAOlX2i+9frJya5etR5aQYW2efQxgw/tX7S+qJ3b
         n6QNyNxo+7xh2jKZk6pZzPhj4/STXLqpc/fWxB/yNadH3QUxKAxwh8IrRgYg0p1U2+4W
         /30A==
X-Gm-Message-State: APjAAAXZ6Hk85P+XQwS2sKOys38x0p0KfBCekV7KE3nS507COwZCV1FR
        IKNxZ5y4mN6XICuj0WvpI0GNS5psOSU=
X-Google-Smtp-Source: APXvYqyKCagpxOr1sVZtXw0tQn2B2kM7k2upAkKJrVKCRIE4bO3JT3iMpRghGhGOZed8ZpAd44rKhw==
X-Received: by 2002:a63:20a:: with SMTP id 10mr7790456pgc.226.1567078570025;
        Thu, 29 Aug 2019 04:36:10 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id y14sm1899716pge.7.2019.08.29.04.36.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:09 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 29/44] arm64: cputype: Add missing MIDR values for Cortex-A72 and Cortex-A75
Date:   Thu, 29 Aug 2019 17:04:14 +0530
Message-Id: <6b46a425ec244a76a7cebf5e1cdfa6e1d0a6c7a8.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
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

