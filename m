Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365BA62D677
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiKQJVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbiKQJVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56216D497
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:16 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q194-20020a632acb000000b00476fda6a1d2so954551pgq.15
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ygd3x28fhLaQoy+hQzDFfVXpwvkJRrIT6IwCTbiF71U=;
        b=MAgAAM0mC8Guc/afZa5ZkLh4BfN+1kZLuY20hFAvGzebIro6IA/DxT7bLb18pbTOZf
         s73nZU88vvCwYF16N+tGpSzkGVSa6f+KJ98vErRe22m217AcMdGkeIGCmBsN5vXuM3zT
         UV+gs6KksmtDhNPN99VnbhqzloAtudo/sOM/0u8rxVdNw9oNcoG/k4pIUo0N/uLWOYB3
         S0DVJFzmkMLeDMdgCDvJwQV+dEjZSWiQQBnA3dqHaiX08ybk+lbJXYWOsn5q2JwL5M71
         MZ/q0RPSWrgvCIuqgbz24kVLte0gr9KAMxRb09bJ1VKohrlusJkv6KScv/D3e3AeZIgT
         NKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ygd3x28fhLaQoy+hQzDFfVXpwvkJRrIT6IwCTbiF71U=;
        b=4Wrs0ugsGj/T6RuaSNuxp7/K2V43olzUM3k7IrqaiRriLcrHe2FHiriGchgovmagTb
         xiLg2Ge8PEV3qXBIH1xBm27WWxq+ut9gbrvz7JjTQlKYQXwnlPoqk1OIkBwJW3irbqwH
         7sCjHSrVDjQpMcHxzvXoc2yBysFI6VGJR++7Cz1Qp6MQOKd+lLzN3uxP/PFDMlo1EHKX
         M8GyhF8Ai1ob0l6SA9V+XoLpSqwuqyqYVUGt3TJxoaPkvSecYz3SLm8lNG8esQH3kS6y
         s24J9qKx9xThO5KGQnKVJsE27UJLORNMXJksZUSevnlycdMiuX34HAZ2g9vndUXFT/F7
         mXZw==
X-Gm-Message-State: ANoB5plWCIwDl9qw58tEcu678MtHJyoc35kFDq6CE4ywzJUkQ2aO/WeV
        Ka8fvHd4slnk7tmkEDeyquL6zXwikspi+Rjucw8TePcIrMxfwc2k/igFSmQTKxKXplbCFQ+/ybl
        9wFWEMRt4JNX7v8myiV8I+WXm/z7aXzAJj8hMopauwO0O+y6nH2yFeLEDZRsEMWubzgg=
X-Google-Smtp-Source: AA0mqf4Kkc4BwUhM29fM2vyWrxdk9+adj3x7W0YDPHVG5Yzdzui2IPCTQU1g4BeB40uF9PZOxApjpFX+NdX6bw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a62:d441:0:b0:53e:6210:96de with SMTP id
 u1-20020a62d441000000b0053e621096demr2087825pfl.58.1668676876163; Thu, 17 Nov
 2022 01:21:16 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:34 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-17-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 16/34] x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
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

commit 166115c08a9b0b846b783088808a27d739be6e8d upstream.

retbleed will depend on spectre_v2, while spectre_v2_user depends on
retbleed. Break this cycle.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 034f0eebb5a2..ba60b61f0ee1 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -36,8 +36,9 @@
 #include "cpu.h"
 
 static void __init spectre_v1_select_mitigation(void);
-static void __init retbleed_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
+static void __init spectre_v2_user_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
@@ -136,13 +137,19 @@ void __init check_bugs(void)
 
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
+	spectre_v2_select_mitigation();
+	/*
+	 * retbleed_select_mitigation() relies on the state set by
+	 * spectre_v2_select_mitigation(); specifically it wants to know about
+	 * spectre_v2=ibrs.
+	 */
 	retbleed_select_mitigation();
 	/*
-	 * spectre_v2_select_mitigation() relies on the state set by
+	 * spectre_v2_user_select_mitigation() relies on the state set by
 	 * retbleed_select_mitigation(); specifically the STIBP selection is
 	 * forced for UNRET.
 	 */
-	spectre_v2_select_mitigation();
+	spectre_v2_user_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
 	md_clear_select_mitigation();
@@ -918,13 +925,15 @@ static void __init spec_v2_user_print_cond(const char *reason, bool secure)
 		pr_info("spectre_v2_user=%s forced on command line.\n", reason);
 }
 
+static __ro_after_init enum spectre_v2_mitigation_cmd spectre_v2_cmd;
+
 static enum spectre_v2_user_cmd __init
-spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_parse_user_cmdline(void)
 {
 	char arg[20];
 	int ret, i;
 
-	switch (v2_cmd) {
+	switch (spectre_v2_cmd) {
 	case SPECTRE_V2_CMD_NONE:
 		return SPECTRE_V2_USER_CMD_NONE;
 	case SPECTRE_V2_CMD_FORCE:
@@ -959,7 +968,7 @@ static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 }
 
 static void __init
-spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_user_select_mitigation(void)
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
@@ -972,7 +981,7 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
 		smt_possible = false;
 
-	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	cmd = spectre_v2_parse_user_cmdline();
 	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
@@ -1289,7 +1298,7 @@ static void __init spectre_v2_select_mitigation(void)
 	}
 
 	/* Set up IBPB and STIBP depending on the general spectre V2 command */
-	spectre_v2_user_select_mitigation(cmd);
+	spectre_v2_cmd = cmd;
 }
 
 static void update_stibp_msr(void * __unused)
-- 
2.38.1.431.g37b22c650d-goog

