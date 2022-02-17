Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595BD4BAA8C
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 21:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245633AbiBQUDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 15:03:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242479AbiBQUDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 15:03:37 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E5144764
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 12:03:22 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id e3so10965569wra.0
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 12:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EoUxLbnb2sQf/gQ3qMC5tsW6ZTW6qRN6SCr3Xts7WjY=;
        b=eUQxPNGvr59eb4vc0k+ux+sRS0BIvlMzahSvwbYHxnM1e+oHrwj0KrC+V5sTrsjvki
         7jZ1FTH60ycG/SiKxeb8L0/Xvn2Ta7ovZV0I9zBTnVSS/LGcZA9JggJoskJAvzH2wJ/k
         WLYsCtMrb4AYqMJw2vuugG3Rzd51NkgpabOK3Kn3PMIp8uR0Rrxem3fFzxEPhsGd1eja
         N5Iqu2Jw+EScMKT0OB1CKEgjoNmbzx8zIkkW2jwzdroybXW25hArnpmYTaLSlkb9SBU8
         xO2fjm7EDEMWsuJ5DJ56BqWXGYU4DVc7A1OXtfrEMDYi6D9MZ6WOaMAFrtkd2YT0JOZ8
         lJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EoUxLbnb2sQf/gQ3qMC5tsW6ZTW6qRN6SCr3Xts7WjY=;
        b=BXYVGC6YdnTN3HJGA1n4ftBCkz4nuX9BbHmjneSwMrWrlzFoeQuQIKSiSoSkX4l1fC
         ZVp3vqUPOEWh94PbiLZttrkCdaBhvOnV6zvegO9+dbEn26z/of7YldBQPN0JaiC1xZaW
         GJ06zn58xZVfuoNhtT40CPAtRkRhDjnwMrFA7dcntPjo+hy78BYWEVsDP6wB3aexxv2h
         46SpgEcg+oQlZ3QkZJ6vqsRMRGKIwlu+TDzjWU0T48QN7jKaosuJspqmufeaMVmx80gm
         Ks8nznEtNpQbmfC3+CtxhoYeu1cq0drvta+n1FF7sHhPF1SD/6XAZ4KK630el+jPIcOx
         xtCw==
X-Gm-Message-State: AOAM53164lTR1OjpkddES6837FwsCIzKLT2T2yvwAUrEgoI3IlsH0yrK
        m4gbQckPfgGpAbZV1q2oV0HOaNq1KGTgbw==
X-Google-Smtp-Source: ABdhPJyispZNegAOLXrRGrxMM31unyB5aPCWYoI1m8Ypf746shqfbdmFxXqoihMxh7zK9mXWH4GKIw==
X-Received: by 2002:adf:f94d:0:b0:1e5:5ca1:2b80 with SMTP id q13-20020adff94d000000b001e55ca12b80mr3498279wrr.323.1645128200724;
        Thu, 17 Feb 2022 12:03:20 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id f6sm20834448wrv.116.2022.02.17.12.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 12:03:20 -0800 (PST)
Date:   Thu, 17 Feb 2022 20:03:18 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ebiederm@xmission.com, bsingharora@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] taskstats: Cleanup the use of
 task->exit_code" failed to apply to 5.4-stable tree
Message-ID: <Yg6qBtvmY3t75jF9@debian>
References: <164302987619021@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="myH/wTAdfqNU0plQ"
Content-Disposition: inline
In-Reply-To: <164302987619021@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--myH/wTAdfqNU0plQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 24, 2022 at 02:11:16PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to all branches till 4.9-stable.

--
Regards
Sudip

--myH/wTAdfqNU0plQ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-taskstats-Cleanup-the-use-of-task-exit_code.patch"

From ca66fe9c13da7f1d14149b4a11bbd5dc2950180c Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 3 Jan 2022 11:32:36 -0600
Subject: [PATCH] taskstats: Cleanup the use of task->exit_code

commit 1b5a42d9c85f0e731f01c8d1129001fd8531a8a0 upstream.

In the function bacct_add_task the code reading task->exit_code was
introduced in commit f3cef7a99469 ("[PATCH] csa: basic accounting over
taskstats"), and it is not entirely clear what the taskstats interface
is trying to return as only returning the exit_code of the first task
in a process doesn't make a lot of sense.

As best as I can figure the intent is to return task->exit_code after
a task exits.  The field is returned with per task fields, so the
exit_code of the entire process is not wanted.  Only the value of the
first task is returned so this is not a useful way to get the per task
ptrace stop code.  The ordinary case of returning this value is
returning after a task exits, which also precludes use for getting
a ptrace value.

It is common to for the first task of a process to also be the last
task of a process so this field may have done something reasonable by
accident in testing.

Make ac_exitcode a reliable per task value by always returning it for
every exited task.

Setting ac_exitcode in a sensible mannter makes it possible to continue
to provide this value going forward.

Cc: Balbir Singh <bsingharora@gmail.com>
Fixes: f3cef7a99469 ("[PATCH] csa: basic accounting over taskstats")
Link: https://lkml.kernel.org/r/20220103213312.9144-5-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/tsacct.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 7be3e7530841..33a4093306f9 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -35,11 +35,10 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	/* Convert to seconds for btime */
 	do_div(delta, USEC_PER_SEC);
 	stats->ac_btime = get_seconds() - delta;
-	if (thread_group_leader(tsk)) {
+	if (tsk->flags & PF_EXITING)
 		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
+	if (thread_group_leader(tsk) && (tsk->flags & PF_FORKNOEXEC))
+		stats->ac_flag |= AFORK;
 	if (tsk->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
 	if (tsk->flags & PF_DUMPCORE)
-- 
2.30.2


--myH/wTAdfqNU0plQ--
