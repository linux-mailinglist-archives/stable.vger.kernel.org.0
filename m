Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D7819C3CB
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbgDBOR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 10:17:28 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33362 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731783AbgDBOR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 10:17:28 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jK0es-0003sC-5r; Thu, 02 Apr 2020 08:17:26 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jK0en-0002Mh-AX; Thu, 02 Apr 2020 08:17:25 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jann Horn <jannh@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Adam Zabrocki <pi3@pi3.com.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
        <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez1dCPw9Dep-+GWn=SnHv1nVv4Npv1FpFxmomk6tmazB-g@mail.gmail.com>
Date:   Thu, 02 Apr 2020 09:14:38 -0500
In-Reply-To: <CAG48ez1dCPw9Dep-+GWn=SnHv1nVv4Npv1FpFxmomk6tmazB-g@mail.gmail.com>
        (Jann Horn's message of "Thu, 2 Apr 2020 06:46:49 +0200")
Message-ID: <87y2rekm9d.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK0en-0002Mh-AX;;;mid=<87y2rekm9d.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19aHVbkFFXhJEzKOhX85KQe0ZY2f9JbahM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4764]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 4401 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.4 (0.1%), b_tie_ro: 3.1 (0.1%), parse: 0.99
        (0.0%), extract_message_metadata: 12 (0.3%), get_uri_detail_list: 1.37
        (0.0%), tests_pri_-1000: 10 (0.2%), tests_pri_-950: 0.98 (0.0%),
        tests_pri_-900: 0.80 (0.0%), tests_pri_-90: 300 (6.8%), check_bayes:
        298 (6.8%), b_tokenize: 4.6 (0.1%), b_tok_get_all: 224 (5.1%),
        b_comp_prob: 1.51 (0.0%), b_tok_touch_all: 65 (1.5%), b_finish: 0.78
        (0.0%), tests_pri_0: 166 (3.8%), check_dkim_signature: 0.37 (0.0%),
        check_dkim_adsp: 2.2 (0.0%), poll_dns_idle: 3894 (88.5%),
        tests_pri_10: 1.77 (0.0%), tests_pri_500: 3901 (88.7%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Wed, Apr 1, 2020 at 10:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Replace the 32bit exec_id with a 64bit exec_id to make it impossible
>> to wrap the exec_id counter.  With care an attacker can cause exec_id
>> wrap and send arbitrary signals to a newly exec'd parent.  This
>> bypasses the signal sending checks if the parent changes their
>> credentials during exec.
>>
>> The severity of this problem can been seen that in my limited testing
>> of a 32bit exec_id it can take as little as 19s to exec 65536 times.
>> Which means that it can take as little as 14 days to wrap a 32bit
>> exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
>> days.  Even my slower timing is in the uptime of a typical server.
>
> FYI, if you actually optimize this, it's more like 12s to exec 1048576
> times according to my test, which means ~14 hours for 2^32 executions
> (on a single core). That's on an i7-4790 (a Haswell desktop processor
> that was launched about six years ago, in 2014).

Half a day.  I am not at all surprised, but it is good to know it can
take so little time.

Eric
