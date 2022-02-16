Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734444B8CAA
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiBPPmJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Feb 2022 10:42:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbiBPPmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:42:09 -0500
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294B420194;
        Wed, 16 Feb 2022 07:41:55 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:35538)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMRF-001lC2-LD; Wed, 16 Feb 2022 08:41:53 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:36692 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMRD-002TMw-GQ; Wed, 16 Feb 2022 08:41:53 -0700
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
        <20220211021324.4116773-4-ebiederm@xmission.com>
        <20220215105442.GF21589@blackbody.suse.cz>
Date:   Wed, 16 Feb 2022 09:41:44 -0600
In-Reply-To: <20220215105442.GF21589@blackbody.suse.cz> ("Michal
 =?utf-8?Q?Koutn=C3=BD=22's?=
        message of "Tue, 15 Feb 2022 11:54:42 +0100")
Message-ID: <87ee42kedj.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nKMRD-002TMw-GQ;;;mid=<87ee42kedj.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+xvcr2Ikvz83sQhp/phNRB12Ed4GEsqJs=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?**;Michal Koutn=c3=bd <mkoutny@suse.com>?=
X-Spam-Relay-Country: 
X-Spam-Timing: total 1578 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 12 (0.7%), b_tie_ro: 10 (0.6%), parse: 1.30
        (0.1%), extract_message_metadata: 16 (1.0%), get_uri_detail_list: 1.94
        (0.1%), tests_pri_-1000: 24 (1.5%), tests_pri_-950: 1.39 (0.1%),
        tests_pri_-900: 1.10 (0.1%), tests_pri_-90: 80 (5.0%), check_bayes: 73
        (4.6%), b_tokenize: 8 (0.5%), b_tok_get_all: 8 (0.5%), b_comp_prob:
        2.4 (0.2%), b_tok_touch_all: 51 (3.2%), b_finish: 0.92 (0.1%),
        tests_pri_0: 1424 (90.2%), check_dkim_signature: 0.65 (0.0%),
        check_dkim_adsp: 2.8 (0.2%), poll_dns_idle: 0.92 (0.1%), tests_pri_10:
        2.5 (0.2%), tests_pri_500: 12 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 4/8] ucounts: Only except the root user in init_user_ns
 from RLIMIT_NPROC
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Koutný <mkoutny@suse.com> writes:

> On Thu, Feb 10, 2022 at 08:13:20PM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>> @@ -1881,7 +1881,7 @@ static int do_execveat_common(int fd, struct filename *filename,
> [...]
>> -	    (current_user() != INIT_USER) &&
>> +	    (current_ucounts() != &init_ucounts) &&
> [...]
>> @@ -2027,7 +2027,7 @@ static __latent_entropy struct task_struct *copy_process(
> [...]
>> -		if (p->real_cred->user != INIT_USER &&
>> +		if ((task_ucounts(p) != &init_ucounts) &&
>
> These substitutions make sense to me.
>
>>  		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
>>  			goto bad_fork_cleanup_count;
>>  	}
>> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>> index 6b2e3ca7ee99..f0c04073403d 100644
>> --- a/kernel/user_namespace.c
>> +++ b/kernel/user_namespace.c
>> @@ -123,6 +123,8 @@ int create_user_ns(struct cred *new)
>>  		ns->ucount_max[i] = INT_MAX;
>>  	}
>>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC));
>> +	if (new->ucounts == &init_ucounts)
>> +		set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, RLIMIT_INFINITY);
>>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MSGQUEUE, rlimit(RLIMIT_MSGQUEUE));
>>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_SIGPENDING, rlimit(RLIMIT_SIGPENDING));
>>  	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MEMLOCK, rlimit(RLIMIT_MEMLOCK));
>
> First, I wanted to object this double fork_init() but I realized it's
> relevant for newly created user_ns.
>
> Second, I think new->ucounts would be correct at this point and the
> check should be
>
>> if (ucounts == &init_ucounts)
>
> i.e. before set_cred_ucounts() new->ucounts may not be correct.
>
> I'd suggest also a comment in the create_user_ns() explaining the
> reason is to exempt global root from RLIMINT_NRPOC also indirectly via
> descendant user_nss.

Yes.

This one got culled from my next version of the patchset as it is not
conservative enough.  I think it is probably the right general
direction.

On further reflection I am not convinced that it makes sense to test
user or ucounts.  They are really not fields designed to support
permission checks.

I think if we want to exempt the root user's children from the root
users rlimit using the second set_rlimit_ucount_max is the way to go.

Someone filed a bug that strongly suggests that we want the second
set_rlimit_ucount_max:
https://bugzilla.kernel.org/show_bug.cgi?id=215596

I am still trying to understand that case. 

Eric
