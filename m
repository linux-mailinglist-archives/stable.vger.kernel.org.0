Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2437D726
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfHAIUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:10 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40205 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbfHAIUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so33598876pfp.7
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QZrcuQ9yf2dvoM/LK+86CRpxpDI5KmyMnFr+EN3SZok=;
        b=JQrn7jF9JWShYAafGE5jWBSK5tUub+i5d0k3JeBjKeEx25TQaSaJbJslZkhkHNb+bK
         QKBOKxd3TZf8QMlTT4Qt5XYcG6u0gxoFzgJwT9QQslAj+EWH0213vShsW2zuWb6VnBN2
         H5nqpJQeFu8GwiuN5I9rEppi/LrPVQJLiPhzqWaMCg/XjRiHSzSHb+auX92vT2NvMfSj
         MBoOodjo+7SKXPMXm4C0zwbxomguH+XuMK4Ymqb3IImOa3xZSQsAVjfb1NvQn7qr7Flb
         UZDtChpZwh8Tl7v7Epe01QEqJaX1ymTnLN21DjAv3mfSq78I++NgjpoX8yq7M2x/pldO
         gZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QZrcuQ9yf2dvoM/LK+86CRpxpDI5KmyMnFr+EN3SZok=;
        b=b8DP9pSVM7Ow6VBW+5TLQ9Og0VKYjDPVaLAwrrkUmUI13xQi8oXDGwR5tCL6cNYgHP
         nO1ZSPAsUevMEm4SXD+RZQW2Hds6u8j7t557QR1niewQpOG73aOrv1J8DXC/l2Pruoe4
         Vhsy0kyye7YaBaqdG+PLcDwxXxjSS/htX9T9PTiEKlFOcgQUhrxr+Am9o8wOSRtdVNfW
         nVThAPYx7mdls7c++yuju7HZBOuFVrcRTifhL1JEJLihEau8GBRAWW9gway43vX0xj62
         o8TUKTQVKpwoQaJEdNMHnoAZvvHTmcFQ+Fb2Sw7OfQZMJA18+9VZXrTM5yQtJ320miki
         Wtcw==
X-Gm-Message-State: APjAAAWZWJhMXjaaNqzIGuuHqFhL+Y0Xz0KXYl10UzGMLVezbMdLpHFP
        4WVezNLou41ajBxaKldrizS1NGHC0NI=
X-Google-Smtp-Source: APXvYqyrGUQC1ZAWht9Zoam/7t7fuGAI9uez8mB6s7RyA4jBJrQHQZxRXtFNqsg6bkVFghKXE90Eug==
X-Received: by 2002:a65:518a:: with SMTP id h10mr116068175pgq.117.1564647609294;
        Thu, 01 Aug 2019 01:20:09 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u16sm4035318pgm.83.2019.08.01.01.20.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:08 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 13/47] ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre
Date:   Thu,  1 Aug 2019 13:45:57 +0530
Message-Id: <f894ea52cb1cc2e7bc2a791741b912387cb4c8e7.1564646727.git.viresh.kumar@linaro.org>
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

Commit c58d237d0852a57fde9bc2c310972e8f4e3d155d upstream.

Add a Kconfig symbol for CPUs which are vulnerable to the Spectre
attacks.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 41218867a9a6..7ef92e6692ab 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -396,6 +396,7 @@ config CPU_V7
 	select CPU_CP15_MPU if !MMU
 	select CPU_HAS_ASID if MMU
 	select CPU_PABRT_V7
+	select CPU_SPECTRE if MMU
 	select CPU_TLB_V7 if MMU
 
 # ARMv7M
@@ -793,6 +794,9 @@ config CPU_BPREDICT_DISABLE
 	help
 	  Say Y here to disable branch prediction.  If unsure, say N.
 
+config CPU_SPECTRE
+	bool
+
 config TLS_REG_EMUL
 	bool
 	select NEED_KUSER_HELPERS
-- 
2.21.0.rc0.269.g1a574e7a288b

