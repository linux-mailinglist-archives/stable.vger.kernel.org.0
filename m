Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64E963F993
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 22:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiLAVL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 16:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiLAVLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 16:11:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A08DBEE1A;
        Thu,  1 Dec 2022 13:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3451B6211F;
        Thu,  1 Dec 2022 21:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F1AC433D6;
        Thu,  1 Dec 2022 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669929113;
        bh=3nzk2Hz804l2X5kp1Ia4dfXY8pRJ0AmHiPtOm4v+ijg=;
        h=Date:To:From:Subject:From;
        b=EIo8eEp0qBwTZ9qL3rKUbThVgOB01ho/wRFhnrCT6LIJoE6ecMZ9KJGiI5gIAeyWo
         Dft0C1w+UlxtzYom0fIpUS97FZOGWOxMtB91dZXe/adLzr3cFyrwV1/JXpAk1CeseT
         kerDq+gk16LiVJDopf5iXew+BFYRrNhq4PLFl2fE=
Date:   Thu, 01 Dec 2022 13:11:52 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        revest@chromium.org, peterz@infradead.org, mhiramat@kernel.org,
        mark.rutland@arm.com, kpsingh@kernel.org, keescook@chromium.org,
        jpoimboe@redhat.com, hch@infradead.org, gregkh@linuxfoundation.org,
        bp@suse.de, alexei.starovoitov@gmail.com, rostedt@goodmis.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] error-injection-add-prompt-for-function-error-injection.patch removed from -mm tree
Message-Id: <20221201211153.89F1AC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: error-injection: add prompt for function error injection
has been removed from the -mm tree.  Its filename was
     error-injection-add-prompt-for-function-error-injection.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: error-injection: add prompt for function error injection
Date: Mon, 21 Nov 2022 10:44:03 -0500

The config to be able to inject error codes into any function annotated
with ALLOW_ERROR_INJECTION() is enabled when
CONFIG_FUNCTION_ERROR_INJECTION is enabled.  But unfortunately, this is
always enabled on x86 when KPROBES is enabled, and there's no way to turn
it off.

As kprobes is useful for observability of the kernel, it is useful to have
it enabled in production environments.  But error injection should be
avoided.  Add a prompt to the config to allow it to be disabled even when
kprobes is enabled, and get rid of the "def_bool y".

This is a kernel debug feature (it's in Kconfig.debug), and should have
never been something enabled by default.

Link: https://lkml.kernel.org/r/20221121104403.1545f9b5@gandalf.local.home
Fixes: 540adea3809f6 ("error-injection: Separate error-injection from kprobe")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Florent Revest <revest@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~error-injection-add-prompt-for-function-error-injection
+++ a/lib/Kconfig.debug
@@ -1875,8 +1875,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
_

Patches currently in -mm which might be from rostedt@goodmis.org are


