Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B73E7D722
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfHAIT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:47092 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfHAIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so31830981plz.13
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QHSmiN7bxUJS4+X9m2RMygxyxd4x6cpBibWrQPbZA4=;
        b=gyCpFTJuLM7MvHrK8TfXUg8OQIEf7DynnCZ6YICKbZ9EiGi8EM99TONAPxKGNc6kQm
         3hFuJY62i5Ew+NEtv8tSafNG/qzhe+cjGbtSARPHQUEgyKa7zHEXbRZAV4BDT2ZJm6vJ
         jsLinmkCLSYDBM41ms3BOPj8dWBOwQy+qV8V5vfjzLG2LWvD7CT76RgDp7eQxoUPllQP
         vB6D8S6tyncSIKwqOQTMSKQsjlWIlrO3dpDkeEEquvQuhJq8dk9JzFU9i1ub9dz0xX/t
         usBd+1LWn0IdleXWHo43HxgyU9wCR0JTA+VhNBKRy+wm9IC1f13K/7l7mVnHPaBOBMZd
         3YAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QHSmiN7bxUJS4+X9m2RMygxyxd4x6cpBibWrQPbZA4=;
        b=TyJTefNmzq7wcL7ESOB2NXUMj9dYtyiQdMwOu8NHHGLst2Jk7MIPDXMFE+FLNinzg7
         HZGtoKxaU1N66iWDpWvpfJ6uM9X+aXnihE/6pJgoLqnxOPskLXwTUoHr6YtNI04dKqN4
         Mw0o9KhUmwhA7esmpMl6wWfTfC0w5Md2tPf+kA532QjApmAfGBYIW3X8NUenysh8CZxW
         O9NwqSE/TJf6a/ASdxbrHEnxajz9pjsBYDz7aXzYGSE/o0Pmn+xZ283Yxqya7ZgGQY7Y
         akSt3sI1IPvvyS39VfY9iPKzQQxiB7HbXi8gncT+oT/sVLXoGM/MTGc+WWw85s3zAWbu
         SH8Q==
X-Gm-Message-State: APjAAAUCQszeKYRj6LrkAdBFq4XE69vfefCftCL6iyp+JT2VlN4YcixJ
        lEAlO59Co/pETAbOeaZNRuVuGVlwmpA=
X-Google-Smtp-Source: APXvYqyVg3JM0Xy4ecN/+7+J9RLJ0NX9tIxjkO6xCJk1Yj66fP0gTNTIsUc9HEVBU4hgAjikmydkbw==
X-Received: by 2002:a17:902:968d:: with SMTP id n13mr77405641plp.257.1564647598670;
        Thu, 01 Aug 2019 01:19:58 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id l1sm91580486pfl.9.2019.08.01.01.19.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:58 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 09/47] ARM: add more CPU part numbers for Cortex and Brahma B15 CPUs
Date:   Thu,  1 Aug 2019 13:45:53 +0530
Message-Id: <c6914b21df89806a01da68a8b4abcdd427b7b75e.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit f5683e76f35b4ec5891031b6a29036efe0a1ff84 upstream.

Add CPU part numbers for Cortex A53, A57, A72, A73, A75 and the
Broadcom Brahma B15 CPU.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/cputype.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index e9d04f475929..76bb3bd060d1 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -74,8 +74,16 @@
 #define ARM_CPU_PART_CORTEX_A12		0x4100c0d0
 #define ARM_CPU_PART_CORTEX_A17		0x4100c0e0
 #define ARM_CPU_PART_CORTEX_A15		0x4100c0f0
+#define ARM_CPU_PART_CORTEX_A53		0x4100d030
+#define ARM_CPU_PART_CORTEX_A57		0x4100d070
+#define ARM_CPU_PART_CORTEX_A72		0x4100d080
+#define ARM_CPU_PART_CORTEX_A73		0x4100d090
+#define ARM_CPU_PART_CORTEX_A75		0x4100d0a0
 #define ARM_CPU_PART_MASK		0xff00fff0
 
+/* Broadcom cores */
+#define ARM_CPU_PART_BRAHMA_B15		0x420000f0
+
 #define ARM_CPU_XSCALE_ARCH_MASK	0xe000
 #define ARM_CPU_XSCALE_ARCH_V1		0x2000
 #define ARM_CPU_XSCALE_ARCH_V2		0x4000
-- 
2.21.0.rc0.269.g1a574e7a288b

