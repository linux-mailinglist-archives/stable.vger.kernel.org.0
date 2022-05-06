Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E256151E062
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 22:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443965AbiEFU46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 16:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbiEFU45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 16:56:57 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841DB6EB07;
        Fri,  6 May 2022 13:53:13 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:37328)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nn4wo-008Pnb-Qf; Fri, 06 May 2022 14:53:10 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37272 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nn4wn-009MmH-Ri; Fri, 06 May 2022 14:53:10 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     chill <maximkabox13@gmail.com>
Cc:     linux-arch@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <87mtfu4up3.fsf@email.froward.int.ebiederm.org>
        <20220506141512.516114-1-ebiederm@xmission.com>
        <CANpfEhNAQvazzCSN-dVgYmwNSRjqOrqZF0_j7GPLbCdEkogzSg@mail.gmail.com>
Date:   Fri, 06 May 2022 15:53:01 -0500
In-Reply-To: <CANpfEhNAQvazzCSN-dVgYmwNSRjqOrqZF0_j7GPLbCdEkogzSg@mail.gmail.com>
        (chill's message of "Fri, 6 May 2022 14:51:30 +0000")
Message-ID: <8735hm1iz6.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nn4wn-009MmH-Ri;;;mid=<8735hm1iz6.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/0RPxEyql+RbzaQX8b404dYmxPbZsYufU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;chill <maximkabox13@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 378 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 14 (3.8%), b_tie_ro: 12 (3.2%), parse: 1.08
        (0.3%), extract_message_metadata: 3.4 (0.9%), get_uri_detail_list:
        0.93 (0.2%), tests_pri_-1000: 4.1 (1.1%), tests_pri_-950: 1.50 (0.4%),
        tests_pri_-900: 1.50 (0.4%), tests_pri_-90: 75 (19.8%), check_bayes:
        72 (19.2%), b_tokenize: 6 (1.6%), b_tok_get_all: 7 (1.9%),
        b_comp_prob: 2.3 (0.6%), b_tok_touch_all: 52 (13.7%), b_finish: 1.38
        (0.4%), tests_pri_0: 256 (67.7%), check_dkim_signature: 0.75 (0.2%),
        check_dkim_adsp: 4.0 (1.1%), poll_dns_idle: 1.33 (0.4%), tests_pri_10:
        2.2 (0.6%), tests_pri_500: 8 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/7] kthread: Don't allocate kthread_struct for init and
 umh
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

chill <maximkabox13@gmail.com> writes:

> this looks like a real uaf vulnerability and can be executed by the user

The potential to use memory after it has been freed appears completely
real.  As such it is a bug and it should definitely be fixed.  That is
as far as I can see.

What I don't see, and I am very bad at this so I could be missing
something, is what bad thing kthread_is_per_cpu could be tricked into
doing.

I see a window of a single instruction which reads a single bit
that normally will return false.  If that bit instead reads true
it looks like the scheduler will simply decide to not run the
process on another cpu.


So I will put this change in linux-next.  It will be tested and I will
send it to Linus when the merge window for v5.19 opens.  After Linus
merges this I expect after a week or so it will be backported to the
various stable kernels.  Not that it needs to go farther than about
v5.17 where I introduced the bug.

Eric
