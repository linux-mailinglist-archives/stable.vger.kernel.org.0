Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897C538714D
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 07:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbhERFfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 01:35:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57608 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241075AbhERFfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 01:35:15 -0400
Date:   Tue, 18 May 2021 05:33:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621316037;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Vgyf6pxuLbrg1oLU7uMIJdudAVT35uEWaecCw5XJgk=;
        b=bjR5mjELcxVzhmPEQw2w+moYG0W4faf9YlBW9yE75xy+NoC+LG+mSQKAx1Qty3TGlMDSFY
        tH/s95SGD5JW65Qgtb+Ie4jl8fnoBnsrKSmJ0Toj3ftXLYUjBCznXQ0xaePH078nbxmbYx
        5dcP/lo4u3O3MR9sFYob9XTygesSqMsgiSsapQ4moh9/BvAL3/nxEigqujrc6jPkaNDljq
        oCBeygIS1JxmIGMUF6Kw1RfLpJ3vD6h3YiPQXJATbxyyOzgYiL3mUaKpb6WvHnbCrsqck9
        DJj/NdsT9YCef7IwY+OEy8pJtxq/KiX4T6eXVR9jNDo6R6ro2BmYbUQVcpg5qA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621316037;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Vgyf6pxuLbrg1oLU7uMIJdudAVT35uEWaecCw5XJgk=;
        b=SAtokJxr1X2GgaVbNEv//yGdFSfSotfmmFAEMMUtzHu8z6Tw1Ye/XCbDi4/yew7pOSZFk1
        nNOyPlEAtizvIoDg==
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Move sev_es_put_ghcb() in prep for
 follow on patch
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C8c07662ec17d3d82e5c53841a1d9e766d3bdbab6=2E16212?=
 =?utf-8?q?73353=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
References: =?utf-8?q?=3C8c07662ec17d3d82e5c53841a1d9e766d3bdbab6=2E162127?=
 =?utf-8?q?3353=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <162131603647.29796.8676166317810740262.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     fea63d54f7a3e74f8ab489a8b82413a29849a594
Gitweb:        https://git.kernel.org/tip/fea63d54f7a3e74f8ab489a8b82413a29849a594
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Mon, 17 May 2021 12:42:32 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 18 May 2021 06:49:37 +02:00

x86/sev-es: Move sev_es_put_ghcb() in prep for follow on patch

Move the location of sev_es_put_ghcb() in preparation for an update to it
in a follow-on patch. This will better highlight the changes being made
to the function.

No functional change.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/8c07662ec17d3d82e5c53841a1d9e766d3bdbab6.1621273353.git.thomas.lendacky@amd.com
---
 arch/x86/kernel/sev.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9578c82..45e2126 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -221,24 +221,6 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	return ghcb;
 }
 
-static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
-{
-	struct sev_es_runtime_data *data;
-	struct ghcb *ghcb;
-
-	data = this_cpu_read(runtime_data);
-	ghcb = &data->ghcb_page;
-
-	if (state->ghcb) {
-		/* Restore GHCB from Backup */
-		*ghcb = *state->ghcb;
-		data->backup_ghcb_active = false;
-		state->ghcb = NULL;
-	} else {
-		data->ghcb_active = false;
-	}
-}
-
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
@@ -461,6 +443,24 @@ static enum es_result vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt 
 /* Include code shared with pre-decompression boot stage */
 #include "sev-shared.c"
 
+static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+{
+	struct sev_es_runtime_data *data;
+	struct ghcb *ghcb;
+
+	data = this_cpu_read(runtime_data);
+	ghcb = &data->ghcb_page;
+
+	if (state->ghcb) {
+		/* Restore GHCB from Backup */
+		*ghcb = *state->ghcb;
+		data->backup_ghcb_active = false;
+		state->ghcb = NULL;
+	} else {
+		data->ghcb_active = false;
+	}
+}
+
 void noinstr __sev_es_nmi_complete(void)
 {
 	struct ghcb_state state;
