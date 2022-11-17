Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B285562D666
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiKQJUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239855AbiKQJUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:20:38 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7876A697E9
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:37 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id e8-20020a5b0cc8000000b006bca0fa3ab6so1061889ybr.0
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3XSLXpnm3peAFX4SkwU1UTCaP2K+GcdXoBa9S6a9Ow=;
        b=FHLU4BxNR15V2FFqCHwNZrtWlCNq5IUnX5r59jpp8mPp5soARo8eN8xT06yKj7mbqY
         bXU8ReuV+2p6K9vj0+/+lNwLT4VQ7pkiRHLCwDXUVQt5V8OeGgIJA/pry/bDZIHPux+u
         Tk+bdi4+IRlXl6wO5Ccw0k23JX2C/Gx0IswXoUQ157YcswRC/+Yy6X8eMLAfHGZHy3oV
         JH0p09BPDmFr2PhhrEpBUoO1CZfLyiQxMV6SgcFeVITS9ZcLvpM3DdQKK/8j3lhS91kr
         pRP56rn8ixKHovfcVea+mp7zZLbOky4rTtIYettmOjLu/QdeUeTpIA4mMc5pAmhiV5B7
         myIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3XSLXpnm3peAFX4SkwU1UTCaP2K+GcdXoBa9S6a9Ow=;
        b=YjEFIs0k/aWGVRDk4JfTWVVHfzzFh/2ZSDBdzyWb0rxa/FG0dVc01XizbG+UKuKoEk
         lJ+FT4k0tCTAolcdrPy0pmdh7jaRYhU1vIbGH5c9LfKJfks9mSFmuW0s0CdUEOX/vUhX
         d14cIzLG90+LqH/UWhYOgBesapkbT3fY2xzI6wloJhD3dv97c969j8P4G0m2l0I0cuX4
         RMVxc8Vea/qeZqOAI36JYHQFm7YC4KTtWv2SAbkTJCP9gG3wd60F0J8xAomDQfjvwgjz
         FuEYU0kz6RlIAFw91CD2tm5uOyPl2/SzgypjKUblOza2Le9+lxxD7nMdzWC1j+Yg6iqz
         tw4Q==
X-Gm-Message-State: ANoB5pmKC3/inmYZyrKng32bqWW9J+mQQMviQ+bKrIraMTqvwL3KWvoP
        zm/mcuXeJVTaQ10KVFI3JtdN5KU5/hqMud4kki194m5tvwwra39SALCt2bwCUZPv9WEUDbIvBDw
        CzhUF3AVoH4CgOoqP9+3Or7yBV1dWCuQOBdPIm8ZUFFYt8rlGt7+LlFnJUCqEQ5EfaU4=
X-Google-Smtp-Source: AA0mqf5ckQZecqK6pWG33qQEqpQJoKDwhNldxu3flsQk3muMzt+s/Dr3dSpeKeJSiFoTMXhC3lvyta4PKXW+6w==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a81:1045:0:b0:35d:7f88:12f9 with SMTP id
 66-20020a811045000000b0035d7f8812f9mr1134609ywq.471.1668676836745; Thu, 17
 Nov 2022 01:20:36 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:26 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-9-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 08/34] x86/cpufeatures: Move RETPOLINE flags to word 11
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a883d624aed463c84c22596006e5a96f5b44db31 upstream.

In order to extend the RETPOLINE features to 4, move them to word 11
where there is still room. This mostly keeps DISABLE_RETPOLINE
simple.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 3a270a2da5b4..84b75711b0a5 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -202,8 +202,8 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-#define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
+/* FREE!				( 7*32+12) */
+/* FREE!				( 7*32+13) */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
@@ -283,6 +283,14 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
+/* FREE!				(11*32+ 6) */
+/* FREE!				(11*32+ 7) */
+/* FREE!				(11*32+ 8) */
+/* FREE!				(11*32+ 9) */
+/* FREE!				(11*32+10) */
+/* FREE!				(11*32+11) */
+#define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
-- 
2.38.1.431.g37b22c650d-goog

