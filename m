Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6764317E5D9
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 18:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCIRgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 13:36:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60476 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgCIRgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 13:36:47 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBMKZ-00016U-Gy; Mon, 09 Mar 2020 11:36:43 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBMKY-0007sX-Iu; Mon, 09 Mar 2020 11:36:43 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nmjulm.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <202003021531.C77EF10@keescook>
        <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
        <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nlii0b.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170FBDA2F0F19ECF2906703E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 09 Mar 2020 12:34:24 -0500
In-Reply-To: <AM6PR03MB5170FBDA2F0F19ECF2906703E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Mon, 9 Mar 2020 13:56:54 +0000")
Message-ID: <87mu8p4elb.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBMKY-0007sX-Iu;;;mid=<87mu8p4elb.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/gNgifOiuTUXAnVHdP8jsGgkYYuPh4Nbk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 329 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.7 (0.8%), b_tie_ro: 1.94 (0.6%), parse: 0.99
        (0.3%), extract_message_metadata: 14 (4.1%), get_uri_detail_list: 1.33
        (0.4%), tests_pri_-1000: 17 (5.3%), tests_pri_-950: 1.16 (0.4%),
        tests_pri_-900: 1.04 (0.3%), tests_pri_-90: 31 (9.4%), check_bayes: 30
        (9.0%), b_tokenize: 12 (3.5%), b_tok_get_all: 9 (2.6%), b_comp_prob:
        2.8 (0.8%), b_tok_touch_all: 4.4 (1.3%), b_finish: 0.68 (0.2%),
        tests_pri_0: 249 (75.6%), check_dkim_signature: 0.54 (0.2%),
        check_dkim_adsp: 10 (3.0%), poll_dns_idle: 0.45 (0.1%), tests_pri_10:
        2.0 (0.6%), tests_pri_500: 7 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/8/20 10:35 PM, Eric W. Biederman wrote:
>> 
>> Make it clear that current only needs to be computed once in
>> flush_old_exec.  This may have some efficiency improvements and it
>> makes the code easier to change.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/exec.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/exec.c b/fs/exec.c
>> index db17be51b112..c3f34791f2f0 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>>   */
>>  int flush_old_exec(struct linux_binprm * bprm)
>>  {
>> +	struct task_struct *me = current;
>>  	int retval;
>>  
>>  	/*
>>  	 * Make sure we have a private signal table and that
>>  	 * we are unassociated from the previous thread group.
>>  	 */
>> -	retval = de_thread(current);
>> +	retval = de_thread(me);
>>  	if (retval)
>>  		goto out;
>>  
>> @@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
>>  	bprm->mm = NULL;
>>  
>>  	set_fs(USER_DS);
>> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>> +	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>>  					PF_NOFREEZE | PF_NO_SETAFFINITY);
>
> I wonder if this line should be aligned with the previous?

In this case I don't think so.  The style used for second line is indent
with tabs as much as possible to the right.  I haven't changed that.

Further mixing a change in indentation style with just a variable rename
will make the patch confusing to read because two things have to be
verified at the same time.

So while I see why you ask I think this bit needs to stay as is.

Eric




