Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBE94B8C50
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiBPPWb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Feb 2022 10:22:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiBPPWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:22:30 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A90CF4D3D;
        Wed, 16 Feb 2022 07:22:17 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:59752)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKM8E-00FUVx-J8; Wed, 16 Feb 2022 08:22:14 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:35816 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKM8D-00AnNX-Kw; Wed, 16 Feb 2022 08:22:14 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org, stable@vger.kernel.org
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
        <20220211021324.4116773-1-ebiederm@xmission.com>
        <20220214183727.GA10803@blackbody.suse.cz>
Date:   Wed, 16 Feb 2022 09:22:06 -0600
In-Reply-To: <20220214183727.GA10803@blackbody.suse.cz> ("Michal
 =?utf-8?Q?Koutn=C3=BD=22's?=
        message of "Mon, 14 Feb 2022 19:37:27 +0100")
Message-ID: <87bkz6n8f5.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nKM8D-00AnNX-Kw;;;mid=<87bkz6n8f5.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18GHd2u5OO43mJ7g75YNTvv6XIKXa6NCZc=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Michal Koutn=c3=bd <mkoutny@suse.com>?=
X-Spam-Relay-Country: 
X-Spam-Timing: total 382 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 11 (3.0%), b_tie_ro: 9 (2.5%), parse: 2.2 (0.6%),
        extract_message_metadata: 24 (6.4%), get_uri_detail_list: 2.0 (0.5%),
        tests_pri_-1000: 39 (10.2%), tests_pri_-950: 1.69 (0.4%),
        tests_pri_-900: 1.33 (0.3%), tests_pri_-90: 69 (18.1%), check_bayes:
        67 (17.4%), b_tokenize: 7 (1.9%), b_tok_get_all: 6 (1.5%),
        b_comp_prob: 2.5 (0.6%), b_tok_touch_all: 47 (12.4%), b_finish: 1.25
        (0.3%), tests_pri_0: 214 (55.9%), check_dkim_signature: 0.92 (0.2%),
        check_dkim_adsp: 3.6 (0.9%), poll_dns_idle: 0.97 (0.3%), tests_pri_10:
        2.2 (0.6%), tests_pri_500: 12 (3.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/8] ucounts: Fix RLIMIT_NPROC regression
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Koutný <mkoutny@suse.com> writes:

> On Thu, Feb 10, 2022 at 08:13:17PM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>> This can be fixed either by fixing the test or by moving the increment
>> to be before the test.  Fix it my moving copy_creds which contains
>> the increment before is_ucounts_overlimit.
>
> This is simpler than my approach and I find it correct too.
>
>> Both the test in fork and the test in set_user were semantically
>> changed when the code moved to ucounts.  The change of the test in
>> fork was bad because it was before the increment.
>>
>> The test in set_user was wrong and the change to ucounts fixed it.  So
>> this fix is only restore the old behavior in one lcatio not two.
>
> Whom should be the task accounted to in the case of set*uid? (The change
> to ucounts made the check against the pre-switch user's ucounts.)

It needs to be post-switch in the case of set*id().

I have that fixed in the next version of my patchset.

>> ---
>>  kernel/fork.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
