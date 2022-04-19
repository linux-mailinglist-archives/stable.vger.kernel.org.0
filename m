Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2E506FF7
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 16:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348035AbiDSOT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 10:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346632AbiDSOT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 10:19:56 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FDF6141;
        Tue, 19 Apr 2022 07:17:13 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:33804)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ngofH-009EtF-CA; Tue, 19 Apr 2022 08:17:11 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:34928 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ngofG-00EtRb-Eq; Tue, 19 Apr 2022 08:17:10 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kernel test robot <lkp@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20220418200834.1501454-1-Niklas.Cassel@wdc.com>
        <202204181501.D55C8D2A@keescook>
Date:   Tue, 19 Apr 2022 09:16:41 -0500
In-Reply-To: <202204181501.D55C8D2A@keescook> (Kees Cook's message of "Mon, 18
        Apr 2022 15:01:35 -0700")
Message-ID: <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1ngofG-00EtRb-Eq;;;mid=<87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19ajDTwOr+BtcmAx3CpiqLDVMt1FS+BCvY=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 373 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.1 (1.1%), b_tie_ro: 2.8 (0.8%), parse: 0.69
        (0.2%), extract_message_metadata: 8 (2.2%), get_uri_detail_list: 0.95
        (0.3%), tests_pri_-1000: 11 (2.8%), tests_pri_-950: 0.97 (0.3%),
        tests_pri_-900: 0.88 (0.2%), tests_pri_-90: 115 (30.8%), check_bayes:
        114 (30.5%), b_tokenize: 5 (1.4%), b_tok_get_all: 7 (1.8%),
        b_comp_prob: 1.41 (0.4%), b_tok_touch_all: 97 (26.1%), b_finish: 0.79
        (0.2%), tests_pri_0: 223 (59.7%), check_dkim_signature: 0.45 (0.1%),
        check_dkim_adsp: 2.3 (0.6%), poll_dns_idle: 0.81 (0.2%), tests_pri_10:
        1.83 (0.5%), tests_pri_500: 6 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] binfmt_flat; Drop vestigates of coredump support
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


There is the briefest start of coredump support in binfmt_flat.  It is
actually a pain to maintain as binfmt_flat is not built on most
architectures so it is easy to overlook.

Since the support does not do anything remove it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

Apologies for hijacking this thread but it looks like we have people who
are actively using binfmt_flat on it.

Does anyone have any objections to simply removing what little there
is of coredump support from binfmt_flat?

Eric

 fs/binfmt_flat.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 626898150011..0ad2c7bbaddd 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -37,7 +37,6 @@
 #include <linux/flat.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
-#include <linux/coredump.h>
 
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
@@ -98,33 +97,12 @@ static int load_flat_shared_library(int id, struct lib_info *p);
 #endif
 
 static int load_flat_binary(struct linux_binprm *);
-#ifdef CONFIG_COREDUMP
-static int flat_core_dump(struct coredump_params *cprm);
-#endif
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_flat_binary,
-#ifdef CONFIG_COREDUMP
-	.core_dump	= flat_core_dump,
-	.min_coredump	= PAGE_SIZE
-#endif
 };
 
-/****************************************************************************/
-/*
- * Routine writes a core dump image in the current directory.
- * Currently only a stub-function.
- */
-
-#ifdef CONFIG_COREDUMP
-static int flat_core_dump(struct coredump_params *cprm)
-{
-	pr_warn("Process %s:%d received signr %d and should have core dumped\n",
-		current->comm, current->pid, cprm->siginfo->si_signo);
-	return 1;
-}
-#endif
 
 /****************************************************************************/
 /*
-- 
2.35.3

