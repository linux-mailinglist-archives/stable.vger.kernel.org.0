Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CCF2018F4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgFSQzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387461AbgFSOgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:36:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A9F92070A;
        Fri, 19 Jun 2020 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577367;
        bh=5tm4Dg00/ubgsCOtNbBlHdNQPOrTqmqY8p/BQos8OGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqKnitEM7O65hyxmQI3wzjAwen1yElQ9VVeANrZbKiFk1mWvDKjayHzOUO1XqOkCX
         14uwxcQzn1i/yp8svXl2elaXp8GlKLBSBnSAZC9OmWNAYuXUXz4LzqCJ7p1vaue957
         NXmMpshhJMNcvIsamiCLwW8VPSRMX61zXRSbU0Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 022/101] x86/speculation: Change misspelled STIPB to STIBP
Date:   Fri, 19 Jun 2020 16:32:11 +0200
Message-Id: <20200619141615.260874344@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit aa77bfb354c495fc4361199e63fc5765b9e1e783 ]

STIBP stands for Single Thread Indirect Branch Predictors. The acronym,
however, can be easily mis-spelled as STIPB. It is perhaps due to the
presence of another related term - IBPB (Indirect Branch Predictor
Barrier).

Fix the mis-spelling in the code.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: KarimAllah Ahmed <karahmed@amazon.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1544039368-9009-1-git-send-email-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 6 +++---
 arch/x86/kernel/process.h  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1a0ab4af93b7..9fddbdcc1874 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,7 +59,7 @@ static u64 x86_spec_ctrl_mask = SPEC_CTRL_IBRS;
 u64 x86_amd_ls_cfg_base;
 u64 x86_amd_ls_cfg_ssbd_mask;
 
-/* Control conditional STIPB in switch_to() */
+/* Control conditional STIBP in switch_to() */
 DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
 /* Control conditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
@@ -725,12 +725,12 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 			"always-on" : "conditional");
 	}
 
-	/* If enhanced IBRS is enabled no STIPB required */
+	/* If enhanced IBRS is enabled no STIBP required */
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
 	/*
-	 * If SMT is not possible or STIBP is not available clear the STIPB
+	 * If SMT is not possible or STIBP is not available clear the STIBP
 	 * mode.
 	 */
 	if (!smt_possible || !boot_cpu_has(X86_FEATURE_STIBP))
diff --git a/arch/x86/kernel/process.h b/arch/x86/kernel/process.h
index 898e97cf6629..320ab978fb1f 100644
--- a/arch/x86/kernel/process.h
+++ b/arch/x86/kernel/process.h
@@ -19,7 +19,7 @@ static inline void switch_to_extra(struct task_struct *prev,
 	if (IS_ENABLED(CONFIG_SMP)) {
 		/*
 		 * Avoid __switch_to_xtra() invocation when conditional
-		 * STIPB is disabled and the only different bit is
+		 * STIBP is disabled and the only different bit is
 		 * TIF_SPEC_IB. For CONFIG_SMP=n TIF_SPEC_IB is not
 		 * in the TIF_WORK_CTXSW masks.
 		 */
-- 
2.25.1



