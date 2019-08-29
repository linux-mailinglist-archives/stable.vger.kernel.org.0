Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5CA18DD
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfH2LgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41761 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfH2LgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so1439707pgg.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6UKYk23he3dGgebGJrG3RauZikPx4goXsUxb0kpSkg=;
        b=xvti4GEQ0/UPk2nKKLyO2tTOZPg7+31lw96qhbCVrk3QdQo4q4HNqbarF3AYx73djD
         V5arFRASUiOZIduD8dflJdHV2Nd9NMdb/daV+e+zGAsfXaOgWF/DLP7TzshTPE7EtJ+I
         sbhroYXEYVv+nS26O7sc8qM7ZOEMZT/V5bMtiDWFA2lsa8bZ8xDLtcnM9lzolhWMuBNJ
         Ao7Fne0gvklPDie5i5YFRhMjZzETIoVSv8Ve4igx3A5V5Hn7zrjFHu6RIFY9BfGl7R+C
         8qFaRLGk6xC4U0Evaqi1ejKpFDEcSjJ47F1a6IKa6MT+fLoe9IbnBBbQgwgNMQkktr46
         sHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6UKYk23he3dGgebGJrG3RauZikPx4goXsUxb0kpSkg=;
        b=S79OcZ1xTx8cbhJ8sBtjiowvs7bXAbhNsGhxqKoaFG+wRi4GnKWXeIr8ia1Lkr+n8U
         vUSgzTtw2C9vKrTlInZebdLPEjOw/nSEeWDQmlQ39/pAMYR4IeKvm4d98Wmo9O7I/kEm
         6vRIfA998UCe/QVgjyZfjwvApC+pPhP/uVgescpUEEHqWYnbMHISbHJGifACzV2COaz9
         vxJVrR0l44oFrkQ4N9BY8t8MRyCncPqSBRiTNHa3YEaXxNIaHL3GPPr9lxt2zwr1bIAZ
         hxxG68IMKwvjB9bx7TnihIp0MDkAMoGpMnqP6Je2ph0qCztvzLZ29Xb3tjxDQWHEI4Si
         TN5A==
X-Gm-Message-State: APjAAAWSPhpCF3Q/rf2sTLgNNcSai9nahgQNpikiA98lUVuHWcVLK/gR
        aZxPiKhjM/fzbH8bHixMi9wDtpJiQ5M=
X-Google-Smtp-Source: APXvYqxCwoWhuvuYuIIilS6mbpIrwxMkJOFDxNipnZBvLlgkotjfztm7kAJkUAfNPzqEJ8oBkpCzaQ==
X-Received: by 2002:aa7:91d3:: with SMTP id z19mr10725682pfa.135.1567078578038;
        Thu, 29 Aug 2019 04:36:18 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id u7sm2042123pgr.94.2019.08.29.04.36.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:17 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 32/44] arm64: cputype info for Broadcom Vulcan
Date:   Thu, 29 Aug 2019 17:04:17 +0530
Message-Id: <245df11a4507b678b87e3dea9116afd23f7b0041.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jayachandran C <jchandra@broadcom.com>

commit 9eb8a2cdf65ce47c3aa68f1297c84d8bcf5a7b3a upstream.

Add Broadcom Vulcan implementor ID and part ID in cputype.h. This is
to document the values.

Signed-off-by: Jayachandran C <jchandra@broadcom.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cputype.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 2a1f44646048..c6976dd6c32a 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -73,6 +73,7 @@
 #define ARM_CPU_IMP_ARM			0x41
 #define ARM_CPU_IMP_APM			0x50
 #define ARM_CPU_IMP_CAVIUM		0x43
+#define ARM_CPU_IMP_BRCM		0x42
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -87,6 +88,8 @@
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
 
+#define BRCM_CPU_PART_VULCAN		0x516
+
 #define MIDR_CORTEX_A55 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
 #define MIDR_CORTEX_A72 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
 #define MIDR_CORTEX_A73 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
-- 
2.21.0.rc0.269.g1a574e7a288b

