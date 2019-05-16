Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE09120C68
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfEPQEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42454 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbfEPP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:42 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zk-HI; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001P9-Hh; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.547613@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 35/86] x86/speculation: Clean up spectre_v2_parse_cmdline()
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 24848509aa55eac39d524b587b051f4e86df3c12 upstream.

Remove the unnecessary 'else' statement in spectre_v2_parse_cmdline()
to save an indentation level.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185003.688010903@linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -336,22 +336,21 @@ static enum spectre_v2_mitigation_cmd __
 
 	if (cmdline_find_option_bool(boot_command_line, "nospectre_v2"))
 		return SPECTRE_V2_CMD_NONE;
-	else {
-		ret = cmdline_find_option(boot_command_line, "spectre_v2", arg, sizeof(arg));
-		if (ret < 0)
-			return SPECTRE_V2_CMD_AUTO;
 
-		for (i = 0; i < ARRAY_SIZE(mitigation_options); i++) {
-			if (!match_option(arg, ret, mitigation_options[i].option))
-				continue;
-			cmd = mitigation_options[i].cmd;
-			break;
-		}
+	ret = cmdline_find_option(boot_command_line, "spectre_v2", arg, sizeof(arg));
+	if (ret < 0)
+		return SPECTRE_V2_CMD_AUTO;
 
-		if (i >= ARRAY_SIZE(mitigation_options)) {
-			pr_err("unknown option (%s). Switching to AUTO select\n", arg);
-			return SPECTRE_V2_CMD_AUTO;
-		}
+	for (i = 0; i < ARRAY_SIZE(mitigation_options); i++) {
+		if (!match_option(arg, ret, mitigation_options[i].option))
+			continue;
+		cmd = mitigation_options[i].cmd;
+		break;
+	}
+
+	if (i >= ARRAY_SIZE(mitigation_options)) {
+		pr_err("unknown option (%s). Switching to AUTO select\n", arg);
+		return SPECTRE_V2_CMD_AUTO;
 	}
 
 	if ((cmd == SPECTRE_V2_CMD_RETPOLINE ||

