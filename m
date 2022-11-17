Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1844D62D681
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiKQJWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbiKQJVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:43 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007C36D498
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:40 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-348608c1cd3so13979627b3.10
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCMmVaAZy6SEs5rn93zweygg0ZuHlWdZWdV2Qs+NB2I=;
        b=PA95jb1Ll6fyBw/RzDzda4Z3xue/ZmadTIvKZMJ7KgTQ3PiGV8A8zg/QwcyfF8KLRa
         Pq+e9DBsAbH37cRMI9qQEfThWX+SCTFQso7cuqxrAjA9dySKs1OEJstekKxrkhbNrpSg
         a9oGX/atVon6FmGWUsIbfm7r9JdA/io9jlxuHAs24Haeti655G52TUTMUUauSr5fVlap
         kNum1PpKZlxcWy98ULfjDNMWGlZJ0fY0B6HEg5H04FPgnKRM/G1b+k5e2BOgGO0QGYgp
         TaHnH9ns6kXo/3lRhOXr9V2AMLbnU2Yqcm0DPcRWvL5g9KDiYlQ3BiciLFNLFCPlRV2T
         4YPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCMmVaAZy6SEs5rn93zweygg0ZuHlWdZWdV2Qs+NB2I=;
        b=Tq3PPP2XnQCx43Upt1wavvkx6CmXcSn8Ql2UzFP2lzbcIxpl0+fUfsVE4YbKM6Rqmi
         qgCJGpoNioZJ/BeHy/N1nflJlmf6xsn6Wv2Rwq5s1uNwRwTzsxMVumOMdnLrvL2LRnrt
         mssH3sjVWl6KBnZPeBo4VAmEx5kmBl106xAVeZAGFQC5Bfzq7j6xdNTI0/FWPOq1ISLA
         E8h+/kz4u09Udxcm9o0LeLs+T53Gt495C2sIl/w8pY7Ga4xyTW/xzYflrZQe93sJe4yU
         QCVW8OpgBWpbGjrOLVX/HpLSgNSTvk53bffibZu7FFz6XSu1p4r370Pfctyjl04XHEKK
         c0bA==
X-Gm-Message-State: ANoB5pme6NRVYPJdGBqxGLmvOQz3xRCzlSnASV80ocxkxbdA9KskhIxA
        HCa3Vq1aSNQ7cSDWsGN0whcWJMcK+aMwoQMdCUJoj/qYXkdXZBbyDSqxss7lYIFjNNzCrH3Dk4q
        eglRCC6qLjiQKZJlqXmDBJlAfv8jL48L4m5jUv23361/VQM63y7iY650k/0kDSBFZ++Y=
X-Google-Smtp-Source: AA0mqf5m7zH4BQpyAvxlIMNHW6Y2RiB3F8Q+PVkhra4NKQbV65DIREaIl6T9KBIdTHQhgQ25b7poYEkvwX9mqg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:e043:0:b0:6dd:26c3:9fbd with SMTP id
 x64-20020a25e043000000b006dd26c39fbdmr1166819ybg.589.1668676899629; Thu, 17
 Nov 2022 01:21:39 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:39 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-22-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 21/34] x86/speculation: Fix firmware entry SPEC_CTRL handling
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit e6aa13622ea8283cc699cac5d018cc40a2ba2010 upstream.

The firmware entry code may accidentally clear STIBP or SSBD. Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/nospec-branch.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ca6e421a3467..c990c3b2ada5 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -317,18 +317,16 @@ extern u64 spec_ctrl_current(void);
  */
 #define firmware_restrict_branch_speculation_start()			\
 do {									\
-	u64 val = x86_spec_ctrl_base | SPEC_CTRL_IBRS;			\
-									\
 	preempt_disable();						\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
 			      X86_FEATURE_USE_IBRS_FW);			\
 } while (0)
 
 #define firmware_restrict_branch_speculation_end()			\
 do {									\
-	u64 val = x86_spec_ctrl_base;					\
-									\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current(),			\
 			      X86_FEATURE_USE_IBRS_FW);			\
 	preempt_enable();						\
 } while (0)
-- 
2.38.1.431.g37b22c650d-goog

