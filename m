Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A772965119C
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 19:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiLSSP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 13:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiLSSPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 13:15:24 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ADF13DCE
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 10:15:23 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BJIF4Ce015721
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 13:15:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671473706; bh=RPZcPeqiNQ/txvHn7bKkT7EcINFhNS0Qm6B4IweGX98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=NMYC7AA6LuGf8a6NW6qf8Pm3KhIx10BCL60vB2yDFeUEviJNykiDfB5bpRHnk17Qs
         5aZtm/ugMun8c4i1gr7EuLSC0fX9FQ7/7sstYQHVBEAxLqdMW6XZSR7e6zOJ+yNxg9
         0UnAzDQO94KhF1rp843GP1XkdmSu5+AvP8lb+38SOfEbMiN8oSW3abLuV6e5TGe8Jg
         M0T7KzUWXn8+Jf3kCvVryfP75Eo853NMheoooFmDMRlD+buKsgnP2Q25G9DTr5++ym
         BautrZUXd6IDlRak9kDYfCu5uo8cp3xO92SPN0iPsegzK0nvdnrAj2w8DfQ1iOdjH0
         4cM4iOpnO4yVA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id EA15E15C3511; Mon, 19 Dec 2022 13:15:03 -0500 (EST)
Date:   Mon, 19 Dec 2022 13:15:03 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     Lee Jones <lee@kernel.org>,
        syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Subject: Re: kernel BUG in ext4_free_blocks (2)
Message-ID: <Y6CqJ8fgQQW8AhT6@mit.edu>
References: <0000000000006c411605e2f127e5@google.com>
 <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu>
 <Y5xsIkpIznpObOJL@google.com>
 <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
 <Y5ylNxoN2p7dmcRD@mit.edu>
 <CANp29Y4QVp1G83pSqpxeETbw_+kQQ5CZUz+Vgi767WxE8AuhHQ@mail.gmail.com>
 <Y5y824gPqZo+vcxb@mit.edu>
 <CANp29Y4S0TTVjonA9ADpBKviNHR+n3nYi2hy2hcee-4ArD5t4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANp29Y4S0TTVjonA9ADpBKviNHR+n3nYi2hy2hcee-4ArD5t4Q@mail.gmail.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 05:12:47PM +0100, Aleksandr Nogikh wrote:
> (a) Once you have opened the bug report page, you can find the
> namespace at the top of the page.
> (b) One can at least see the list of the tested trees on the main page
> of the namespace -- we do share the latest commits for each manager
> instance. Also see the comment below.

It's not obvious what you mean by the "main page" of the namespace.
I'm guessing, but from the bug report page, there is a horizontal set
of icons, "Open", "Fixed", "Invalid" .... (which all have the same
icons), that the "Open" icon is the one that gets to the main page?

Assuming that this[1] is what was meant by "main page" (which is also
implied by the URL, but it's otherwise **really** not obvious), where
is the list of tested trees?

[1] https://syzkaller.appspot.com/android-5-10

I see the table "Instances", but it looks like the only two instances,
ci2-android-5-10 and ci2-android-5-10-perf, are both apparently
looking at the same commit --- but there's nothing that tells you what
kernel tree those commits are from.  I can't see **anything* that
looks like an explicit git repo URL plus branch name.  Is it perhaps
one of these?

https://android.googlesource.com/kernel/common/+/refs/heads/android12-5.10
https://android.googlesource.com/kernel/common/+/refs/heads/android13-5.10

It also appears that the android-5-10 "namespace" doesn't track any
other trees other than the Android 5.10 tree.  Which means the e-mail
message, "I can't find the commit on any tested tree" is ***super***
misleading.  At least for the android-5-10 namespace, why not just
say, "I don't see that commit on the git branch <explicit git repo and
branch name>"?

I did finally find the missing information, but it required a lot of
clicking and searching.  From the bug page [2], the status line is:

    Status: upstream: reported C repro on 2022/11/27 00:51

Has a link to the e-mail sent to the upstream developers[3].  And in
*that* e-mail, we can find the git tree involved: 

   git tree: android12-5.10-lts

[3] https://groups.google.com/g/syzkaller-android-bugs/c/LmaUwJpTXkA/m/HjsARFKWCQAJ


Going back to your pull request[4] to add a link to the dashboard in
the e-mail, how about also adding to the e-mail an indication about
the Syzkaller namespace.  That way, the upstream developer can quickly
determine that the namespace is "Android-X.Y" and simply hit the 'd'
key as not really relevant to the upstream developer.

[4] https://github.com/google/syzkaller/pull/3591

I assume that there's someone in the Android kernel ecosystem that is
responsible for figuring out how to make sure commits are backported
from upstream into the LTS kernels, and the LTS kernels to the
relevant Android branch.

I do know one thing for certain --- I don't scale to the point where
this can made my problem.  So I want to be able to more quickly triage
e-mails that are Not My Problem.

More generally, I think we need some kind of MAINTAINERS-like file
which explicitly lists who does have that responsibility, and which
can be used by Syzkaller so we aren't just blindly spamming all of the
upstream developers in the hopes that one of them will do somebody
else's job just to shut up the nag mail.  Otherwise, the natural
reaction will be to resort to a mail filter to /dev/null the nag mail.
:-/

					- Ted
