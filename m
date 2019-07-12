Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6114A66643
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfGLFaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45463 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so3986124pgp.12
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6UKYk23he3dGgebGJrG3RauZikPx4goXsUxb0kpSkg=;
        b=xZzGVWR8T9WDYKnZD9cQcFnGCxN8nWgyxu2OL5q872CN2Y9744zFo5JuLSgVPhsOBj
         t/CQf4r7XwcKk1lOhy4PojcMHWr1Q9XK4gnBIBG8w3NiHs5EW4/ofIZIUU0SRBsz0QIy
         RjphrkppKOzA1YewEcOFDwkXGIizbxPiX5q0e+vLi8ytNqVsk8UDidD08iLDqqyzdHVu
         JAF8ef5roiSVzR3ORFQE2/no0PrTtVl/PGCm9sXwivrz2n1+8ZO96lTRBGVdxryK42lN
         PgY2Gc9AtCJuOydtc5HEMH3PEkg1gn9buIkCOrsiYCwcOZt8zGziycjhZa3KvhGwc2Hs
         xwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6UKYk23he3dGgebGJrG3RauZikPx4goXsUxb0kpSkg=;
        b=i7s1NwG/kKp872KZ352vehZZ432mKSZhbt5nKDvQSWFdpxAchZ6lypWHrHvLWMHywi
         yjpr576kAXfffqOTnFSbzP7ANnQgC4DxHVcG/Y+P+e2W7Vgi12Oru52k+pTPDcERGkka
         QHBzlBJP+8j49tyWeOwTh001cO8vs91tUBNvXLo5trxY9Xp1BvYn851YuZ+vMvGr6iMM
         cmOWh3HyNgV4YwWUEMRGapW3PypWMGVV8CW1HTJ4uemrmxIAdU52vO6RFzBBl4dqvC7b
         yZi65j8kzLRJ3yllusw2w+n5oeA95FQsE0J2ywTNc0SEKBfNyuvRiFsi8fvDZ0ze9wRH
         bT9A==
X-Gm-Message-State: APjAAAVUJ7PA4c87Sa1LUtjMHSmJDxaaMxxJZer64caN4WJrVhxKAzk1
        51oi4AP4k/OSIgx4Irrc/pvsCP2WOgw=
X-Google-Smtp-Source: APXvYqy8HmvtHu/rBwqr8MJMve38YZ4RUeZD18XlVAKT2TfZnLcz8sXDFUEVNnqH2tDQvkcljgWSPg==
X-Received: by 2002:a63:2004:: with SMTP id g4mr8286371pgg.97.1562909423556;
        Thu, 11 Jul 2019 22:30:23 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id v63sm7703899pfv.174.2019.07.11.22.30.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:23 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 31/43] arm64: cputype info for Broadcom Vulcan
Date:   Fri, 12 Jul 2019 10:58:19 +0530
Message-Id: <91c8c76418c3af9daeab48c623e05eeb70f20491.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

