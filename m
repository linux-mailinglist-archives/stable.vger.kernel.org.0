Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55E3205B55
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 21:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbgFWTAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 15:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733138AbgFWTAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 15:00:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0920BC061573;
        Tue, 23 Jun 2020 12:00:00 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s18so25081375ioe.2;
        Tue, 23 Jun 2020 12:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGUbgEtgaxHsjcsrQ07UW1rqk8aoviYgJaSln1LGDd0=;
        b=HcSZen6NZMo6UPk9m4aZ+F0OquDp5o5fonlig3Y+Iisv31CZGb5X3JWXUoNMdREqXH
         5TrcZ8PrlMwTz79F2u/OYjsF3cghwU4+zC7hbTjGBDJfN4cI4FFkBvAvYt4WjieY5xmA
         qwdQu1DeyFQxZI5lyKJVAYoEK26G7otKLvm8kJ9cEUhWOf5FuFdVl+9Elmvf/+xZco2D
         frh5UCjiZx3tYi+/mptW0vOFJm62yCZe+kipnlLVEGctF28A/tBi1OJib084pSUbFmcH
         gxKYmD6SX+u24fQciOegp4Q1zGyuwh6huBJphVPQm6R22u3xye4bnilKCO8u5dz1RhSS
         ZYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGUbgEtgaxHsjcsrQ07UW1rqk8aoviYgJaSln1LGDd0=;
        b=jmqQeXeL/xgDLrBtVpDDKpvGPmb1vayVbLR1FYtsvVbY6OT3KqEFbEVd9B44YjVdLP
         Hw0sr4CGxUStgv/w++nTft1zYEM7L3ZhRvHJiaMhP3e2qGTegxYB5sYk0CMfhToeLJkA
         R9HVbhbCy6PaoXZiAZ6fYzEZWdhobGrjbugXcmJar6eGT91mcXTIY8M9UUOybH3O2vkm
         HdPGijzwdHXvjVRUIlLgTgrpWqV2uDRmWMF0NP6gTpXycxPc8t3DDVhux1dxLC1sZCcM
         TU/DN7HUXje2b+ZIzpOy6xuO91Q+vQ6ZNnFKgZmENo9SHI3BkKPl+SMLUomkSjtTjW+O
         QlgA==
X-Gm-Message-State: AOAM533DzobI8q/RwScp9pJJ+guoRD7eCBydvAbhWLeT6TFcT9/bk18Y
        6N/5BcqHqsHosVigKuVTwSRhsSP0uEBoaEka5vM=
X-Google-Smtp-Source: ABdhPJwL5VLoYwmYCAC+c5kK726ih+QDfSbJxYCpUWbnFr4YW1zruh8hdkUj3rA+fuaf6zfn9dm7HYnWLxMdid4t0LM=
X-Received: by 2002:a05:6602:14d0:: with SMTP id b16mr27168111iow.5.1592938799295;
 Tue, 23 Jun 2020 11:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200618012600.608744-1-sashal@kernel.org> <20200618012600.608744-90-sashal@kernel.org>
 <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com>
 <20200623171613.GB1931@sasha-vm> <CA+G9fYsqV9+QaBgWrJEf8QDT4LobO5vuA0i+AB0h6SyiCGmwhw@mail.gmail.com>
In-Reply-To: <CA+G9fYsqV9+QaBgWrJEf8QDT4LobO5vuA0i+AB0h6SyiCGmwhw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 23 Jun 2020 21:59:48 +0300
Message-ID: <CAOQ4uxh9q_yQm9La2b3xYPqD9GPCHm8Gd+Ldi5HjVVD4NTOttA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 090/108] ovl: verify permissions in ovl_path_open()
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 9:28 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Tue, 23 Jun 2020 at 22:46, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Tue, Jun 23, 2020 at 08:55:38PM +0530, Naresh Kamboju wrote:
> > >On Thu, 18 Jun 2020 at 07:18, Sasha Levin <sashal@kernel.org> wrote:
> > >>
> > >> From: Miklos Szeredi <mszeredi@redhat.com>
> > >>
> > >> [ Upstream commit 56230d956739b9cb1cbde439d76227d77979a04d ]
> > >>
> > >> Check permission before opening a real file.
> > >>
> > >> ovl_path_open() is used by readdir and copy-up routines.
> > >>
> > >> ovl_permission() theoretically already checked copy up permissions, but it
> > >> doesn't hurt to re-do these checks during the actual copy-up.
> > >>
> > >> For directory reading ovl_permission() only checks access to topmost
> > >> underlying layer.  Readdir on a merged directory accesses layers below the
> > >> topmost one as well.  Permission wasn't checked for these layers.
> > >>
> > >> Note: modifying ovl_permission() to perform this check would be far more
> > >> complex and hence more bug prone.  The result is less precise permissions
> > >> returned in access(2).  If this turns out to be an issue, we can revisit
> > >> this bug.
> > >>
> > >> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> > >> ---
> > >>  fs/overlayfs/util.c | 27 ++++++++++++++++++++++++++-
> > >>  1 file changed, 26 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > >> index afdc2533ce74..76d6610767f6 100644
> > >> --- a/fs/overlayfs/util.c
> > >> +++ b/fs/overlayfs/util.c
> > >> @@ -307,7 +307,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
> > >>
> > >>  struct file *ovl_path_open(struct path *path, int flags)
> > >>  {
> > >> -       return dentry_open(path, flags | O_NOATIME, current_cred());
> > >> +       struct inode *inode = d_inode(path->dentry);
> > >> +       int err, acc_mode;
> > >> +
> > >> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
> > >> +               BUG();
> > >> +
> > >> +       switch (flags & O_ACCMODE) {
> > >> +       case O_RDONLY:
> > >> +               acc_mode = MAY_READ;
> > >> +               break;
> > >> +       case O_WRONLY:
> > >> +               acc_mode = MAY_WRITE;
> > >> +               break;
> > >> +       default:
> > >> +               BUG();
> > >
> > >This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14.
> > >
> > >steps to reproduce:
> > >          - cd /opt/ltp
> > >          - ./runltp -s execveat03
> >
> > Yup, that patch has been dropped, thanks for testing!
>
> After reverting this patch I see these messages while testing LTP execveat03.
> [ 87.931537] overlayfs: upper fs does not support RENAME_WHITEOUT.

This warning is new.

> [ 87.937693] overlayfs: upper fs does not support xattr, falling back
> to index=off and metacopy=off.>

This one is pretty old.

They will show up when testing with a filesystem that is suboptimal
for upper fs.

The warning is stating a fact. The suboptimal behavior with those
filesystems has been there since the beginning.

Thanks,
Amir.
