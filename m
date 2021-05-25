Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894AC390B4F
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhEYV0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:26:44 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33102 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhEYV0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:26:43 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lleY0-00HLfp-3h; Tue, 25 May 2021 15:25:08 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lleXz-0003h6-73; Tue, 25 May 2021 15:25:07 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
References: <20210525193735.2716374-1-keescook@chromium.org>
        <CAG48ez2PdgpUj3GYRLDJ9MS1uKMZ4SU77i__vhXvmbzqudzuzA@mail.gmail.com>
Date:   Tue, 25 May 2021 16:24:52 -0500
In-Reply-To: <CAG48ez2PdgpUj3GYRLDJ9MS1uKMZ4SU77i__vhXvmbzqudzuzA@mail.gmail.com>
        (Jann Horn's message of "Tue, 25 May 2021 22:49:29 +0200")
Message-ID: <m1r1humrq3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lleXz-0003h6-73;;;mid=<m1r1humrq3.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18b6GauH7woP0dutn2xuSoDIfadYjyx/GI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 444 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 15 (3.4%), b_tie_ro: 13 (2.9%), parse: 0.99
        (0.2%), extract_message_metadata: 14 (3.0%), get_uri_detail_list: 1.98
        (0.4%), tests_pri_-1000: 5 (1.1%), tests_pri_-950: 1.36 (0.3%),
        tests_pri_-900: 1.16 (0.3%), tests_pri_-90: 56 (12.5%), check_bayes:
        53 (12.0%), b_tokenize: 7 (1.6%), b_tok_get_all: 9 (2.0%),
        b_comp_prob: 3.2 (0.7%), b_tok_touch_all: 29 (6.6%), b_finish: 1.48
        (0.3%), tests_pri_0: 338 (76.1%), check_dkim_signature: 0.49 (0.1%),
        check_dkim_adsp: 3.3 (0.7%), poll_dns_idle: 0.18 (0.0%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 8 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] proc: Check /proc/$pid/attr/ writes against file opener
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Tue, May 25, 2021 at 9:37 PM Kees Cook <keescook@chromium.org> wrote:
>> Fix another "confused deputy" weakness[1]. Writes to /proc/$pid/attr/
>> files need to check the opener credentials, since these fds do not
>> transition state across execve(). Without this, it is possible to
>> trick another process (which may have different credentials) to write
>> to its own /proc/$pid/attr/ files, leading to unexpected and possibly
>> exploitable behaviors.
>>
>> [1] https://www.kernel.org/doc/html/latest/security/credentials.html?highlight=confused#open-file-credentials
>>
>> Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  fs/proc/base.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 3851bfcdba56..58bbf334265b 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2703,6 +2703,10 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>>         void *page;
>>         int rv;
>>
>> +       /* A task may only write when it was the opener. */
>> +       if (file->f_cred != current_real_cred())
>> +               return -EPERM;
>
> With this, if a task forks, the child will then still be able to open
> its parent's /proc/$pid/attr/current and trick the parent into writing
> to that, right? Is that acceptable? If not, the ->open handler should
> probably also check for "current->thread_pid == proc_pid(inode)", or
> something like that?

Currently exec always allocates a new cred.  So you can only ``trick''
another process that was forked from you.  I don't think it counts as
tricking or any kind of danger if you are simply confusing yourself.

Eric

