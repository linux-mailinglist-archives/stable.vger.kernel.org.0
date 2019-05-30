Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248E1300E0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 19:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfE3RVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 13:21:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53606 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3RVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 13:21:52 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWOkN-0000K1-Ck; Thu, 30 May 2019 11:21:47 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWOkM-0005Yj-Id; Thu, 30 May 2019 11:21:47 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        e@80x24.org, jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com> <87woi8rt96.fsf@xmission.com>
        <871s0grlzo.fsf@xmission.com> <20190530160823.GI22536@redhat.com>
Date:   Thu, 30 May 2019 12:20:52 -0500
In-Reply-To: <20190530160823.GI22536@redhat.com> (Oleg Nesterov's message of
        "Thu, 30 May 2019 18:08:24 +0200")
Message-ID: <87lfynrh8r.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hWOkM-0005Yj-Id;;;mid=<87lfynrh8r.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1895Z1ierl2kaF3bw8R919nMbS+HF5Tt3c=
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
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 325 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 4.1 (1.3%), b_tie_ro: 3.0 (0.9%), parse: 1.33
        (0.4%), extract_message_metadata: 17 (5.2%), get_uri_detail_list: 1.50
        (0.5%), tests_pri_-1000: 28 (8.5%), tests_pri_-950: 3.2 (1.0%),
        tests_pri_-900: 2.1 (0.7%), tests_pri_-90: 34 (10.5%), check_bayes: 31
        (9.6%), b_tokenize: 14 (4.2%), b_tok_get_all: 8 (2.3%), b_comp_prob:
        4.3 (1.3%), b_tok_touch_all: 2.5 (0.8%), b_finish: 0.95 (0.3%),
        tests_pri_0: 214 (65.7%), check_dkim_signature: 0.68 (0.2%),
        check_dkim_adsp: 2.7 (0.8%), poll_dns_idle: 0.43 (0.1%), tests_pri_10:
        2.3 (0.7%), tests_pri_500: 11 (3.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: pselect/etc semantics
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 05/30, Eric W. Biederman wrote:
>>
>> ebiederm@xmission.com (Eric W. Biederman) writes:
>>
>> > Which means I believe we have a semantically valid change in behavior
>> > that is causing a regression.
>>
>> I haven't made a survey of all of the functions yet but
>> fucntions return -ENORESTARTNOHAND will never return -EINTR and are
>> immune from this problem.
>
> Hmm. handle_signal:
>
> 		case -ERESTARTNOHAND:
> 			regs->ax = -EINTR;
> 			break;
>
> but I am not sure I understand which problem do you mean..

Yes.  My mistake.  I looked at the transparent restart case for when a
signal is not pending and failed to look at what happens when a signal
is delivered.

So yes.  Everything changed does appear to have a behavioral difference
where they can now succeed and not return -EINTR.

Eric
