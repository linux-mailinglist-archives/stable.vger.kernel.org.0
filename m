Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9194C3A46
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 01:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbiBYAYU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 24 Feb 2022 19:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiBYAYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 19:24:20 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B201BBF78;
        Thu, 24 Feb 2022 16:23:48 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:39456)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nNOOh-001EAc-6r; Thu, 24 Feb 2022 17:23:47 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:56788 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nNOOe-000We2-VS; Thu, 24 Feb 2022 17:23:46 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <20220221084915.554151737@linuxfoundation.org>
        <20220221084916.628257481@linuxfoundation.org>
        <20220221234610.0d23e2e0@plasteblaster>
        <87sfsa8nmf.fsf@email.froward.int.ebiederm.org>
        <20220223234027.30566235@plasteblaster>
Date:   Thu, 24 Feb 2022 18:23:13 -0600
In-Reply-To: <20220223234027.30566235@plasteblaster> (Thomas Orgis's message
        of "Wed, 23 Feb 2022 23:40:27 +0100")
Message-ID: <87ee3riyku.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nNOOe-000We2-VS;;;mid=<87ee3riyku.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18uCExlTM8TG4mAl1nwHDJABZ9+OTQeHy0=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1493 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 11 (0.7%), b_tie_ro: 10 (0.6%), parse: 0.96
        (0.1%), extract_message_metadata: 16 (1.1%), get_uri_detail_list: 2.5
        (0.2%), tests_pri_-1000: 19 (1.2%), tests_pri_-950: 1.23 (0.1%),
        tests_pri_-900: 1.00 (0.1%), tests_pri_-90: 83 (5.6%), check_bayes: 82
        (5.5%), b_tokenize: 9 (0.6%), b_tok_get_all: 10 (0.7%), b_comp_prob:
        3.1 (0.2%), b_tok_touch_all: 56 (3.8%), b_finish: 0.83 (0.1%),
        tests_pri_0: 1123 (75.2%), check_dkim_signature: 0.88 (0.1%),
        check_dkim_adsp: 3.3 (0.2%), poll_dns_idle: 24 (1.6%), tests_pri_10:
        2.3 (0.2%), tests_pri_500: 233 (15.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 5.4 32/80] taskstats: Cleanup the use of task->exit_code
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de> writes:

> Am Tue, 22 Feb 2022 17:53:12 -0600
> schrieb "Eric W. Biederman" <ebiederm@xmission.com>: 
>
>> How do you figure?
>
> I admit that I am struggling with understanding where exit codes come
> from in the non-usual cases. During my taskstats tests, I played with
> writing a multithreaded application that does call pthread_exit() in
> the main thread (pid==tgid), for example. I slowly had to learn just
> how messy this can be …
>
> Is it clearly defined what the exitcode of a task as part of a process
> is/should/can mean, as opposed to the process as a whole?

In the code it is clearly defined.  The decoding is exactly the same
as from an entire process and for a single threaded process there is no
difference.

Linux has a system 2 system calls "exit(2)" and "exit_group(2)" if a
thread exits by itself whatever is passed to exit(2) is the exit code.

What pthread_exit passes to exit(2) I don't know.  I have not been able
to trace glibc that far, and I have not instrumented up a kernel to see.

For threads that are alive when exit_group(2) is called they all get the
same final exit code.

>> For single-threaded processes ac_exitcode would always be reasonable,
>> and be what userspace passed to exit(3).
>
> Yes. That is the one case where we all know what we are dealing with;-)
>
>> For multi-threaded processes ac_exitcode before my change was set to
>> some completely arbitrary value for the thread whose tgid == tid.
>
> Isn't the only place where it really makes sense to set the exitcode
> when the last task of the process exits? I guess that was the intention
> of the earlier code — with the same wrong assumption that I fell victim
> to for quite some time: That the group leader (first task, tgid == pid)
> always exits last.
>
> I do not know in which cases group member threads have meaningful exit
> codes different from the last one (which is the one returned for the
> process in whole … ?). I'd love to see the exact reasoning on how
> multithreading got mapped into kernel tasks which used to track only
> single-threaded processes before.

The internal model in the kernel is there are tasks (which pthreads are
mapped to in a 1-1 fashion).  These tasks were the original process
abstraction.  In the case of CLONE_THREAD these tasks are glued together
into a POSIX process, with shared signal handling.

So from a kernel standpoint as it basically the original process
abstraction it is all well defined what happens when an individual task
exits.

>> With my change the value returned
>> is at least well defined.
>
> But defined to what?

See above.

>> Now maybe it would have been better to flag the bug fix with a version
>> number.  Unfortunately I did not even realize taskstats had a version
>> number.  I just know the code made no sense.
>
> Well, fixing a bug that has been there from the beginning (of adding
> multithreading, at least) is a significant change that one might want
> to know about. And I do think that it fits to thouroughly fix these
> issues that relate to identifying threads and processes (the shameless
> plug of my taskstats patch that I'm working on since 2018, and only got
> right in 2022, finally — I hope), while at that.

It looks like the bug was in commit f3cef7a99469 ("[PATCH] csa: basic
accounting over taskstats") in 2006 in 2.6.19-rc1 when taskstats were
added.  That is long after CLONE_THREAD support was added in the 2.5
development kernel.

I have been working to get a single place that code can look to find the
process exit status.  AKA so that the code can always set
SIGNAL_GROUP_EXIT, and look at signal->group_exit_code.  Fixing this was
just part of sorting out the misconceptions, and I didn't realize there
was anyone that paying attention and cared.

I will see if I can find some time to give your taskstats patch a
review.

Eric
