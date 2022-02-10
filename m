Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8971F4B1513
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 19:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245608AbiBJSQr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 10 Feb 2022 13:16:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240735AbiBJSQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 13:16:47 -0500
X-Greylist: delayed 248 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 10:16:47 PST
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D7391;
        Thu, 10 Feb 2022 10:16:47 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:33626)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nIDzq-00H5Sz-IZ; Thu, 10 Feb 2022 11:16:46 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:41360 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nIDzp-00DbbZ-54; Thu, 10 Feb 2022 11:16:45 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20220210025321.787113-1-keescook@chromium.org>
        <20220210025321.787113-2-keescook@chromium.org>
Date:   Thu, 10 Feb 2022 12:16:37 -0600
In-Reply-To: <20220210025321.787113-2-keescook@chromium.org> (Kees Cook's
        message of "Wed, 9 Feb 2022 18:53:19 -0800")
Message-ID: <878rui8u4a.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nIDzp-00DbbZ-54;;;mid=<878rui8u4a.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18lRNOzyilOVPIOFwkKJROWu/Kw7VChIOM=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 342 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 3.6 (1.0%), b_tie_ro: 2.5 (0.7%), parse: 0.71
        (0.2%), extract_message_metadata: 13 (3.9%), get_uri_detail_list: 1.13
        (0.3%), tests_pri_-1000: 27 (7.9%), tests_pri_-950: 1.11 (0.3%),
        tests_pri_-900: 0.81 (0.2%), tests_pri_-90: 96 (28.1%), check_bayes:
        95 (27.8%), b_tokenize: 5 (1.5%), b_tok_get_all: 6 (1.8%),
        b_comp_prob: 1.54 (0.5%), b_tok_touch_all: 80 (23.3%), b_finish: 0.62
        (0.2%), tests_pri_0: 190 (55.4%), check_dkim_signature: 0.39 (0.1%),
        check_dkim_adsp: 2.2 (0.7%), poll_dns_idle: 0.84 (0.2%), tests_pri_10:
        1.69 (0.5%), tests_pri_500: 6 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/3] signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Fatal SIGSYS signals were not being delivered to pid namespace init
> processes . Make sure the SIGNAL_UNKILLABLE doesn't get set for these
           ^ when ptraced.
> cases.



Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

I have pointed out a few nits in the wording but otherwise this looks good.
>
> Reported-by: Robert Święcki <robert@swiecki.net>
> Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/signal.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 38602738866e..33e3ee4f3383 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1342,9 +1342,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
>  	}
>  	/*
>  	 * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
> -	 * debugging to leave init killable.
> +	 * debugging to leave init killable, unless it is intended to exit.
perhaps                                     ^ HANDLER_EXIT is always fatal.
>  	 */
> -	if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
> +	if (action->sa.sa_handler == SIG_DFL &&
> +	    (!t->ptrace || (handler == HANDLER_EXIT)))
>  		t->signal->flags &= ~SIGNAL_UNKILLABLE;
>  	ret = send_signal(sig, info, t, PIDTYPE_PID);
>  	spin_unlock_irqrestore(&t->sighand->siglock, flags);

Eric
