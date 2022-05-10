Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE65521E62
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiEJP2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346248AbiEJP0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:26:51 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB81C200F62;
        Tue, 10 May 2022 08:14:12 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:55498)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1noRYx-00Cznd-JJ; Tue, 10 May 2022 09:14:11 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37640 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1noRYv-00Dzkh-Bm; Tue, 10 May 2022 09:14:11 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-arch@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?0JzQsNC60YHQuNC8INCa0YPRgtGP0LLQuNC9?= 
        <maximkabox13@gmail.com>
References: <87mtfu4up3.fsf@email.froward.int.ebiederm.org>
        <20220506141512.516114-1-ebiederm@xmission.com> <87fslhpi58.ffs@tglx>
Date:   Tue, 10 May 2022 10:14:01 -0500
In-Reply-To: <87fslhpi58.ffs@tglx> (Thomas Gleixner's message of "Tue, 10 May
        2022 16:38:27 +0200")
Message-ID: <87v8udwhc6.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1noRYv-00Dzkh-Bm;;;mid=<87v8udwhc6.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18r1alnvHdXXOMJb1iQYhRdbubmdw+zTt0=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1633 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 11 (0.7%), b_tie_ro: 10 (0.6%), parse: 1.80
        (0.1%), extract_message_metadata: 19 (1.2%), get_uri_detail_list: 2.6
        (0.2%), tests_pri_-1000: 17 (1.0%), tests_pri_-950: 1.75 (0.1%),
        tests_pri_-900: 1.39 (0.1%), tests_pri_-90: 272 (16.7%), check_bayes:
        270 (16.5%), b_tokenize: 7 (0.5%), b_tok_get_all: 9 (0.5%),
        b_comp_prob: 2.4 (0.1%), b_tok_touch_all: 247 (15.1%), b_finish: 1.05
        (0.1%), tests_pri_0: 1291 (79.0%), check_dkim_signature: 0.74 (0.0%),
        check_dkim_adsp: 3.1 (0.2%), poll_dns_idle: 0.64 (0.0%), tests_pri_10:
        2.6 (0.2%), tests_pri_500: 11 (0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/7] kthread: Don't allocate kthread_struct for init and
 umh
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Fri, May 06 2022 at 09:15, Eric W. Biederman wrote:
>>  	 * the init task will end up wanting to create kthreads, which, if
>>  	 * we schedule it before we create kthreadd, will OOPS.
>>  	 */
>> -	pid = kernel_thread(kernel_init, NULL, CLONE_FS);
>> +	pid = user_mode_thread(kernel_init, NULL, CLONE_FS);
>
> So init does not have PF_KTHREAD set anymore, which causes this to go
> sideways with a NULL pointer dereference in get_mm_counter() on next:

Well not after the change above, but in a later patch yes.

Patch 1/7 really gets us back to the previous status quo, where
I introduced the breakage.

>  get_mm_counter include/linux/mm.h:1996 [inline]
>  get_mm_rss include/linux/mm.h:2049 [inline]
>  task_nr_scan_windows.isra.0+0x23/0x120 kernel/sched/fair.c:1123
>  task_scan_min kernel/sched/fair.c:1144 [inline]
>  task_scan_start+0x6c/0x400 kernel/sched/fair.c:1150
>  task_tick_numa kernel/sched/fair.c:2944 [inline]
>  task_tick_fair+0xaeb/0xef0 kernel/sched/fair.c:11186
>  scheduler_tick+0x20a/0x5e0 kernel/sched/core.c:5380
>
>  https://lore.kernel.org/lkml/0000000000008a9fbb05dea76400@google.com
>
> because the fence in task_tick_numa():
>
>  	if ((curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next != work)
> 		return;
>
> is not longer sufficient. It needs also to bail if !curr->mm.

Agreed.  I proposed a patch to do just that a little while ago.

> I'm worried that there are more of these issues lurking. Haven't looked
> yet.

I looked earlier and I missed this one.  I am going to look again today,
along with applying the obvious fix to task_tick_numa.

I don't think there are many but when the code has evolved into a shape
that is not easy to understand things occasionally slip through when the
abstractions are made clear to understand.  The reason to rework the
code and make it clear is that once the code has evolved to a point of
many subtle issues making any change is brittle.

Eric

