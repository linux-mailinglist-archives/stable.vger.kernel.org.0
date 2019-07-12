Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE95566644
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfGLFa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43560 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so3785651pfg.10
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBbWRB3LgLlv2c3U4FxHDhn97v+yXFInuDLMYZ1aFeE=;
        b=LE9qttKz9JVHQZJ301vvMUJGamwX7YDgGYxVrR/vnjiJ8Jz/5xxe4200tspVVRXWk+
         W7XipnbG6F97cOGxwyGXPdCqkq3BRx2g4y26HaEqjAsFETioKBf/BZTT1PQlDrGjo7ou
         EAeXfl3TsM9qubCidTFeGydMyrJR/c6bJijftJkl1MWUPIeVdAUp5JN31QVDwcLvHVR4
         8urkOnbfh7ph5eojT6bcKlyIEOF7SVTdfu7V8JVCECv1woL27Eib/wR68NZrbXu3wBhJ
         e58ovEnhDxWGkX3plYNZ+KErAl2nlKIP7jvpIT/lTh6EdP+WvOUY/9tEUQSwyx9u3ttN
         GtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBbWRB3LgLlv2c3U4FxHDhn97v+yXFInuDLMYZ1aFeE=;
        b=RDGu8mL5BVL0Y7hjt0vCC1M2usTduKonJCGqTVqE9xNUaOhASBX/m2YALcdzDvw8Gk
         yu3Ad7ZtNsIKT/R0A4fwQupHlTSaIMxS14Vyn7uDZZTdjgnrztW+wI8eBhtOZsVZsJHV
         CaxmU3BsqzexcitZO98z4fhjfyBu0Ou0bBCd3v/An1cYe020OvhEOEb1lO31iFsvgy6p
         qvwy9kdo7pgeQk0JKrDYEutrCLvFxqIrxdRVRpIH+bGSUJIFKmcz+pu6MHvsfTJ+Nszk
         OhZtrfkd55hhDA5M9kRClbzH6a7AFte/cKLGjgE8SLgfutDJfgWwA0XELGDMGgGOD1Yp
         hatw==
X-Gm-Message-State: APjAAAX1pcZMe4imeiFGhm4Qbf7rRsgkN1LMo1ANlikh36QzGZ6TW4ib
        j76CFXSqkd4rhMXS7FW1PXW9+oQWZNE=
X-Google-Smtp-Source: APXvYqxyRaEvat1PpF7Xec8SgqPa/995PZH5g9J/aKyj66PHzIjCnc1qgeDxt+I54TOuoUWo47TglQ==
X-Received: by 2002:a65:508c:: with SMTP id r12mr8006992pgp.1.1562909426531;
        Thu, 11 Jul 2019 22:30:26 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id q63sm10762553pfb.81.2019.07.11.22.30.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:25 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 32/43] arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
Date:   Fri, 12 Jul 2019 10:58:20 +0530
Message-Id: <6565b88d21dbcfbb592fbf7a5a00f20caf2e934f.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

