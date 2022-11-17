Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7562D69B
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbiKQJXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbiKQJWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ED06E546
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:35 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so883333pfw.4
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7nJ/CGBviLTY2XkbaT91R+gC+cKpJE5wr1H+ewmMtI=;
        b=jjw/D7dWPdpOQNFeB0YRspYp2WhMX1I2hBYrZ3wzRp5Yw9u/Dal9C6S2QuCpW0G4+2
         I+Z3WBdAvBOMylyld4qd4AdjSZVVnTVWPvR/8uaOfXK65lqFE+YY0W/abgy1ikn7F2QV
         kz6vy5oIrJPFvwhrmRYUCf+yzRzmEb5/ud22R3RRDJROs5Qzgrffj5DgnPtaGetQatvH
         rnax6CcD57rbZnM3Fgu3mwVGn2l4NaYce7HmRAuPmb1J1JZ0laKeUUoMtu7bg6rVIaYI
         +yazmpZdsCPB9f8yKNSPQdXf9dUgp6vrDUEAJrvr1ostKXoCZYT4AV/MY/5jMLcJ/Bhy
         GTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7nJ/CGBviLTY2XkbaT91R+gC+cKpJE5wr1H+ewmMtI=;
        b=dczeoEuLBEFag8jZ4AKJVjAZ35Jbc39Qql+l+/2OvOf2lFYv74YzPGwivkuMVMXDPw
         mwf5zcKVmK4rQzekH/abSlgPYdXI1slivG+V8MQge1euBk7oU26rDi8PlwuJCdwQd0Rw
         0HUsHbF7S9V8c9cbouL7UOjEsYwHLVyUSi07NuL+kF8Ah9DBzljztbyYRwsLfuYlzcWa
         gZ2HqV72gBKwkFra7YJy2JoaS/PnrbG0cNDKHra0jdAiXfjVy6KmgV+YndbLDLNW6Nya
         ZS8jyn4Vf/8WdiuK75ePTSzyXuZeue7WqukxlEesjTyqlQMUbvC1AMWobgOQ/Wva/hZo
         gHaA==
X-Gm-Message-State: ANoB5pnmU6XlhVpHgmEBvPifNBjAx0cK5uZwNVxZfbavNl2wUEtu+26n
        n2lnDOtFKA8tfQ/Q73xp2swzhHOxLBvFlw+1g4U0iq6d3kXgI3asKYVKFPiq/HkaYzdW8wUfcy7
        iuMzauSsaq4qM4v6gZLuJbSK1nciCFzXtmM0oA5bnhh62rFApH0pbzXNUjPUzRwZ+ADw=
X-Google-Smtp-Source: AA0mqf7LfAUkn40Nu2yWuUBz9TosZP6VbwA4kovh53NIqzI7jvZV/oP8LxE9diGuZM631fQkktaRXboNieZkuw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:90a:a392:b0:20a:fee1:8f69 with SMTP
 id x18-20020a17090aa39200b0020afee18f69mr809653pjp.0.1668676954384; Thu, 17
 Nov 2022 01:22:34 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:50 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-33-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 32/34] x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current
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

From: Nathan Chancellor <nathan@kernel.org>

commit db886979683a8360ced9b24ab1125ad0c4d2cf76 upstream.

Clang warns:

  arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
  DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
                      ^
  arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
  extern u64 x86_spec_ctrl_current;
             ^
  1 error generated.

The declaration should be using DECLARE_PER_CPU instead so all
attributes stay in sync.

Cc: stable@vger.kernel.org
Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/nospec-branch.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8bce4004aab2..0a34d5dd4364 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -11,6 +11,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
 #include <asm/unwind_hints.h>
+#include <asm/percpu.h>
 
 /*
  * Fill the CPU return stack buffer.
@@ -306,7 +307,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern u64 x86_spec_ctrl_current;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
-- 
2.38.1.431.g37b22c650d-goog

