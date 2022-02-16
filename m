Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6014B8C88
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiBPPf2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Feb 2022 10:35:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiBPPf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:35:27 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E34F27B99D;
        Wed, 16 Feb 2022 07:35:15 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:52420)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMKn-00FW9I-GO; Wed, 16 Feb 2022 08:35:13 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:36510 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMKm-00AqhZ-C8; Wed, 16 Feb 2022 08:35:13 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Solar Designer <solar@openwall.com>, linux-kernel@vger.kernel.org,
        Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>, stable@vger.kernel.org
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
        <20220211021324.4116773-3-ebiederm@xmission.com>
        <20220212231701.GA29483@openwall.com>
        <87ee45wkjq.fsf@email.froward.int.ebiederm.org>
        <20220215102518.GE21589@blackbody.suse.cz>
Date:   Wed, 16 Feb 2022 09:35:05 -0600
In-Reply-To: <20220215102518.GE21589@blackbody.suse.cz> ("Michal
 =?utf-8?Q?Koutn=C3=BD=22's?=
        message of "Tue, 15 Feb 2022 11:25:18 +0100")
Message-ID: <87zgmqkeom.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nKMKm-00AqhZ-C8;;;mid=<87zgmqkeom.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+fN8mlsz44dbvixLO1iXTJvgmZZXpD1nU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?**;Michal Koutn=c3=bd <mkoutny@suse.com>?=
X-Spam-Relay-Country: 
X-Spam-Timing: total 417 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.6 (1.1%), b_tie_ro: 3.1 (0.7%), parse: 1.28
        (0.3%), extract_message_metadata: 14 (3.3%), get_uri_detail_list: 2.1
        (0.5%), tests_pri_-1000: 18 (4.3%), tests_pri_-950: 1.05 (0.3%),
        tests_pri_-900: 0.81 (0.2%), tests_pri_-90: 109 (26.2%), check_bayes:
        102 (24.5%), b_tokenize: 5 (1.3%), b_tok_get_all: 7 (1.7%),
        b_comp_prob: 1.73 (0.4%), b_tok_touch_all: 85 (20.4%), b_finish: 0.78
        (0.2%), tests_pri_0: 255 (61.2%), check_dkim_signature: 0.42 (0.1%),
        check_dkim_adsp: 1.84 (0.4%), poll_dns_idle: 0.51 (0.1%),
        tests_pri_10: 2.2 (0.5%), tests_pri_500: 8 (1.9%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH 3/8] ucounts: Fix and simplify RLIMIT_NPROC handling
 during setuid()+execve
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Koutný <mkoutny@suse.com> writes:

> On Mon, Feb 14, 2022 at 09:10:49AM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>> I really like how cleanly this patch seems to be.  Unfortunately it is
>> wrong.
>
> It seems [1] so:
>
> setuid()		// RLIMIT_NPROC is fine at this moment
> ...		fork()
> 		...
> ...		fork()
> execve()		// eh, oh
>
> This "punishes" the exec'ing task although the cause is elsewhere.
>
> Michal
>
> [1] The decoupled setuid()+execve() check can be interpretted both ways.
> I understood historically the excess at the setuid() moment is
> relevant.

I have been digging into this to understand why we are doing the strange
things we are doing.

Ordinarily for rlimits we are fine with letting things go over limit
until we reach a case where we need the limit (which would be fork in
the RLIMIT_NPROC case).  So things like setrlimit do not check your
counts to see if you will be over the limit.

The practical problem with fork in the unix model is that you can not
change limits or do anything for the new process until it is created
(with clone/fork).  Making it impossible to set the rlimits and change
the user before the new process is created.

The result is that in applications like apache when they run cgi scripts
(as a different user than the apache process) RLIMIT_NPROC did not work
until a check was placed into set*id() as well.  As the typical cgi
script did not fork it just did it's work and exited.

That it was discovered that allowing set*id() to fail was a footgun for
privileged processes.  And we have the existing system.


Which leads me to the starting point that set*id() checking rlimits is
a necessary but fundamentally a special case.

As long as the original use case works I think there is some latitude in
the implementation.  Maybe we set a flag and perform all of the checks
in exec.  Maybe we just send SIGKILL.  Maybe we just say it is an ugly
wart but it is our ugly wart and comment it and leave it alone.
I am leaving  that decision to a clean-up patchset.









