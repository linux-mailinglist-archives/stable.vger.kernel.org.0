Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584CD4C0593
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 00:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbiBVXyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 18:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236329AbiBVXyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 18:54:14 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8452FFC3;
        Tue, 22 Feb 2022 15:53:48 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:48792)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nMeyW-00D5Zz-O9; Tue, 22 Feb 2022 16:53:45 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:51066 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nMeyT-008QFE-Sj; Tue, 22 Feb 2022 16:53:44 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>
References: <20220221084915.554151737@linuxfoundation.org>
        <20220221084916.628257481@linuxfoundation.org>
        <20220221234610.0d23e2e0@plasteblaster>
Date:   Tue, 22 Feb 2022 17:53:12 -0600
In-Reply-To: <20220221234610.0d23e2e0@plasteblaster> (Thomas Orgis's message
        of "Mon, 21 Feb 2022 23:46:10 +0100")
Message-ID: <87sfsa8nmf.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nMeyT-008QFE-Sj;;;mid=<87sfsa8nmf.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18tO8ahZmJWbAsAz1uv1DwCxv6VHTabo0U=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1594 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 12 (0.7%), b_tie_ro: 10 (0.6%), parse: 1.14
        (0.1%), extract_message_metadata: 20 (1.3%), get_uri_detail_list: 2.2
        (0.1%), tests_pri_-1000: 18 (1.1%), tests_pri_-950: 1.32 (0.1%),
        tests_pri_-900: 1.02 (0.1%), tests_pri_-90: 158 (9.9%), check_bayes:
        145 (9.1%), b_tokenize: 7 (0.4%), b_tok_get_all: 7 (0.5%),
        b_comp_prob: 2.4 (0.2%), b_tok_touch_all: 125 (7.8%), b_finish: 1.00
        (0.1%), tests_pri_0: 1359 (85.3%), check_dkim_signature: 0.55 (0.0%),
        check_dkim_adsp: 2.9 (0.2%), poll_dns_idle: 1.14 (0.1%), tests_pri_10:
        3.5 (0.2%), tests_pri_500: 17 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 5.4 32/80] taskstats: Cleanup the use of task->exit_code
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de> writes:

> Am Mon, 21 Feb 2022 09:49:12 +0100
> schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>: 
>
>> As best as I can figure the intent is to return task->exit_code after
>> a task exits.  The field is returned with per task fields, so the
>> exit_code of the entire process is not wanted.
>
> I wondered about the use of exit_code, too, when preparing my patch
> that introduces ac_tgid and the AGROUP flag to identify the first and
> last tasks of a task group/process, see
>
> 	https://lkml.org/lkml/2022/2/18/887
>
> With the information about the position of this task in the group,
> users can take some meaning from the exit code (individual kills?). The
> old style ensured that you got one exit code per process.

How do you figure?

For single-threaded processes ac_exitcode would always be reasonable,
and be what userspace passed to exit(3).

For multi-threaded processes ac_exitcode before my change was set to
some completely arbitrary value for the thread whose tgid == tid.

Frequently the thread whose tgid == tid is the last thread to
exit and is brought down by a call to group_exit so it makes sense.
Unfortunately there is no requirement for that to be the case.

If the thread whose tgid == tid happens to call pthread_exit the value
in ac_exitcode for that thread is pretty much undefined.

The ac_exitcode for the other threads would be the useless value of 0
that the field was initialized to.  With my change the value returned is
at least well defined.

But thread_group_leader in this context does nothing except limit the
value that is returned.

> I addressing ac_exitcode fits together with my patch, while increasing
> the version of taskstats helps clients that then can know that
> ac_exitcode now has a different meaning. Right now this is a change
> under the hood and you can just guess (or have to know from the kernel
> version).

As best as I can tell I did not change the meaning of the field.  I
change buggy code, and removed an arbitrary and senseless filter.

Now maybe it would have been better to flag the bug fix with a version
number.  Unfortunately I did not even realize taskstats had a version
number.  I just know the code made no sense.

Eric
