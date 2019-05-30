Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE2A2FBE7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfE3NE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:04:59 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:40444 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfE3NE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 09:04:59 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWKjq-0001o6-J4; Thu, 30 May 2019 07:04:58 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWKjp-0006KM-2L; Thu, 30 May 2019 07:04:58 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Eric Wong <e@80x24.org>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        'Oleg Nesterov' <oleg@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd\@arndb.de" <arnd@arndb.de>,
        "dbueso\@suse.de" <dbueso@suse.de>,
        "axboe\@kernel.dk" <axboe@kernel.dk>,
        "dave\@stgolabs.net" <dave@stgolabs.net>,
        "jbaron\@akamai.com" <jbaron@akamai.com>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio\@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani\@gmail.com" <omar.kilani@gmail.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com>
        <b05cec7f9e8f457281e689576a7a360f@AcuMS.aculab.com>
        <20190529185012.qqeqq4fsolprknrz@dcvr>
Date:   Thu, 30 May 2019 08:04:50 -0500
In-Reply-To: <20190529185012.qqeqq4fsolprknrz@dcvr> (Eric Wong's message of
        "Wed, 29 May 2019 18:50:12 +0000")
Message-ID: <87ef4grt3h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hWKjp-0006KM-2L;;;mid=<87ef4grt3h.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+tK8wFikScRQNziP7B/XxiQEAJ+eiy2zc=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Wong <e@80x24.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1118 ms - load_scoreonly_sql: 0.12 (0.0%),
        signal_user_changed: 8 (0.7%), b_tie_ro: 7 (0.6%), parse: 1.57 (0.1%),
        extract_message_metadata: 45 (4.0%), get_uri_detail_list: 3.0 (0.3%),
        tests_pri_-1000: 29 (2.6%), tests_pri_-950: 2.0 (0.2%),
        tests_pri_-900: 1.63 (0.1%), tests_pri_-90: 151 (13.5%), check_bayes:
        149 (13.3%), b_tokenize: 120 (10.7%), b_tok_get_all: 6 (0.6%),
        b_comp_prob: 3.0 (0.3%), b_tok_touch_all: 2.6 (0.2%), b_finish: 0.68
        (0.1%), tests_pri_0: 816 (73.0%), check_dkim_signature: 0.66 (0.1%),
        check_dkim_adsp: 7 (0.7%), poll_dns_idle: 5 (0.5%), tests_pri_10: 4.5
        (0.4%), tests_pri_500: 19 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: pselect/etc semantics
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric Wong <e@80x24.org> writes:

> Agreed...  I believe cmogstored has always had a bug in the way
> it uses epoll_pwait because it failed to check interrupts if:
>
> a) an FD is ready + interrupt
> b) epoll_pwait returns 0 on interrupt
>
> The bug remains in userspace for a), which I will fix by adding
> an interrupt check when an FD is ready.  The window is very
> small for a) and difficult to trigger, and also in a rare code
> path.
>
> The b) case is the kernel bug introduced in 854a6ed56839a40f
> ("signal: Add restore_user_sigmask()").
>
> I don't think there's any disagreement that b) is a kernel bug.

See my reply to Oleg.  I think (b) is a regression that needs to be
fixed.  I do not think that (b) is a kernel bug.  Both versions of the
of what sigmask means posix and naive will allow (b).

Because fundamentally the sigmask is restored after the rest of the
system call happens.

Eric
