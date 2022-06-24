Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442CB559596
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 10:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiFXIl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 04:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiFXIl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 04:41:57 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C097274E71;
        Fri, 24 Jun 2022 01:41:53 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id j1so1656982vsj.12;
        Fri, 24 Jun 2022 01:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kh+bFKsPLC0kKcHvhl4no8XlenbVdD8SO39vxR1+nvU=;
        b=DZx0FBj7P2HcyjZmxPMi6ZXowsNytgZNWIzZGFgv+Pc7iKiLK2TcBi3BgS33Wnw59E
         A+93o9ZvfqleoowuV7aV1bCLvQP9ksjVf1aI1vVmh3CoTk9KuiphihSSiVN782y6TBAq
         +diSy2hNqzrzQCPUDIgOAhSXax/yRnZLMe+eNyXyqWdfVd/C3TXwjGIkdgECfgMvwHRc
         4/JIEw9f81eb02w6eIGiK5eFfmv971SjeUbq5a1tD3xQuVrZKYYJzs57U3EXJLBYuQOZ
         0QtM7VOOvGtAGvV4h7WDjEQ+8a0BoLZn8Ropu1vyru94VSt86CxxW7gwP05NfUrm9pTg
         0Jsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kh+bFKsPLC0kKcHvhl4no8XlenbVdD8SO39vxR1+nvU=;
        b=0AgY2KUTbo/Oo++c224iiy3VEV/sThDgqMMxZZAbREXdZ8eU+RQRSxIUxttfNEhfUj
         elbwOhfFT4WtrhSf9Zhww+vu9RiBQ2eUTZvLPYM3CZ7mxp534K5ZQhR/kRs18pvFyMUe
         OgDhJEPF32sNfwJfF6tI3IIYF80cCyS/tRE6EDwausfYIq8xdJUB493cPncFAQQs7c/S
         /707IeJ8deF0iWkxUrPVTW/FWvU3mFBssm/AZ/4nRL+8TDxxyHmBcFMvt2WPydGyEutx
         PI4EOqvoBmZPfUMPUX1ddmMPIGnEA2BX6fI0vAVEj2OTv1X1EqSEXF+7uz3GfY4kyKgf
         tszA==
X-Gm-Message-State: AJIora+vGCqCnj3K76lQGDGMekJi56JjkjLxusOGp6VGLFpeDT8HOcQs
        4iIkxZl74LzdmsT2eZyKWn5md6IewojibRHkCaY=
X-Google-Smtp-Source: AGRyM1u+z1hQZlCGZ38cicK8zZVrL70TOXyAEqbhAYoL+uS+zcg6utSbniBKWXU9nbVIcM34CJ2Vv6fw3AKQxKxdfxk=
X-Received: by 2002:a67:fa01:0:b0:354:3136:c62e with SMTP id
 i1-20020a67fa01000000b003543136c62emr13008834vsq.2.1656060112873; Fri, 24 Jun
 2022 01:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220511190213.831646-1-amir73il@gmail.com> <20220511190213.831646-3-amir73il@gmail.com>
 <CAOQ4uxj6wdsoVf7pyJWhoJ9mcNWf0eU_ARsXf6rH_nwpG1DJDg@mail.gmail.com>
 <YrDZ2YOeHkneW8+9@kroah.com> <CAOQ4uxiBHzFExCZowFNggn+woOz8vfwK=PZvAnVVBYHvjG-udQ@mail.gmail.com>
 <YrSQScmJ5C28cSt2@kroah.com>
In-Reply-To: <YrSQScmJ5C28cSt2@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 24 Jun 2022 11:41:41 +0300
Message-ID: <CAOQ4uxiOPVetJySp9=KTVOVy6ugbpNTgZ9zd6s9TX6BF-_EaAA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fsnotify: consistent behavior for parent not
 watching children
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 7:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 21, 2022 at 06:04:33AM +0300, Amir Goldstein wrote:
> > On Mon, Jun 20, 2022 at 11:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Jun 20, 2022 at 05:16:16PM +0300, Amir Goldstein wrote:
> > > > On Wed, May 11, 2022 at 10:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > The logic for handling events on child in groups that have a mark on
> > > > > the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
> > > > > duplicated in several places and inconsistent.
> > > > >
> > > > > Move the logic into the preparation of mark type iterator, so that the
> > > > > parent mark type will be excluded from all mark type iterations in that
> > > > > case.
> > > > >
> > > > > This results in several subtle changes of behavior, hopefully all
> > > > > desired changes of behavior, for example:
> > > > >
> > > > > - Group A has a mount mark with FS_MODIFY in mask
> > > > > - Group A has a mark with ignore mask that does not survive FS_MODIFY
> > > > >   and does not watch children on directory D.
> > > > > - Group B has a mark with FS_MODIFY in mask that does watch children
> > > > >   on directory D.
> > > > > - FS_MODIFY event on file D/foo should not clear the ignore mask of
> > > > >   group A, but before this change it does
> > > > >
> > > > > And if group A ignore mask was set to survive FS_MODIFY:
> > > > > - FS_MODIFY event on file D/foo should be reported to group A on account
> > > > >   of the mount mark, but before this change it is wrongly ignored
> > > > >
> > > > > Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
> > > > > Reported-by: Jan Kara <jack@suse.com>
> > > > > Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > >
> > > > Greg,
> > > >
> > > > FYI, this needs the previous commit to apply to 5.18.y:
> > >
> > > What is "this" here?  What git id?
> >
> > Sorry, this commit:
> >
> > > > e730558adffb fsnotify: consistent behavior for parent not watching children
> >
> > Needs this previous commit:
> >
> > > > 14362a254179 fsnotify: introduce mark type iterator
> >
> > > > They won't apply to earlier versions and this is a fix for a very minor bug
> > > > that existed forever, so no need to bother.
> > >
> > > So what exactly needs to be applied in what order and to what trees?
> > >
> >
> > To apply to 5.18.y.
>
> Now queued up, thanks.
>
> > Don't bother trying to apply either to earlier trees.
>
> So the Fixes: tag lied?  No wonder I was confused :)

No it hasn't lied.

The fix could be backported to an earlier kernel, but it is not trivial
and I don't think it is worth the effort, because the behavior of this
corner case was undefined for the entire lifetime of fanotify.

IOW, if stable scripts send me the message that the patch
does not apply cleanly, I won't be doing anything about it.

Furthermore, I instrumented the LTP regression test for this
bug with:

        if (tc->ignore && tst_kvercmp(5, 19, 0) < 0) {
                tst_res(TCONF, "ignored mask on parent dir has undefined "
                                "behavior on kernel < 5.19");
                return;
        }

So no one is going to be asking for this backport, unless they really
encounter the problem in real world use cases.

Thanks,
Amir.
