Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7845B3C7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 06:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhKXFSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 00:18:45 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:43458 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhKXFSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 00:18:44 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:40434)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mpkd2-00A5iA-Fp; Tue, 23 Nov 2021 22:15:32 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:38626 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mpkd1-006GU0-Fr; Tue, 23 Nov 2021 22:15:32 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kyle Huey <me@kylehuey.com>
Cc:     gregkh@linuxfoundation.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        Kees Cook <keescook@chromium.org>,
        Kyle Huey <khuey@kylehuey.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
References: <163758427225348@kroah.com>
        <CAP045ApHdVjC59KE7+morWY_5j4px3O0Fm6F6-cuJ+p6Q9PCPA@mail.gmail.com>
Date:   Tue, 23 Nov 2021 23:15:24 -0600
In-Reply-To: <CAP045ApHdVjC59KE7+morWY_5j4px3O0Fm6F6-cuJ+p6Q9PCPA@mail.gmail.com>
        (Kyle Huey's message of "Tue, 23 Nov 2021 17:33:19 -0800")
Message-ID: <87y25ef82b.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mpkd1-006GU0-Fr;;;mid=<87y25ef82b.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18nAf+6lDe2dhK+QFkoXNEROgnvBZIziGQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=8.0 tests=ALL_TRUSTED,BAYES_00,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0075]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kyle Huey <me@kylehuey.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 411 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 12 (2.9%), b_tie_ro: 11 (2.6%), parse: 1.04
        (0.3%), extract_message_metadata: 14 (3.4%), get_uri_detail_list: 2.2
        (0.5%), tests_pri_-1000: 13 (3.1%), tests_pri_-950: 1.27 (0.3%),
        tests_pri_-900: 1.00 (0.2%), tests_pri_-90: 68 (16.6%), check_bayes:
        67 (16.3%), b_tokenize: 6 (1.5%), b_tok_get_all: 8 (2.0%),
        b_comp_prob: 2.6 (0.6%), b_tok_touch_all: 46 (11.3%), b_finish: 0.94
        (0.2%), tests_pri_0: 279 (67.9%), check_dkim_signature: 0.68 (0.2%),
        check_dkim_adsp: 2.4 (0.6%), poll_dns_idle: 0.31 (0.1%), tests_pri_10:
        3.2 (0.8%), tests_pri_500: 15 (3.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for forced signals" failed to apply to 5.15-stable tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kyle Huey <me@kylehuey.com> writes:


> Since this is taken care of now, AFAICT, I do have one additional
> question. I reported the regression to LKML a day or so before 5.15.3
> was cut. What should I have noticed to see that the regressing
> changeset was going to 5.15 and where should I have said "hey please
> don't ship this on 5.15 yet"?
>
> I'd like to know what to do next time :)
>
When patches are added to the stable tree they are posted
for review.

I was Cc'd on a couple of them because of this discussion.  The list
appear to be "<stable-commits@vger.kernel.org>".  Feedback is requested
to go to "<stable@vger.kernel.org>".  So I believe this conversation is
enough to remove the unnecessary patches before they make it to a stable
release.

The boiler plate looks like:
> Cc: <stable-commits@vger.kernel.org>
> Date: Tue, 23 Nov 2021 19:11:53 +0100 (10 hours, 58 minutes, 56 seconds ago)
> 
> 
> This is a note to let you know that I've just added the patch titled
> 
>     exit/syscall_user_dispatch: Send ordinary signals on failure
> 
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      exit-syscall_user_dispatch-send-ordinary-signals-on-failure.patch
> and it can be found in the queue-5.15 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.


I hope that helps.

Eric
