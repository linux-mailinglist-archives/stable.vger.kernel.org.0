Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5323162D690
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239982AbiKQJWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbiKQJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:17 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C900697CE
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:14 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p5-20020a170902e74500b001884ba979f8so1023626plf.17
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aLbsH7WYG/lOn1bN+wvx5rmu3+10reQZE25tRgVzEQ4=;
        b=U0oL8IFLm+S1eJlwAaTYY0RE1PKHv0dq5vhEi9XBz/y+quyNq1Z8QI8Vf9W42Nl7oI
         zvb0ctzQqRDgGZAteHRGK3S2BItp2lNVpawaJT/MIf4wfCVWwX0hu3aWVasfkzOA9+bc
         2lKIeiT9+iHLpBKiF8TuWtkBCKyYJJ7NIHDNRiiz6QJ/WNTEDdzwhm/99VzDXqnQPGeU
         h5r9oGS9a0vUkfrTmcVrKzuzsF9jDkvLR7IQ8ciGbx4dvCwl5ANiR5fMeNZGyugiGT1c
         +BW60SrC0TqCEIxZoZt3BeDDjvMmjvwY6vWAMhiM69UdFS9aQHZywNzYqNS9nQmBEFF8
         U0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aLbsH7WYG/lOn1bN+wvx5rmu3+10reQZE25tRgVzEQ4=;
        b=llq2wJv2Ubd2ubVcQsxZAVmdaYSaOcYusX3lhB/Sd8/V2eWqRlQfDQBChhNT474zGq
         txlp5fmZrdI19f6VSF49ZUgWa/XIdyRXZ588SgIniGZf6Ba8IwZwOEfnou98u0tSZfch
         wumUa42EJGLAE56gSA1ZkxVg1IeSz3CovkzTaBLHlXJPLEWY1VG4njE3icCXEbuiD+kO
         9bkkOquqKK8Tk+XWVnRv8yxYcJPbNOnUbD1ay2xdDu09Pm9isvmDa6XSHRYWdQUpaEOY
         nMQiht078ciIei1ovQd3fsfitLMVgPfUND+39pxU7Y1KjsPo409lgkcqmUfBntec4yEu
         WhrA==
X-Gm-Message-State: ANoB5pmOi9UIq7TDa7cDyWeia7jFFjBsISdt6ySyUgNwUP4t1znz6pGa
        BhZQhdfwqexoVYl9/L1FNP/4cLrv1RQeptlLxa0eAHlZj79TFR3mcaFp5Kn5PXxS/6nyasvmev7
        caa1JMgZbJFi9cNJCNwOPf7Lx00tgN9vkmyvlmPKdC2XDytJP6GdrUaCNGHx9omMf6o4=
X-Google-Smtp-Source: AA0mqf4oXMm2N8WThO+25Xbi6JZoa+7tJxGPaMJ7HtBaZnvSxQk0fXUtFlg42AFeKo8/4ItolHLGhib3Dehh+Q==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:90b:a17:b0:213:2708:8dc3 with SMTP id
 gg23-20020a17090b0a1700b0021327088dc3mr804562pjb.2.1668676933599; Thu, 17 Nov
 2022 01:22:13 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:46 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-29-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 28/34] x86/common: Stamp out the stepping madness
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 7a05bc95ed1c5a59e47aaade9fb4083c27de9e62 upstream.

The whole MMIO/RETBLEED enumeration went overboard on steppings. Get
rid of all that and simply use ANY.

If a future stepping of these models would not be affected, it had
better set the relevant ARCH_CAP_$FOO_NO bit in
IA32_ARCH_CAPABILITIES.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/common.c | 38 +++++++++++++++---------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f184c4149327..4c1db00f348a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1043,32 +1043,26 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(HASWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_ULT,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(HASWELL_X,	BIT(2) | BIT(4),		MMIO),
-	VULNBL_INTEL_STEPPINGS(BROADWELL_XEON_D,X86_STEPPINGS(0x3, 0x5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(HASWELL_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_XEON_D,X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
 
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),
-- 
2.38.1.431.g37b22c650d-goog

