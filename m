Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4505364ECA0
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 15:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLPOJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 09:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLPOJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 09:09:18 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14A02B620
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 06:09:16 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id q128so2326930vsa.13
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 06:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnRfmSoVrweCHiDP2b0XcKWHIVQTBT4Xkvqu5EsIIQ0=;
        b=VOwauKxPWCtAmTi3Wi1n4svZrbY1EFqlnEPgFCNRcge0fMzBZ4PPgHSZMe1lB0S47S
         W+eJaRe5NkVfzYfu1zXvThwENTXqsx40U+O8K0rMWmg3MaxgcP5EHS3t+ZoQKhU/J+C/
         Wp+eIcCdsTqgXxbkrBWkA3ssnd3cciVmALdtwQu1n40TDg1pupS5XEoNOIclfyjcstfw
         Db1iFNlwt1ujdTOFsGpC6COskmi2QiOHK+Y3WSGhO+X68RTW/QyPYhHsJnQ4WscNTKDw
         2tO19hncdHNAEtoatz2T7zTdvB6wyAJKbkOqMejJ8Qm7POyhANbF6/QHY34tqWneQekz
         TbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnRfmSoVrweCHiDP2b0XcKWHIVQTBT4Xkvqu5EsIIQ0=;
        b=8Ne5c5P7dSjibqIv98u0E0rSaqvi3c6x/jpjkJADUTR/1ruOu2SlagNiMy1j1Ofvau
         uaedP8z2zNHWif+/9LEHkCFJDX7dQhSRdZCob8gFLHROTPkSzL6pF+PzvLLWALzF/hf4
         B672z1WlU6/Sidul0jUDM3bqQ3fpmqMkQQfxcuP1lqA9vNQ5X6c+3+iHFUN7afG48Vjl
         aax6vWDNp0+IX335ChcOv1bC+nDWBNwmlLw/XwlGZ1ScQ26eecPMZJlHpa5kiE7EeJ/Y
         dX4mkuwygjyLoWwrEu/zEU2ytKivFLYMqzE4OmjjVrjXxXbIUp4ISHBwEd1JPX4aE8p4
         yxjw==
X-Gm-Message-State: ANoB5pn3rPwRtYJxayX4jxzXiuCMyT+wr7xGotAAm7woEtzeglTInHtC
        TQHTgdX300cwT/j4rAO7GqSvof37ZIhOvZLR8UHHIA==
X-Google-Smtp-Source: AA0mqf5juU3gdTbuCO9BuR51VBuKiOzXTXd5L1I41olQyxcEgnnVdsr0IFsJjjwuLnykSLE3YaQflJM0w+2POr9y134=
X-Received: by 2002:a67:be11:0:b0:3b1:27f1:ab21 with SMTP id
 x17-20020a67be11000000b003b127f1ab21mr18748024vsq.48.1671199755907; Fri, 16
 Dec 2022 06:09:15 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006c411605e2f127e5@google.com> <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu> <Y5xsIkpIznpObOJL@google.com>
In-Reply-To: <Y5xsIkpIznpObOJL@google.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Fri, 16 Dec 2022 15:09:04 +0100
Message-ID: <CANp29Y6KHBE-fpfJCXeN5Ju_qSOfUYAp2n+cNrGj25QtU0X=sA@mail.gmail.com>
Subject: Re: kernel BUG in ext4_free_blocks (2)
To:     Lee Jones <lee@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 2:01 PM Lee Jones <lee@kernel.org> wrote:
>
> On Thu, 15 Dec 2022, Theodore Ts'o wrote:
>
> > On Thu, Dec 15, 2022 at 08:34:35AM -0800, syzbot wrote:
> > > This bug is marked as fixed by commit:
> > > ext4: block range must be validated before use in ext4_mb_clear_bb()
> > > But I can't find it in any tested tree for more than 90 days.
> > > Is it a correct commit? Please update it by replying:
> > > #syz fix: exact-commit-title
> > > Until then the bug is still considered open and
> > > new crashes with the same signature are ignored.
> >
> > I don't know what is going on with syzkaller's commit detection, but
> > commit 1e1c2b86ef86 ("ext4: block range must be validated before use
> > in ext4_mb_clear_bb()") is an exact match for the commit title, and
> > it's been in the upstream kernel since v6.0.
> >
> > How do we make syzkaller accept this?  I'll try this again, but I
> > don't hold out much hope.
>
> I don't see the original bug report (was it posted to a lore
> associated list?), so there is no way to tell what branch syzbot was
> fuzzing at the time.  My assumption is that it was !Mainline.

Syzbot is actually reacting here to this bug from the Android namespace:

https://syzkaller.appspot.com/bug?id=3D5266d464285a03cee9dbfda7d2452a72c3c2=
ae7c

>
> Although this does appear to be a Stable candidate, I do not see it
> in any of the Stable branches yet.  So I suspect the answer here is to
> wait for the fix to filter down.
>
> In the mean time, I guess we should discuss whether syzbot should
> really be posting scans of downstream trees to upstream lists.

In this particular case, syzbot has captured all the recipients from
the patch email [1], because that email Cc'd
syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com. To syzbot, all
these people were involved in the original bug discussion, and so it
notified them about the problem.

FWIW I've sent a PR[2] to make the "I can't find it in any tested
tree" message include the link to the syzkaller dashboard. Hopefully
it will help resolve such confusions faster.

[1] https://lore.kernel.org/all/20220713185904.64138-1-tadeusz.struk@linaro=
.org/
[2] https://github.com/google/syzkaller/pull/3591

--
Aleksandr


>
> > #syz fix: ext4: block range must be validated before use in ext4_mb_cle=
ar_bb()
> >
> > Syzkaller, go home, you're drunk.
>
> =3D:-)
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-android-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-android-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-android-bugs/Y5xsIkpIznpObOJL%40google.com.
