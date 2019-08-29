Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7404A18DE
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfH2LgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33107 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2LgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so1465761pgn.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBbWRB3LgLlv2c3U4FxHDhn97v+yXFInuDLMYZ1aFeE=;
        b=Xmq4KtCB2MgdeuspBG4G9Poq1/jtOphEjCwUX4JBS0tTbJR6EsrIcbbYtsH4aMlJJU
         zF5NFzJ1mQDB9rIzf7r+6kkfO2oqqW3pmymoydoaRIHU48YwvkASRwwpa8vKfG7PxDK2
         I+N6jsRG7GqPT9PHnLowmTx6SNnP1Iz+8eIuUt19E83TRz9K1U/l40AlV2y5byn48NYF
         61ybmSlsjqJM3sndxzmVlQF2Ekx1XeqcCttUdUkgpYlpN7uuibesHDGoxHdRGxesTYyU
         cG5/iWvOwrjqJx1QqirV1O2xGFIIMHybQbVZsh8MgxA3fz3Nk7V2y02cDqhm0jJk30iN
         NYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBbWRB3LgLlv2c3U4FxHDhn97v+yXFInuDLMYZ1aFeE=;
        b=ovrz1wcwABlKpv3dKN1lfKaJtUOthdw5qw90+TB6HaRTtt67tW3ySf2K+OhnkLxfTA
         cNL3ovxrrRxNVscvALu5tSpWofbboQzadf+MnN0u0r2CZpBKcIHxLLNrZ/Pwq/RFrukT
         GFwrrU8j6+erJfaVG1EFD8XXliqtdAQ+7Li9yLUbRFTty7HpD+/jgQPG6bxKq43h0D+1
         YxogZ+cONUkTBzeFc/FaD87xrccMykneCJ1oEyNNgBEBnn3uWxv+NJej5p5SzNCNKGXo
         V3sNztlAyRmy4F2vb2gc/c8D+VQwNYQC+5ttfzn/x+WB5S4hIV015LpXRYLjgGN1MvfN
         VLxQ==
X-Gm-Message-State: APjAAAWxAmBL+7GyytZsVyx7cssm8nq0xj6cKgEf+8JLE3me5lWYoG7N
        UwVzTlU8CB9BealbYgP692zH0+9CRuY=
X-Google-Smtp-Source: APXvYqwMT0cFTHEugZCxJSQq4bSDACB+Sgk4BpR3n0Se1eB7cKTLjqyvZhASM7jxAvssWS5gOWCocg==
X-Received: by 2002:a65:534c:: with SMTP id w12mr7899421pgr.51.1567078580556;
        Thu, 29 Aug 2019 04:36:20 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id w207sm2838820pff.93.2019.08.29.04.36.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:19 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 33/44] arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
Date:   Thu, 29 Aug 2019 17:04:18 +0530
Message-Id: <30a3c51e3b96d3db1c1ac10800c22b67c484a377.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jayachandran C <jnair@caviumnetworks.com>

commit 0d90718871fe80f019b7295ec9d2b23121e396fb upstream.

Add the older Broadcom ID as well as the new Cavium ID for ThunderX2
CPUs.

Signed-off-by: Jayachandran C <jnair@caviumnetworks.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cputype.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index c6976dd6c32a..9cc7d485c812 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,7 @@
 #define APM_CPU_PART_POTENZA		0x000
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
+#define CAVIUM_CPU_PART_THUNDERX2	0x0AF
 
 #define BRCM_CPU_PART_VULCAN		0x516
 
@@ -94,6 +95,8 @@
 #define MIDR_CORTEX_A72 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
 #define MIDR_CORTEX_A73 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
 #define MIDR_CORTEX_A75 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
+#define MIDR_CAVIUM_THUNDERX2 MIDR_CPU_PART(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX2)
+#define MIDR_BRCM_VULCAN MIDR_CPU_PART(ARM_CPU_IMP_BRCM, BRCM_CPU_PART_VULCAN)
 
 #ifndef __ASSEMBLY__
 
-- 
2.21.0.rc0.269.g1a574e7a288b

