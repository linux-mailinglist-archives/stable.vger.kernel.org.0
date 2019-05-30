Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC452FF88
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfE3PjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 11:39:12 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57371 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfE3PjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 11:39:11 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWN92-0008Q5-PY; Thu, 30 May 2019 09:39:08 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hWN90-0004BO-LO; Thu, 30 May 2019 09:39:08 -0600
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
Date:   Thu, 30 May 2019 10:38:19 -0500
In-Reply-To: <87woi8rt96.fsf@xmission.com> (Eric W. Biederman's message of
        "Thu, 30 May 2019 08:01:25 -0500")
Message-ID: <871s0grlzo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hWN90-0004BO-LO;;;mid=<871s0grlzo.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18czvVXSDQt53JTJlMUfoNVi+M6SYNvhYs=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,FVGT_m_MULTI_ODD,T_TM2_M_HEADER_IN_MSG
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 257 ms - load_scoreonly_sql: 0.13 (0.1%),
        signal_user_changed: 7 (2.8%), b_tie_ro: 5 (2.0%), parse: 0.98 (0.4%),
        extract_message_metadata: 12 (4.6%), get_uri_detail_list: 1.32 (0.5%),
        tests_pri_-1000: 13 (4.9%), tests_pri_-950: 1.31 (0.5%),
        tests_pri_-900: 1.10 (0.4%), tests_pri_-90: 20 (7.9%), check_bayes: 19
        (7.3%), b_tokenize: 6 (2.4%), b_tok_get_all: 6 (2.5%), b_comp_prob:
        1.95 (0.8%), b_tok_touch_all: 2.4 (0.9%), b_finish: 0.59 (0.2%),
        tests_pri_0: 190 (74.1%), check_dkim_signature: 0.59 (0.2%),
        check_dkim_adsp: 2.4 (0.9%), poll_dns_idle: 0.65 (0.3%), tests_pri_10:
        2.2 (0.8%), tests_pri_500: 6 (2.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: pselect/etc semantics
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Which means I believe we have a semantically valid change in behavior
> that is causing a regression.

I haven't made a survey of all of the functions yet but
fucntions return -ENORESTARTNOHAND will never return -EINTR and are
immune from this problem.

AKA pselect is fine.  While epoll_pwait can be affected.

Has anyone contacted Omar Kilani to see if that is his issue?
https://lore.kernel.org/lkml/CA+8F9hicnF=kvjXPZFQy=Pa2HJUS3JS+G9VswFHNQQynPMHGVQ@mail.gmail.com/

So far the only regression report I am seeing is from Eric Wong.
AKA https://lore.kernel.org/lkml/20190501021405.hfvd7ps623liu25i@dcvr/
Are there any others?  How did we get to be talking about more
than just epoll_pwait?

Eric
