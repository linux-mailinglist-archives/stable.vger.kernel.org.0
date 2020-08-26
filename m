Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A82537C7
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 21:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHZTDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHZTDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 15:03:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2ADC061574;
        Wed, 26 Aug 2020 12:03:00 -0700 (PDT)
Date:   Wed, 26 Aug 2020 19:02:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598468578;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJrpPCcKjLqXf0wZytcbv1zXOaX1uadoyDCrO/SFY7s=;
        b=EVNqWmfYyP1DpYc8OYUX3Nn+5GF65B4vOmk3SOtTZIkfnClQZCdDErOz1E6lVFtdSPt3/y
        mhORedqVLTIeGUWAYUMxi/nZp75xYSWUycmc3DZgeK0rLFpkjxZ+aPEytFmGr5zsNiuYbs
        oL/8LPg2uSemZXQloZZ+RBVTZAYqSd7gFIa1cYVy2j94qM9Q1jivgXojuXpf61Ik1jtEbk
        eTkVqKi/pS4zzmzxT9dXPhCGoXnRrU/f+b4zEUKajUol7txjlmIfRjRxZ0LvXKqxAORO4n
        BvIzcr6xm0e9bdPt+XHImeeqAR5lowDU0Hti5FhK83VX0FzoFrS7oE76eNUV9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598468578;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJrpPCcKjLqXf0wZytcbv1zXOaX1uadoyDCrO/SFY7s=;
        b=EzDtDF0/AQsKODFiw32RLnCa6D1VN8prUgwkjl8nI620ELnxnk5GXzLDabg/I8HeKroVKc
        N0RxL6wAhJBF4dCg==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fsgsbase] selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for
 GSBASE with invalid LDT GS
Cc:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <c618ae86d1f757e01b1a8e79869f553cb88acf9a.1598461151.git.luto@kernel.org>
References: <c618ae86d1f757e01b1a8e79869f553cb88acf9a.1598461151.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <159846857768.389.6578227698972431779.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/fsgsbase branch of tip:

Commit-ID:     1b9abd1755ad947d7c9913e92e7837b533124c90
Gitweb:        https://git.kernel.org/tip/1b9abd1755ad947d7c9913e92e7837b533124c90
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Wed, 26 Aug 2020 10:00:46 -07:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 26 Aug 2020 20:54:18 +02:00

selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS

This tests commit:

  8ab49526b53d ("x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task")

Unpatched kernels will OOPS.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/c618ae86d1f757e01b1a8e79869f553cb88acf9a.1598461151.git.luto@kernel.org
---
 tools/testing/selftests/x86/fsgsbase.c | 65 +++++++++++++++++++++++++-
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/x86/fsgsbase.c b/tools/testing/selftests/x86/fsgsbase.c
index 0056e25..7161cfc 100644
--- a/tools/testing/selftests/x86/fsgsbase.c
+++ b/tools/testing/selftests/x86/fsgsbase.c
@@ -443,6 +443,68 @@ static void test_unexpected_base(void)
 
 #define USER_REGS_OFFSET(r) offsetof(struct user_regs_struct, r)
 
+static void test_ptrace_write_gs_read_base(void)
+{
+	int status;
+	pid_t child = fork();
+
+	if (child < 0)
+		err(1, "fork");
+
+	if (child == 0) {
+		printf("[RUN]\tPTRACE_POKE GS, read GSBASE back\n");
+
+		printf("[RUN]\tARCH_SET_GS to 1\n");
+		if (syscall(SYS_arch_prctl, ARCH_SET_GS, 1) != 0)
+			err(1, "ARCH_SET_GS");
+
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != 0)
+			err(1, "PTRACE_TRACEME");
+
+		raise(SIGTRAP);
+		_exit(0);
+	}
+
+	wait(&status);
+
+	if (WSTOPSIG(status) == SIGTRAP) {
+		unsigned long base;
+		unsigned long gs_offset = USER_REGS_OFFSET(gs);
+		unsigned long base_offset = USER_REGS_OFFSET(gs_base);
+
+		/* Read the initial base.  It should be 1. */
+		base = ptrace(PTRACE_PEEKUSER, child, base_offset, NULL);
+		if (base == 1) {
+			printf("[OK]\tGSBASE started at 1\n");
+		} else {
+			nerrs++;
+			printf("[FAIL]\tGSBASE started at 0x%lx\n", base);
+		}
+
+		printf("[RUN]\tSet GS = 0x7, read GSBASE\n");
+
+		/* Poke an LDT selector into GS. */
+		if (ptrace(PTRACE_POKEUSER, child, gs_offset, 0x7) != 0)
+			err(1, "PTRACE_POKEUSER");
+
+		/* And read the base. */
+		base = ptrace(PTRACE_PEEKUSER, child, base_offset, NULL);
+
+		if (base == 0 || base == 1) {
+			printf("[OK]\tGSBASE reads as 0x%lx with invalid GS\n", base);
+		} else {
+			nerrs++;
+			printf("[FAIL]\tGSBASE=0x%lx (should be 0 or 1)\n", base);
+		}
+	}
+
+	ptrace(PTRACE_CONT, child, NULL, NULL);
+
+	wait(&status);
+	if (!WIFEXITED(status))
+		printf("[WARN]\tChild didn't exit cleanly.\n");
+}
+
 static void test_ptrace_write_gsbase(void)
 {
 	int status;
@@ -529,6 +591,9 @@ int main()
 	shared_scratch = mmap(NULL, 4096, PROT_READ | PROT_WRITE,
 			      MAP_ANONYMOUS | MAP_SHARED, -1, 0);
 
+	/* Do these tests before we have an LDT. */
+	test_ptrace_write_gs_read_base();
+
 	/* Probe FSGSBASE */
 	sethandler(SIGILL, sigill, 0);
 	if (sigsetjmp(jmpbuf, 1) == 0) {
