Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48C34F47EC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347781AbiDEVXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447937AbiDEPrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:47:22 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D12BF8ED1
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 07:24:43 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:56694)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nbk6s-009yvT-AS; Tue, 05 Apr 2022 08:24:42 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:42426 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nbk6q-008FiW-9Z; Tue, 05 Apr 2022 08:24:41 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     keescook@chromium.org, willy@infradead.org, stable@vger.kernel.org
References: <164889939941112@kroah.com>
        <87mth0kfe4.fsf@email.froward.int.ebiederm.org>
        <YkvikRzy2ahCbGV6@kroah.com>
Date:   Tue, 05 Apr 2022 09:24:04 -0500
In-Reply-To: <YkvikRzy2ahCbGV6@kroah.com> (Greg KH's message of "Tue, 5 Apr
        2022 08:32:49 +0200")
Message-ID: <87y20jip6j.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nbk6q-008FiW-9Z;;;mid=<87y20jip6j.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Y9NQRq0YbqYNyzfM0rwGBat+UkoR32/Q=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1262 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.9 (0.4%), b_tie_ro: 3.4 (0.3%), parse: 1.07
        (0.1%), extract_message_metadata: 11 (0.9%), get_uri_detail_list: 2.1
        (0.2%), tests_pri_-1000: 11 (0.9%), tests_pri_-950: 1.04 (0.1%),
        tests_pri_-900: 0.81 (0.1%), tests_pri_-90: 982 (77.8%), check_bayes:
        980 (77.7%), b_tokenize: 5 (0.4%), b_tok_get_all: 7 (0.6%),
        b_comp_prob: 1.94 (0.2%), b_tok_touch_all: 962 (76.2%), b_finish: 0.79
        (0.1%), tests_pri_0: 239 (19.0%), check_dkim_signature: 0.37 (0.0%),
        check_dkim_adsp: 2.5 (0.2%), poll_dns_idle: 1.03 (0.1%), tests_pri_10:
        1.71 (0.1%), tests_pri_500: 6 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: FAILED: patch "[PATCH] coredump: Use the vma snapshot in
 fill_files_note" failed to apply to 5.17-stable tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Mon, Apr 04, 2022 at 11:00:19AM -0500, Eric W. Biederman wrote:
>> <gregkh@linuxfoundation.org> writes:
>> 
>> > The patch below does not apply to the 5.17-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> 
>> I believe it requires backporting these first.
>> 
>> commit 84158b7f6a06 ("coredump: Also dump first pages of non-executable ELF libraries")
>> commit 95c5436a4883 ("coredump: Snapshot the vmas in do_coredump")
>> commit 49c1866348f3 ("coredump: Remove the WARN_ON in dump_vma_snapshot")
>> 
>> The first is a more interesting bug fix from Jann Horn.
>> The other two are prerequisite cleanup-patches.
>
> Thanks, that worked!
>
>> I will let other folks judge how concerned they are about missing
>> locking that was detected by code review.
>
> locking where?  And if it's not resolved in Linus's tree yet, not much I
> can do.

Sorry for being unclear.  This patch "coredump: Use the vma snapshot in
fill_file_note" solves a problem of missing locking by refactoring code
so the locking is unnecessary.

> Also, what about for kernels older than 5.10?  Is this an issue there?

The first fix for missing/problematic locking was added in
commit a07279c9a8cd ("binfmt_elf, binfmt_elf_fdpic: use a VMA list
snapshot").  Which is 5.10.  I don't know if that fix has ever been backported.

The actual issue of problematic locking that this change was addressing
looks like it dates back to commit 2aa362c49c31 ("coredump: extend core
dump note section to contain file names of mapped files").


These are the kinds of bugs that creative people can use to get the
kernel to do things it is not supposed to do.  On an ordinary day no one
trips over so they are not a problem.  I am not good at assessing their
impact so I just fix them and let other people figure out how much they
want the fixes.

Eric
