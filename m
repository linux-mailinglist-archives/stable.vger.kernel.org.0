Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3569040DE96
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240193AbhIPPvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 11:51:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42372 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbhIPPvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 11:51:06 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:56758)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mQtdv-004f0g-NP; Thu, 16 Sep 2021 09:49:43 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:38800 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mQtdt-007UgB-Uh; Thu, 16 Sep 2021 09:49:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ohhoon Kwon <ohoono.kwon@samsung.com>,
        Ingo Molnar <mingo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
References: <20210913223339.435347-1-sashal@kernel.org>
        <20210913223339.435347-19-sashal@kernel.org> <87v932ar5q.fsf@disp2133>
        <YUKRju8/BayxKeC3@sashalap>
Date:   Thu, 16 Sep 2021 10:49:03 -0500
In-Reply-To: <YUKRju8/BayxKeC3@sashalap> (Sasha Levin's message of "Wed, 15
        Sep 2021 20:36:30 -0400")
Message-ID: <87sfy47c7k.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mQtdt-007UgB-Uh;;;mid=<87sfy47c7k.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+0Au3z3k7ifU/nnlh47JL4EIj11kK2IV4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3633]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 502 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 14 (2.8%), b_tie_ro: 12 (2.4%), parse: 0.99
        (0.2%), extract_message_metadata: 13 (2.6%), get_uri_detail_list: 1.57
        (0.3%), tests_pri_-1000: 5 (1.0%), tests_pri_-950: 1.36 (0.3%),
        tests_pri_-900: 1.16 (0.2%), tests_pri_-90: 57 (11.4%), check_bayes:
        55 (11.1%), b_tokenize: 6 (1.2%), b_tok_get_all: 8 (1.6%),
        b_comp_prob: 2.3 (0.5%), b_tok_touch_all: 34 (6.8%), b_finish: 1.14
        (0.2%), tests_pri_0: 306 (61.0%), check_dkim_signature: 0.49 (0.1%),
        check_dkim_adsp: 3.3 (0.7%), poll_dns_idle: 69 (13.7%), tests_pri_10:
        2.4 (0.5%), tests_pri_500: 97 (19.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.14 19/25] connector: send event on write to /proc/[pid]/comm
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> On Wed, Sep 15, 2021 at 08:45:37AM -0500, Eric W. Biederman wrote:
>>Sasha Levin <sashal@kernel.org> writes:
>>
>>> From: Ohhoon Kwon <ohoono.kwon@samsung.com>
>>>
>>> [ Upstream commit c2f273ebd89a79ed87ef1025753343e327b99ac9 ]
>>>
>>> While comm change event via prctl has been reported to proc connector by
>>> 'commit f786ecba4158 ("connector: add comm change event report to proc
>>> connector")', connector listeners were missing comm changes by explicit
>>> writes on /proc/[pid]/comm.
>>>
>>> Let explicit writes on /proc/[pid]/comm report to proc connector.
>>
>>This is a potential userspace ABI breakage?  Why backport it?
>>
>>Especially if there is no one asking for the behavior change in
>>userspace?
>
> This sounds like a concern with the patch going upstream rather than
> going to stable? stable has the same policy around ABI changes such as
> upstream.

Let me say it another way.  This looks more like an evolution of the
functionality rather than a bug fix.

With something like this unless someone cares I don't think it should be
backported.  It is all risk and no benefit.

This is all doubly so because I think there are about 2 connector users
and connector is not especially good at the job it tries to fulfill.
It is for that exact reason that connector does not work in containers.
We couldn't find any users who cared.

After the fiasco with the rlimit/ucount changes getting backported
before they are even stable is that I am tired of saying about backports
meh whatever.

If there is no one who actually cares (which is what I learned about
autosel from the rlimit/ucount fiasco) it makes no sense to backport
things unless they really are bug fixes.

Backporting this just looks like senseless churn.

Eric

