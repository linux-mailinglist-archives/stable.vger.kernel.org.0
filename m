Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822184B54AD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354761AbiBNPX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 10:23:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351745AbiBNPX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 10:23:26 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432C44755A;
        Mon, 14 Feb 2022 07:23:19 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:38326)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nJdC9-0031ok-MP; Mon, 14 Feb 2022 08:23:17 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:60362 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nJdC8-001VFM-6U; Mon, 14 Feb 2022 08:23:17 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Solar Designer <solar@openwall.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Michal Koutn?? <mkoutny@suse.com>, stable@vger.kernel.org
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
        <20220211021324.4116773-5-ebiederm@xmission.com>
        <20220212223638.GB29214@openwall.com>
Date:   Mon, 14 Feb 2022 09:23:09 -0600
In-Reply-To: <20220212223638.GB29214@openwall.com> (Solar Designer's message
        of "Sat, 12 Feb 2022 23:36:39 +0100")
Message-ID: <87k0dxv5eq.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nJdC8-001VFM-6U;;;mid=<87k0dxv5eq.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18dw1lI1ntSwcqLdHM5MIlns4bu6PWfLKs=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Solar Designer <solar@openwall.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 902 ms - load_scoreonly_sql: 0.22 (0.0%),
        signal_user_changed: 20 (2.2%), b_tie_ro: 14 (1.6%), parse: 6 (0.7%),
        extract_message_metadata: 43 (4.8%), get_uri_detail_list: 4.4 (0.5%),
        tests_pri_-1000: 43 (4.7%), compile_eval: 59 (6.5%), tests_pri_-950:
        2.0 (0.2%), tests_pri_-900: 1.93 (0.2%), tests_pri_-90: 134 (14.9%),
        check_bayes: 130 (14.4%), b_tokenize: 9 (1.0%), b_tok_get_all: 8
        (0.9%), b_comp_prob: 2.7 (0.3%), b_tok_touch_all: 105 (11.6%),
        b_finish: 1.71 (0.2%), tests_pri_0: 621 (68.9%), check_dkim_signature:
        1.40 (0.2%), check_dkim_adsp: 6 (0.6%), poll_dns_idle: 0.86 (0.1%),
        tests_pri_10: 3.1 (0.3%), tests_pri_500: 16 (1.8%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Solar Designer <solar@openwall.com> writes:

> On Thu, Feb 10, 2022 at 08:13:21PM -0600, Eric W. Biederman wrote:
>> While examining is_ucounts_overlimit and reading the various messages
>> I realized that is_ucounts_overlimit fails to deal with counts that
>> may have wrapped.
>> 
>> Being wrapped should be a transitory state for counts and they should
>> never be wrapped for long, but it can happen so handle it.
>> 
>> Cc: stable@vger.kernel.org
>> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  kernel/ucount.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/kernel/ucount.c b/kernel/ucount.c
>> index 65b597431c86..06ea04d44685 100644
>> --- a/kernel/ucount.c
>> +++ b/kernel/ucount.c
>> @@ -350,7 +350,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
>>  	if (rlimit > LONG_MAX)
>>  		max = LONG_MAX;
>>  	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
>> -		if (get_ucounts_value(iter, type) > max)
>> +		long val = get_ucounts_value(iter, type);
>> +		if (val < 0 || val > max)
>>  			return true;
>>  		max = READ_ONCE(iter->ns->ucount_max[type]);
>>  	}
>
> You probably deliberately assume "gcc -fwrapv", but otherwise:
>
> As you're probably aware, a signed integer wrapping is undefined
> behavior in C.  In the function above, "val" having wrapped to negative
> assumes we had occurred UB elsewhere.  Further, there's an instance of
> UB in the function itself:

While in cases like this we pass the value in a long, the operations on
the value occur in an atomic_long_t.  As atomic_long_t is implemented in
assembly we do escape the problems of undefined behavior.


> bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long rlimit)
> {
> 	struct ucounts *iter;
> 	long max = rlimit;
> 	if (rlimit > LONG_MAX)
> 		max = LONG_MAX;
>
> The assignment on "long max = rlimit;" would have already been UB if
> "rlimit > LONG_MAX", which is only checked afterwards.  I think the
> above would be better written as:
>
> 	if (rlimit > LONG_MAX)
> 		rlimit = LONG_MAX;
> 	long max = rlimit;
>
> considering that "rlimit" is never used further in that function.

Thank you for spotting that.  That looks like a good idea.  Even if it
works in this case it is better to establish patterns that are not
problematic if copy and pasted elsewhere.

> And to more likely avoid wraparound of "val", perhaps have the limit at
> a value significantly lower than LONG_MAX, like half that?  So:

For the case of RLIMIT_NPROC the real world limit is PID_MAX_LIMIT
which is 2^22.

Beyond that the code deliberately uses all values with the high bit/sign
bit set to flag that things went too high.  So the code already reserves
half of the values.

> I assume that once is_ucounts_overlimit() returned true, it is expected
> the value would almost not grow further (except a little due to races).

Pretty much. The function essentially only exists so that we can
handle the weirdness of RLIMIT_NPROC.  Now that I have discovered the
weirdness of RLIMIT_NPROC is old historical sloppiness I expect the
proper solution is to rework how RLIMIT_NPROC operates and to remove
is_ucounts_overlimit all together.   I have to figure out what a proper
RLIMIT_NPROC check looks like in proc.

Eric
