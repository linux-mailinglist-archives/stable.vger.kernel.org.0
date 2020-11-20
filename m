Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEC22B9EFF
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 01:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgKTAHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 19:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTAHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 19:07:13 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF2DC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:12 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j19so5723446pgg.5
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XuhETvPtQA5Z9kFuaSbH4siF/bUyGqipG60HblBYyQg=;
        b=U+eM8SKHA4JluSt7DB7UrObxLyl+BjXIDmLmNN9dLHZvL9zhmLDh8PHVolxUcdb5Qy
         nC6FT4W6UvLhRZ7hQJw1k3vLYOlzibo1JLkBXOA340eEgWEa8239csSRz5snye/MIGFx
         6G8hkCSbRAB0nwvkGKLbpZWvI8DQ7i7T0c134=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XuhETvPtQA5Z9kFuaSbH4siF/bUyGqipG60HblBYyQg=;
        b=GdIbD2fgk+wS+X3AqfG8ZOVbcHDOYQyiGLeDewRiJzlS5NHT4si/th1x6VMuiiyWIF
         TTuAzLwCqaK2EaXQSY9cqjKTnxXYPbsbHG6MygH7eJfT9u8CjYPMGXDGPpFEIVJdFdyZ
         bxj+eDOSzlvWdeKRrwmXS/2aEVpQfmEKWxYDeK15FPYaBBbagHpNnOAiW5zq/A9LMwO+
         BbVUmKgmz+h9KEWw2P7xYHV0STv1txIOT9k0EC1oSt9DiGk2MsLeHjHESZIH2iMJzh0K
         MLkbyKI5ixFmROAZ0iGtrQnT09EhhVAJ///Z8r6OgXpSUyklQgNXPIb2qfEQX4qY2naD
         wlTg==
X-Gm-Message-State: AOAM530Vqk5C/lTF1C5AOWz6/tFUT8ltdtpInO+cYS22AmS2tU0nmTsQ
        i9ysQKqKAjfyEycx/P4jhoXoZDh+e4r25A==
X-Google-Smtp-Source: ABdhPJymN9AoBT6HbIZyx+vJ8WjdNsuDYrcBo2wZPdYJjP9K/HbS5shmZDT3nJBKE6UPGeqwjdKyMQ==
X-Received: by 2002:a63:3c10:: with SMTP id j16mr14685802pga.140.1605830832248;
        Thu, 19 Nov 2020 16:07:12 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id s21sm860458pgk.52.2020.11.19.16.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:07:11 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.4 1/8] powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
Date:   Fri, 20 Nov 2020 11:06:57 +1100
Message-Id: <20201120000704.374811-2-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120000704.374811-1-dja@axtens.net>
References: <20201120000704.374811-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a definition provided by mpe and fixed up for 4.4. It doesn't exist
for 4.4 and we'd quite like to use it.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/include/asm/exception-64s.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 3ed536bec462..26f00ab2d0c9 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -597,6 +597,12 @@ label##_relon_hv:							\
 	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_HV, vec);		\
 	EXCEPTION_PROLOG_PSERIES_1(label##_common, EXC_HV);
 
+#define MASKABLE_RELON_EXCEPTION_PSERIES_OOL(vec, label)               \
+       .globl label##_relon_pSeries;                                   \
+label##_relon_pSeries:                                                 \
+       EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_PR, vec);          \
+       EXCEPTION_PROLOG_PSERIES_1(label##_common, EXC_STD)
+
 /*
  * Our exception common code can be passed various "additions"
  * to specify the behaviour of interrupts, whether to kick the
-- 
2.25.1

