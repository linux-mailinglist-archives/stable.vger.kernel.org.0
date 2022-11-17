Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5F862D68B
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbiKQJW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbiKQJWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:07 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A7A6D499
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:04 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3697bd55974so13601947b3.15
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BSw+fPg08vFflFZPyJ6dbW0D7kI9gGa+W00dWdDf7Rs=;
        b=om3LyeYegaRHbsPyzgKa3xy5uEiSEbmnRixu1a90EA8aufBCtRLrtRe7rCeJ/45t9G
         s5e1EydPMzVnoqpnakX0NtQ+1j+nF7IUw0R0bhTucKIISr63wKF9mkPvRK1konLb6QK8
         IQ4EMf4IGWMYIN0EETGkMkOLAJaHhuG4ZSX8jhZVQAgMZkBmpeAIXKC10rcD9zFhe+r1
         ws/f6G00V8qaPQVJV9BrzymcV7ZGW9wj/kM5z7hvYgbGt/5cRnuwCxI0dGuHGIvKDqMl
         GUFT3Yrj5moMyuihegK4EXGdLF1xgtllg7uFkhX4QwaxCHazvGRCOCts6LewAJtP4BRO
         4YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BSw+fPg08vFflFZPyJ6dbW0D7kI9gGa+W00dWdDf7Rs=;
        b=Cwc7UXhCTWkglOLqIsEBCkRnVy7ZeWrbOrxbRzm7gyAwUjY43X1CneEhGc0JoyG7LV
         N+eo6JVA4/pAt2t3UDS1bz4cgq71t1DvZ2MjXUCYft1ox9j5LP/vd9qIHdWHI6e9t3hv
         uBy5SQ583So76/bLiBfGC2mjApOIiHoeuOCZ+QuWGErl+j9v0OYfhQXi6fH3rMRjTpLv
         GdgGNPVlCx7SuT3xS7HCx0G7f6trMHnPOrSRfnOBpxKn6mkbdvVHcYv8sWxpI6ZYkfWG
         NfvlvGpg82HODgMsFTd1z7vNiZdzR9NhmAP3QIq/a8Sm7udY72nCNxiGxZ507JP3V33e
         KmXw==
X-Gm-Message-State: ANoB5pmJQkFdsqQk29iqUyfEiUFPPae7tGiEWrmOax+1e3f5Qd9AJQa0
        kYwJv6flbhDeNqREZJJWCj4eh69IOu2pdujd2HPxiVcQktxTaTljyoz+jgQ1HEH+cirSl7FLbGv
        Fhve+qJDBsQAolkRPc6YpX1VafsJ25Z4KSkimpfv2HcZdwjG/MnNCkYypOkDc9XGD4Kw=
X-Google-Smtp-Source: AA0mqf66OunEGUBkUbMDknC3oOAjqIlWwv0Up1lu2f3FofkeYTYdFiP0tu5/XaYjvHNcBVypApUK8O+wJTcfJA==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:8e82:0:b0:6d2:70d5:3ed0 with SMTP id
 q2-20020a258e82000000b006d270d53ed0mr1343956ybl.457.1668676924110; Thu, 17
 Nov 2022 01:22:04 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:44 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-27-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 26/34] KVM: VMX: Fix IBRS handling after vmexit
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit bea7e31a5caccb6fe8ed989c065072354f0ecb52 upstream.

For legacy IBRS to work, the IBRS bit needs to be always re-written
after vmexit, even if it's already on.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kvm/vmx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 951cec231e7f..babb1e5a4dfa 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10770,9 +10770,13 @@ u64 __always_inline vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx)
 	guestval = __rdmsr(MSR_IA32_SPEC_CTRL);
 
 	/*
-	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 *
+	 * For legacy IBRS, the IBRS bit always needs to be written after
+	 * transitioning from a less privileged predictor mode, regardless of
+	 * whether the guest/host values differ.
 	 */
-	if (guestval != hostval)
+	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	    guestval != hostval)
 		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
 
 	barrier_nospec();
-- 
2.38.1.431.g37b22c650d-goog

