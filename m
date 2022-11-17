Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D4C62D69D
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbiKQJXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239915AbiKQJWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:54 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5622874AB3
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:40 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so954500pjm.0
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GrrZGiotVhRjWWirtVvn7p8LmDKLbrClix/SOg5WUhU=;
        b=oKYBD52w73jt/aZKMMaztodItBHZbvVHV26NKZW/NPOvBFIyEqrsligt5KXOA88E0T
         nFgde70JIPJWcTEFnkg3xhCUJdubHIzKKtOgu5sJAAjqXFVI9q6EmFJOTn9IIt1y4KEN
         2rY6HDGVq87y0Uud7n45gpuOX8sqqmYfvoZqOR+unm/cxhGQoZ83vVDfvvQqHeWMDCc9
         S4lxqnMzN6+BCWem9PO2pTCoe7e8/UMVlNJzs4YWg/wnkn3Wo63U6SEGF7tCqG0NIwdA
         Qv5jyCxpNlbbUaL9qenGbDNdQd4EXcDFBPZTNSzQ2VlYfPGUkf+Q3tFUosPd93Mxwpab
         TmGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GrrZGiotVhRjWWirtVvn7p8LmDKLbrClix/SOg5WUhU=;
        b=3VDJustLdgBuy0Yd6E9MaVSULyc6WjLnnYnTobRizJhy2sw/CVeM5gyErIkQ6X8PIv
         Rl6E7A7JH3IVisfskaXReTJEeGLWmBujhPTjLDyppeC/XQgLCZtWWrgBKgkpdn0c7zyA
         eBK9O6d60ZnflHqmnvyfOvGSnp1zHYSeq4odx/pPTg+9XjDiJYjzzgV4QSTC6Uh1RAlt
         JPUf98LnMQMGHHl0Sr1PwH428gljneJp2J/WMsOSRXAv0zQxaQNgDwRRJ57vPcsabhfT
         UzSP0zbI/4YPJg/88ZHGJjPAhihigBZEUk8c5DlgGzhwnswX3DHTSnbM2cVzwfCa0Cgt
         KpDw==
X-Gm-Message-State: ANoB5pnN+nOnHSdtG8uYyVdVNaIcCBtK/qL0l1bHGeKDBDoRajGcflgY
        AoAgnUnoSXP4jY0qcJzhWH2XLPMkN01zF2FATtAizOrlgpQFg5XWKZykQ1XpUp5UOmAcGu2SlaS
        slxXZyb60nCQo5RmAL5G3lSqVCzf3BUa5BhrMNIIeQSUkUwtIFt7tDv/uKh5rA8HGbOg=
X-Google-Smtp-Source: AA0mqf4eJqZEhhyx9/1+9o14sI0kBot/eKEAexUgxu3Hobf/XrH2MHfa0u3QbvDUy0xTSvyE6ieNOEDOneV/ng==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:902:6b08:b0:187:4467:7aba with SMTP
 id o8-20020a1709026b0800b0018744677abamr1928482plk.61.1668676959451; Thu, 17
 Nov 2022 01:22:39 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:51 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-34-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 33/34] x86/bugs: Warn when "ibrs" mitigation is selected
 on Enhanced IBRS parts
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit eb23b5ef9131e6d65011de349a4d25ef1b3d4314 upstream.

IBRS mitigation for spectre_v2 forces write to MSR_IA32_SPEC_CTRL at
every kernel entry/exit. On Enhanced IBRS parts setting
MSR_IA32_SPEC_CTRL[IBRS] only once at boot is sufficient. MSR writes at
every kernel entry/exit incur unnecessary performance loss.

When Enhanced IBRS feature is present, print a warning about this
unnecessary performance loss.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a4684b224b59..351551fdd198 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -851,6 +851,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
@@ -1277,6 +1278,8 @@ static void __init spectre_v2_select_mitigation(void)
 
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
 		break;
 
 	case SPECTRE_V2_LFENCE:
-- 
2.38.1.431.g37b22c650d-goog

