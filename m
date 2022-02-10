Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691394B154B
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 19:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiBJSes convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 10 Feb 2022 13:34:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiBJSes (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 13:34:48 -0500
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2286192;
        Thu, 10 Feb 2022 10:34:48 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:57436)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nIDvq-003N6V-Oc; Thu, 10 Feb 2022 11:12:38 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:41284 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nIDvo-00DaTn-8A; Thu, 10 Feb 2022 11:12:38 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <20220210025321.787113-1-keescook@chromium.org>
        <20220210025321.787113-2-keescook@chromium.org>
        <CAG48ez1m7XJ1wJvTHtNorH480jTWNgdrn5Q1LTZZQ4uve3r4Sw@mail.gmail.com>
        <202202100935.FB3E60FA5@keescook>
        <CAG48ez3fG7S1dfE2-JAtyOZUK=0_iZ03scf+oD6gwVyD1Qp33g@mail.gmail.com>
Date:   Thu, 10 Feb 2022 12:12:03 -0600
In-Reply-To: <CAG48ez3fG7S1dfE2-JAtyOZUK=0_iZ03scf+oD6gwVyD1Qp33g@mail.gmail.com>
        (Jann Horn's message of "Thu, 10 Feb 2022 19:01:39 +0100")
Message-ID: <87h7968ubw.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nIDvo-00DaTn-8A;;;mid=<87h7968ubw.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hse56qt4MsIN6aEqx2RTHnzkFuCzJSn8=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1842 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 12 (0.6%), b_tie_ro: 10 (0.5%), parse: 1.19
        (0.1%), extract_message_metadata: 25 (1.3%), get_uri_detail_list: 2.8
        (0.2%), tests_pri_-1000: 46 (2.5%), tests_pri_-950: 1.33 (0.1%),
        tests_pri_-900: 1.08 (0.1%), tests_pri_-90: 358 (19.4%), check_bayes:
        356 (19.3%), b_tokenize: 10 (0.6%), b_tok_get_all: 9 (0.5%),
        b_comp_prob: 3.4 (0.2%), b_tok_touch_all: 329 (17.8%), b_finish: 1.05
        (0.1%), tests_pri_0: 1378 (74.8%), check_dkim_signature: 0.64 (0.0%),
        check_dkim_adsp: 2.8 (0.2%), poll_dns_idle: 0.88 (0.0%), tests_pri_10:
        3.7 (0.2%), tests_pri_500: 12 (0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/3] signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Thu, Feb 10, 2022 at 6:37 PM Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Feb 10, 2022 at 05:18:39PM +0100, Jann Horn wrote:
>> > On Thu, Feb 10, 2022 at 3:53 AM Kees Cook <keescook@chromium.org> wrote:
>> > > Fatal SIGSYS signals were not being delivered to pid namespace init
>> > > processes. Make sure the SIGNAL_UNKILLABLE doesn't get set for these
>> > > cases.
>> > >
>> > > Reported-by: Robert Święcki <robert@swiecki.net>
>> > > Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> > > Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > > ---
>> > >  kernel/signal.c | 5 +++--
>> > >  1 file changed, 3 insertions(+), 2 deletions(-)
>> > >
>> > > diff --git a/kernel/signal.c b/kernel/signal.c
>> > > index 38602738866e..33e3ee4f3383 100644
>> > > --- a/kernel/signal.c
>> > > +++ b/kernel/signal.c
>> > > @@ -1342,9 +1342,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
>> > >         }
>> > >         /*
>> > >          * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
>> > > -        * debugging to leave init killable.
>> > > +        * debugging to leave init killable, unless it is intended to exit.
>> > >          */
>> > > -       if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
>> > > +       if (action->sa.sa_handler == SIG_DFL &&
>> > > +           (!t->ptrace || (handler == HANDLER_EXIT)))
>> > >                 t->signal->flags &= ~SIGNAL_UNKILLABLE;
>> >
>> > You're changing the subclause:
>> >
>> > !t->ptrace
>> >
>> > to:
>> >
>> > (!t->ptrace || (handler == HANDLER_EXIT))
>> >
>> > which means that the change only affects cases where the process has a
>> > ptracer, right? That's not the scenario the commit message is talking
>> > about...
>>
>> Sorry, yes, I was not as accurate as I should have been in the commit
>> log. I have changed it to:
>>
>> Fatal SIGSYS signals (i.e. seccomp RET_KILL_* syscall filter actions)
>> were not being delivered to ptraced pid namespace init processes. Make
>> sure the SIGNAL_UNKILLABLE doesn't get set for these cases.
>
> So basically force_sig_info() is trying to figure out whether
> get_signal() will later on check for SIGNAL_UNKILLABLE (the SIG_DFL
> case), and if so, it clears the flag from the target's signal_struct
> that marks the process as unkillable?
>
> This used to be:
>
> if (action->sa.sa_handler == SIG_DFL)
>     t->signal->flags &= ~SIGNAL_UNKILLABLE;
>
> Then someone noticed that in the ptrace case, the signal might not
> actually end up being consumed by the target process, and added the
> "&& !t->ptrace" clause in commit
> eb61b5911bdc923875cde99eb25203a0e2b06d43.
>
> And now Robert Swiecki noticed that that still didn't accurately model
> what'll happen in get_signal().
>
>
> This seems hacky to me, and also racy: What if, while you're going
> through a SECCOMP_RET_KILL_PROCESS in an unkillable process, some
> other thread e.g. concurrently changes the disposition of SIGSYS from
> a custom handler to SIG_DFL?
>
> Instead of trying to figure out whether the signal would have been
> fatal without SIGNAL_UNKILLABLE, I think it would be better to find a
> way to tell the signal-handling code that SIGNAL_UNKILLABLE should be
> bypassed for this specific signal, or something along those lines...
> but of course that's also kind of messy because the signal-sending
> code might fall back to just using the pending signal mask on
> allocation failure IIRC?

I am actively working on this.  I think I know how to get there but
it requires cleanups elsewhere as well, so it is not really an approach
that is appropriate for backporting.

The big bottleneck is that we need to make signals that trigger
coredumps eligible for short circuit delivery, and that takes a little
doing.

Eric

