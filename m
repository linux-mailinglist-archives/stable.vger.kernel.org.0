Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AA2CFDD3
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfJHPkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38422 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfJHPkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id w12so19988157wro.5
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZ75OeBMeoZr9SzaWQDvyxO7uuvtCYY2aDYU12NSuuI=;
        b=B/loA8XflODrFoDoqVtUDasNehNF1bXoqm3fFdy0PiSuTTcNehEJBzYHes+gyu3kBJ
         EKap1MovSD5k+vZ8PMEbEY04/kKAKDkjZv2fiH+qetAyuxGemdM9VvK+wUsk66owfolS
         2YBshwMSE14mZK4qwCVF0e/kEbZHNMS14q1j4NFUsS4Dmz3ecjElt+fHR1UMlu6d8Apf
         PGm8wY+x0Go1i7pK4EvquM1ptgJKgl80sdzzQDZ9YFjP3ZLTk0iWc7spNmtsaAV/6PhA
         WJFmzx98eS7PjeVy4EFeXhC63rQFbmFjw5udFfMIePBiSAWeq3+ZmPTF4GkJBsCAkpPr
         RYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZ75OeBMeoZr9SzaWQDvyxO7uuvtCYY2aDYU12NSuuI=;
        b=cWITzGFtcsQuVS1eLm9+6TcnWZ2UlnXXRLwdPLNlNN1D28KHqEs2H5pDktzX6JB8Di
         /rnRMQqFylCKMhED92hC+1gGODt/Wvo8ZOJf6KsqolW9sogx5Jgp6qfJ25eqFYgk9rTC
         wxwG0Lgtvrd0b9SKVH1kuDksiqRRG5rSOvelaIKFD7na2BaznSY8C0LcBBzkONyj39xt
         q5kpnnqw1rK5sKFw2lWa4d1t7ElYIRNBb+Xm/8Lzbok5E3Fvnd77nTqtx+D+vkfycwgk
         Q0oaFZumpD+cDhGN2FLHAITlL0k+jrbdtLn1the7MuOknmjNgIal+eq0fi0K75sih7Ge
         fz+w==
X-Gm-Message-State: APjAAAXRu9PCccwLQyRGzdwVWh4qJNn2YzybSMXT6qiWQ8Oe0tOTjllP
        l7ZE2f+aIR3Xrgd8t+Tmx1dP6g==
X-Google-Smtp-Source: APXvYqx02vk/qY0ATFSuVTaHh20ri4CJI9t1QERSiZ3DslsS452ku/hpo6ldDiHZYljfBdyFuD7vgA==
X-Received: by 2002:adf:f649:: with SMTP id x9mr27061505wrp.163.1570549213184;
        Tue, 08 Oct 2019 08:40:13 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 04/16] arm64: docs: Document SSBS HWCAP
Date:   Tue,  8 Oct 2019 17:39:18 +0200
Message-Id: <20191008153930.15386-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit ee91176120bd584aa10c564e7e9fdcaf397190a1 ]

We advertise the MRS/MSR instructions for toggling SSBS at EL0 using an
HWCAP, so document it along with the others.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/elf_hwcaps.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
index d6aff2c5e9e2..6feaffe90e22 100644
--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -178,3 +178,7 @@ HWCAP_ILRCPC
 HWCAP_FLAGM
 
     Functionality implied by ID_AA64ISAR0_EL1.TS == 0b0001.
+
+HWCAP_SSBS
+
+    Functionality implied by ID_AA64PFR1_EL1.SSBS == 0b0010.
-- 
2.20.1

