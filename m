Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6962D683
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbiKQJWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbiKQJVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:50 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB5697FD
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:45 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368e6c449f2so14005397b3.5
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZu1L6aeNZHO+yUsZiZqCDyduTaPbwNJn2PXrr8Ee2g=;
        b=EKyOSgVSRsZSS3rxYo9VEj9jrPmeIBUeeducxdzJPD1QdTr6BVNaM42Bb0b1gXW7Sc
         O0and3SGj2h9vKSohF/6NFaICsiRowwiq+dLZrnWBJ8wxoJPMp9AcpAjHihomOkGLjat
         lWUd4qthe90FCRZjC4TBfuELNMbbFuRi1M+vFPGJwlqc/HlcZXCkrHkdVYgQYSxQyCx0
         nZQ6CzGH8OBf8qDiaHeS0tmqGca92ppqi3hcmEIUX9HMnr4W9lGOoRBchp+duCAswmbN
         BafJJwpoNHdcgLX3U4PjKk4xrqjKPzKoX7CDvtu1XPJwCoUCzVQLT1RgMVi3IKU55Ez/
         s8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZu1L6aeNZHO+yUsZiZqCDyduTaPbwNJn2PXrr8Ee2g=;
        b=Ex9/qKGb+ZDa+rNcpU0jH7z03y7PSLU7cItaNtKGu7zLIGd3faWmHwR+0b7UFaq4YG
         5by7bOr7nzLJLcdFWalFigKmwu4jcWd13cwjEwp5gYYHso8bhrCvEzktqYmS34/iaJYz
         muzV3HopzGwV+D5LuNRPeuMa8GeaJGvyea+cTBNiokmzpxPRq+h3R0Wu+gQvsJI2dCM/
         J6Zy+wfZ0EVpTg22RlfRIel5qr4I691ybT7UOt2J/z0BCB3zE5YZcEz99Qw7hkbuh5ss
         vjlaaPjyHyNNVP4gfuEq5xUSl+Gy2tZ3fXYFVzd2DJQdabz2FLrME3wTebL0eitRTH0O
         RaUw==
X-Gm-Message-State: ANoB5pmHfqyTmIquebDSVZnPKypjJwXGkFctW681qBnUn+uGrPJ145g2
        dkTfpvm8puMFjpMVKO9wIy53ti/OByityDu4DXrC+Tnb90/O5SBDk7oErNK/uvlye7mHaP3BAO9
        59oUoEeEXek1V1wlriwBwctbzCSZ2u7b7SNx9wUeFEz9VhVVNgEovdYDInstu5M1zWEM=
X-Google-Smtp-Source: AA0mqf57MkjOGcj0/5BQEReTka6kyBlsCiDfHCcKTL+Ma4e6pqERrzWn3R2nCPbtW1nTqBYu+Fe15Kg3U0PDGQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:ef4d:0:b0:6dd:ebd8:6204 with SMTP id
 w13-20020a25ef4d000000b006ddebd86204mr1337937ybm.471.1668676904345; Thu, 17
 Nov 2022 01:21:44 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:40 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-23-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 22/34] x86/speculation: Fix SPEC_CTRL write on SMT state change
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

commit 56aa4d221f1ee2c3a49b45b800778ec6e0ab73c5 upstream.

If the SMT state changes, SSBD might get accidentally disabled.  Fix
that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0734f35d1af1..e720dee4d30b 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1335,7 +1335,8 @@ static void __init spectre_v2_select_mitigation(void)
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
+	write_spec_ctrl_current(val, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
-- 
2.38.1.431.g37b22c650d-goog

