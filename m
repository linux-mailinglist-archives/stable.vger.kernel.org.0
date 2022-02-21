Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3024BE86B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348686AbiBUJXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348880AbiBUJUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:20:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFC3344F9
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 01:07:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C5E9B2113B;
        Mon, 21 Feb 2022 09:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645434459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGSLw5kklTVf/Ab7OVDL7D/0tthwjRdC425z566s1AE=;
        b=NbQSr2rH0svwAcVWCU3zlC8KLHfhj1Ma/EXW2UED+4M9d+1HK2wUAC6xCmdXC9/oMsyuZl
        CbSjarhkqsFgEYEb1whmdJX7m5slPtgP90mveB/KLpqYUtKfGk9cSqZL+SczPzKlg+C5dI
        Z4HbrMegUpJmN/GuDl8aS4dbHh4F2QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645434459;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGSLw5kklTVf/Ab7OVDL7D/0tthwjRdC425z566s1AE=;
        b=WAOMjy8tXjFMnSMuPtvqZJcDtIKXiHF+SBL+6MSqYeRJ57TrmC3jucLLg3mt0ewW21vSu5
        hEIbND5oGy2uUyCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B0D0B13A17;
        Mon, 21 Feb 2022 09:07:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NBW2KVtWE2IteAAAMHmgww
        (envelope-from <bp@suse.de>); Mon, 21 Feb 2022 09:07:39 +0000
Date:   Mon, 21 Feb 2022 10:07:47 +0100
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     luto@kernel.org, contact@lsferreira.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/ptrace: Fix xfpregs_set()'s incorrect
 xmm clearing" failed to apply to 5.15-stable tree
Message-ID: <YhNWY9Cc04ZDvvGH@zn.tnic>
References: <164542665924686@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <164542665924686@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 07:57:39AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

---
From b0535322d006c7f49e7fca3485991c5f88a5e7cb Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 14 Feb 2022 13:05:49 +0100
Subject: [PATCH] x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 44cad52cc14ae10062f142ec16ede489bccf4469 upstream.

xfpregs_set() handles 32-bit REGSET_XFP and 64-bit REGSET_FP. The actual
code treats these regsets as modern FX state (i.e. the beginning part of
XSTATE). The declarations of the regsets thought they were the legacy
i387 format. The code thought they were the 32-bit (no xmm8..15) variant
of XSTATE and, for good measure, made the high bits disappear by zeroing
the wrong part of the buffer. The latter broke ptrace, and everything
else confused anyone trying to understand the code. In particular, the
nonsense definitions of the regsets confused me when I wrote this code.

Clean this all up. Change the declarations to match reality (which
shouldn't change the generated code, let alone the ABI) and fix
xfpregs_set() to clear the correct bits and to only do so for 32-bit
callers.

Fixes: 6164331d15f7 ("x86/fpu: Rewrite xfpregs_set()")
Reported-by: Luís Ferreira <contact@lsferreira.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215524
Link: https://lore.kernel.org/r/YgpFnZpF01WwR8wU@zn.tnic
---
 arch/x86/kernel/fpu/regset.c | 9 ++++-----
 arch/x86/kernel/ptrace.c     | 4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 66ed317ebc0d..125cbbe10fef 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -87,11 +87,9 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		const void *kbuf, const void __user *ubuf)
 {
 	struct fpu *fpu = &target->thread.fpu;
-	struct user32_fxsr_struct newstate;
+	struct fxregs_state newstate;
 	int ret;
 
-	BUILD_BUG_ON(sizeof(newstate) != sizeof(struct fxregs_state));
-
 	if (!cpu_feature_enabled(X86_FEATURE_FXSR))
 		return -ENODEV;
 
@@ -112,9 +110,10 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	/* Copy the state  */
 	memcpy(&fpu->state.fxsave, &newstate, sizeof(newstate));
 
-	/* Clear xmm8..15 */
+	/* Clear xmm8..15 for 32-bit callers */
 	BUILD_BUG_ON(sizeof(fpu->state.fxsave.xmm_space) != 16 * 16);
-	memset(&fpu->state.fxsave.xmm_space[8], 0, 8 * 16);
+	if (in_ia32_syscall())
+		memset(&fpu->state.fxsave.xmm_space[8*4], 0, 8 * 16);
 
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4c208ea3bd9f..033d9c6a9468 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1224,7 +1224,7 @@ static struct user_regset x86_64_regsets[] __ro_after_init = {
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(long),
+		.n = sizeof(struct fxregs_state) / sizeof(long),
 		.size = sizeof(long), .align = sizeof(long),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},
@@ -1271,7 +1271,7 @@ static struct user_regset x86_32_regsets[] __ro_after_init = {
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
+		.n = sizeof(struct fxregs_state) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
