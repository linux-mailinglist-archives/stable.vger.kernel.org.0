Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D172651005
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiLSQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 11:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiLSQNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 11:13:00 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DAEA44A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 08:12:59 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id h26so9170257vsr.5
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 08:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NXAezGejVXbeBYBMQO1JPQhZlW10I7StHKj3XoiHdI4=;
        b=SuPVqQRPPitUqfamp29KTGLVOOk59vMZz2BCaqhNg1FnesGQEkoUFwas7Yua/eiVus
         +h66iu6YPQ9NWUhWMKTnDFHZ3RYaFB+P80Kl28MHXfWehW4i0MUE7H57i0eZ5iUZb5cR
         KX7BvK6kUwFYtmlNMUJn8JkCR5ldhIBVZJQ+pceC4wSWgekR2UKldlLo5h4EpOPNSdZ3
         snhb1+vjcD+ycdyD+3Y/2fl9YpVAcNlU4RN+gmhW0VaqPaUY7gnHHfju/sjGYJCi/LUD
         CD43ak4PTDrT95k2rDtw1ZcH49AvEk86PuFy3BGAUveaCLkFK98YpmkPwBlfULSnttm8
         5lIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXAezGejVXbeBYBMQO1JPQhZlW10I7StHKj3XoiHdI4=;
        b=H3LhrSh5BWVveNkmlPygCeX3aRrV+7Qfj9jwy//sFZYXypHBh8HyqveUm9DGIW64i8
         /4SvNzyFIQjZ0jAe1wMz6MQUhLxtKw0qoe/xt+uaqqZakf7V8jxgIhTCYtuHMpMusuUL
         Fr9XccHcCJzay+VUxKUd1fJvvKqjrF0gLx5TB8h4uNbHchstJMqj8S+4bueeZOogBaah
         K5ChQyK3qnTuIS1qNFPIUtksI97eDwDhVqviEcLwmHq0WwW3mOJj1zcyVaAcjBzJWiRC
         jP6ORE4vlU6LWH5o9k2yEAXEM1LYLhG6e0K+uVcdN8an9r2OOHzrluLrWoxRajF8mf1v
         EMnQ==
X-Gm-Message-State: ANoB5pmOLef1tETexk0v1B60+EzODloMznXb/09PHkdcQwrhO6W1SRh8
        1pVWl4IbKuGx+gLzRCb7UhK/JcW6MVTPlJfXO0g7Hg==
X-Google-Smtp-Source: AA0mqf514pBGNnaG/BN/e+1uhHfWKsrAbWKj1jIQMBBGK06O43m6F0yLA4yJf8gtzwCyJ56elG6reXjaAC6mO5ltxaE=
X-Received: by 2002:a05:6102:3c7:b0:3b1:38c5:d283 with SMTP id
 n7-20020a05610203c700b003b138c5d283mr14012498vsq.53.1671466378227; Mon, 19
 Dec 2022 08:12:58 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006c411605e2f127e5@google.com> <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu> <Y5xsIkpIznpObOJL@google.com> <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
 <Y5ylNxoN2p7dmcRD@mit.edu> <CANp29Y4QVp1G83pSqpxeETbw_+kQQ5CZUz+Vgi767WxE8AuhHQ@mail.gmail.com>
 <Y5y824gPqZo+vcxb@mit.edu>
In-Reply-To: <Y5y824gPqZo+vcxb@mit.edu>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Mon, 19 Dec 2022 17:12:47 +0100
Message-ID: <CANp29Y4S0TTVjonA9ADpBKviNHR+n3nYi2hy2hcee-4ArD5t4Q@mail.gmail.com>
Subject: Re: kernel BUG in ext4_free_blocks (2)
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Lee Jones <lee@kernel.org>,
        syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ted,

Thanks for the comments!

On Fri, Dec 16, 2022 at 7:45 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Fri, Dec 16, 2022 at 06:14:50PM +0100, Aleksandr Nogikh wrote:
> > > Thanks for the clarification; stupid question, though -- I see
> > > "upstream" is listed on the dashboard link above.  Assuming that
> > > "usptream" is "Linus's tree", why was it still saying, "I can't find
> > > this patch in any of my trees"?  What about the upstream tree?
> >
> > Bugs from different namespaces are treated independently, so in this
> > particular case syzbot was expecting the fixing commit to reach the
> > Android trees that it fuzzes.
>
> Is there a way someone can look at the dashboard link to determine
> which (a) what namespace a particular syzkaller report is in, and (b)
> what trees are included in a particular namespace?

(a) Once you have opened the bug report page, you can find the
namespace at the top of the page.
(b) One can at least see the list of the tested trees on the main page
of the namespace -- we do share the latest commits for each manager
instance. Also see the comment below.

>
> Adding a link to the e-mail to the dashboard page may not help if it's
> not obvious why the dashboard mentions "upstream" and yet it's not in
> "any of the trees".  Maybe the e-mail should explicitly list the trees
> that syzkaller will be searching?

I've sent a PR[1] that makes the bot send the list of the searched
trees. For upstream, we search quite a lot of trees, so the bot will
share some of them in the email and give a link to see the rest.
Otherwise the contents would be totally unintelligible.

[1] https://github.com/google/syzkaller/pull/3593

>
> And it would seem that it would be a *feature* if looking at a syzbot
> dashboard from Android namespace could expose the fact that particular
> patch is in any of the LTS trees or Linus's upstream tree, no?

Yes, that would be definitely nice.
We do have the improvements to the missing commit detection on our
TODO list, but I cannot say at the moment when exactly it will be
done.

>
> Also, what is the reason for Android for being in a separate
> namespace?  Is it running on a separate syzbot VM?  I can understand
> why from a feature perspective, that Fuschia and OpenBSD should be in
> separate namespaces; but what are the reasons that there are separate
> namespaces for Android versus the upstream kernel?  Especially since
> the Android dashboard is apparently referencing the upstream kernel?
> What's up with that?

It's based on Linux, but it's not exactly Linux and can have its own bugs.

>
> Put another way, while I think it's super useful to have a link to
> Syzbot dashboard page, in the e-mail, I'm not sure it's going to be a
> complete solution to the confusion that was inspired by this case.
>
> That being said, in general I think a link to the Dashboard is useful;
> in fact, it might be nice if we could encourage upstream developers
> put in the commit trailer:
>
> Link: https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c
>
> in addition to, or better yet, instead of:
>
> Reported-by: syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com
>
> ... and have Syzbot be able to translate from the Link: tag as being
> equivalent to the Reported-by: link.  That's becase the Link is going
> to be much more useful to humans than the Reported-by --- we've had a
> number of cases where as part of the patch review, we really wanted to
> get back to the Dashboard page, and it's not easy to get to the
> Dashboard from the Reported-by tag.

FWIW it's quite easy to get the Dashboard link from the Reported-by
tag (although I agree it's not the most intuitive thing imaginable) --
one just needs to substitute the hash code after the + sign to
https://syzkaller.appspot.com/bug?extid=%s

Re. the Link tag.. it's interesting. It doesn't seem to be very
reasonable to include both, as it would look somewhat excessive:

Reported-by: syzbot+abcdef012345678@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=abcdef012345678

I'll take a look into the pros and cons of using just the Link tag.

--
Aleksandr

>
> Thanks,
>
>                                                 - Ted
>
