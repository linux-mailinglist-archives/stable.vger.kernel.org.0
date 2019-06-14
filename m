Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508A24527A
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFNDND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45411 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDND (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id s21so655987pga.12
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6UKYk23he3dGgebGJrG3RauZikPx4goXsUxb0kpSkg=;
        b=zvCEroJYai18z93zM9pHqfeGsgfcnwFiyoZEI/5uUllBxZqQQE9aZbZ5rkjcYL+mu/
         E2feYxj2JqPTTxe0pVL///P07AZgXGWknqiChAzY9DSg02c5z0e37gc46ggiAbNV5EQh
         jhiHXo/WD6NMAEEJ/cEYyzytTfwHgsg+GQYggeevy4B3ivGcDNcOHmqYLWnigEtNuf37
         p8/UOSxtcBVyPxDzoJM4qsUCLRXsuIkcl1BwrgMRwBaU5RH85Kb7dftoxbBdMV9vrYz6
         XDHhdRGqvpS8q40H9UbOb4VsxaelFTcoDXqvOSBSzkrlUwbBOElF7vEa1sJwqse7SOTd
         Bkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6UKYk23he3dGgebGJrG3RauZikPx4goXsUxb0kpSkg=;
        b=O1OmD4E5RCZqUAdCxwX3ksaMSdG7Y1uWet1m1d5f76xnA3vsryetlhrA9Z2e9JTn0W
         LJ86whkBgwiF7vWMA5l/kSULzANScTkOwKliL0CsVwigUXv9JkEOJf7Y/mo7VuulHxe1
         aGScGrgwEzYsiTUmPtf7wkniYMGi8UvgTe37hTOWJL0tXfK82aaz8yF4oAzBxxdxDBii
         BY8URWu2GjuHoomNc6E9KPZdnTSXmFVGrJobUUbM71EC9SLGWZp37UXV9PS5Mzlg6P6v
         aSp61dZaiABFPyDPsXb3xEXGkknH/jab3dLTT/rdeq15uABL4T4gIMq/+j3/UMTsSsFo
         scbQ==
X-Gm-Message-State: APjAAAUq+nFBanNBXJP0w6aI85q6xuRmMA+yDcZYBsjFwK4tN3mvaJcC
        pxB6XCNKtiPHk+pJRmJKkA7GXeZrDN0=
X-Google-Smtp-Source: APXvYqx+ra3YpKQWwoRa5iUExPJzGtThNQBAcoXTZoAe9nxiK6MaSF/dMW2wTNTLFt+Vb+aHjp9b0A==
X-Received: by 2002:aa7:8b17:: with SMTP id f23mr61291788pfd.194.1560481983028;
        Thu, 13 Jun 2019 20:13:03 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id u11sm996131pfh.130.2019.06.13.20.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:02 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 26/45] arm64: cputype info for Broadcom Vulcan
Date:   Fri, 14 Jun 2019 08:38:09 +0530
Message-Id: <619a06ea39c6f159f0ca0c629eb3859dff1235d8.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

