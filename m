Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28166205A92
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 20:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgFWS2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 14:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733178AbgFWS2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 14:28:43 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3704C061795
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 11:28:42 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u25so12253123lfm.1
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 11:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MIC7rinwx2pMi5XBt1XaWunZWpw6bdSnQpQcCkwHcik=;
        b=Bk10in67hNn+fw+1MYYqorcFjKBXPYfNMNIM1ld8uUTWo2J40PtAxEyYxjXMXaGhhk
         gdQNLj0ZytPLg+GFFaD6ypHNMiYxY0czOKXBb1sjiD15ZRc2AVk+0oqEbpjI02rLzZ9R
         pWfryzDHXcMjkVPLozPUTOmlBRlUGuMLbHRG/0/hKOW8M3pE+srQjRyjgq5GRIL/EiVQ
         ptfzQ7H1F4tUY0Rh27vCRhlyL/sPNq3IKVVGu9mDdn/ofJ0JcFL0eAHxvNdKEl53PfPh
         3t7HE9X6XrpkVtufxAYJB5MjmQKO14xcMNSrdYYbJ3jLOdlMAHVhvsPHMRztMCIUjwMH
         C6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MIC7rinwx2pMi5XBt1XaWunZWpw6bdSnQpQcCkwHcik=;
        b=YBR8EbRG7XOS0g/lYlMqGpoay11c2V67ps2WdSPr5Wh/AUv87fL2vPSqvodsNVSJkE
         4Lei/zz/fb08ycORgRn4ZEGarJtPmcQAaMycMEv2IWfyAaU+iC5VC2EaqcwR5genUZUd
         wcceL5SZxuj6d8Jyc4hy2yxTqcI8ZQyjzYSm2+QO2zJuDNJ+Sj+0V86XeMwvaGtvve+v
         /b4HDDjijambg4RFCxuY7P08KEtL0eHPzZJr3OG59KWd83XReKa0piklePpciJPc+pNw
         6k/ewrQrOSsBZRsoBm8jZE87gT4jtNgCNQJm7tI2PUx3jbIrrtH7cCZS/IQpkGl6uDQP
         ZStw==
X-Gm-Message-State: AOAM5333OjRt883/L4GiQs2E0pJAIzyxSYXO68/g3xyRoZf2zWUt9p0h
        XVpY/xFlqKoAi9YSm5k+C9MyUwvXxty4mC+z9jkeig==
X-Google-Smtp-Source: ABdhPJwyll2wtyv9RPvruQ+2iQWzC1zZIRIhfCyFwYgQq7Y56Isr4RiHgDGF7CcywkpKW2DafMGF5zUcZBt/EoRxVlI=
X-Received: by 2002:ac2:5226:: with SMTP id i6mr13425420lfl.55.1592936921054;
 Tue, 23 Jun 2020 11:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200618012600.608744-1-sashal@kernel.org> <20200618012600.608744-90-sashal@kernel.org>
 <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com> <20200623171613.GB1931@sasha-vm>
In-Reply-To: <20200623171613.GB1931@sasha-vm>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Jun 2020 23:58:29 +0530
Message-ID: <CA+G9fYsqV9+QaBgWrJEf8QDT4LobO5vuA0i+AB0h6SyiCGmwhw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 090/108] ovl: verify permissions in ovl_path_open()
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jun 2020 at 22:46, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Jun 23, 2020 at 08:55:38PM +0530, Naresh Kamboju wrote:
> >On Thu, 18 Jun 2020 at 07:18, Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> From: Miklos Szeredi <mszeredi@redhat.com>
> >>
> >> [ Upstream commit 56230d956739b9cb1cbde439d76227d77979a04d ]
> >>
> >> Check permission before opening a real file.
> >>
> >> ovl_path_open() is used by readdir and copy-up routines.
> >>
> >> ovl_permission() theoretically already checked copy up permissions, but it
> >> doesn't hurt to re-do these checks during the actual copy-up.
> >>
> >> For directory reading ovl_permission() only checks access to topmost
> >> underlying layer.  Readdir on a merged directory accesses layers below the
> >> topmost one as well.  Permission wasn't checked for these layers.
> >>
> >> Note: modifying ovl_permission() to perform this check would be far more
> >> complex and hence more bug prone.  The result is less precise permissions
> >> returned in access(2).  If this turns out to be an issue, we can revisit
> >> this bug.
> >>
> >> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>  fs/overlayfs/util.c | 27 ++++++++++++++++++++++++++-
> >>  1 file changed, 26 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> >> index afdc2533ce74..76d6610767f6 100644
> >> --- a/fs/overlayfs/util.c
> >> +++ b/fs/overlayfs/util.c
> >> @@ -307,7 +307,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
> >>
> >>  struct file *ovl_path_open(struct path *path, int flags)
> >>  {
> >> -       return dentry_open(path, flags | O_NOATIME, current_cred());
> >> +       struct inode *inode = d_inode(path->dentry);
> >> +       int err, acc_mode;
> >> +
> >> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
> >> +               BUG();
> >> +
> >> +       switch (flags & O_ACCMODE) {
> >> +       case O_RDONLY:
> >> +               acc_mode = MAY_READ;
> >> +               break;
> >> +       case O_WRONLY:
> >> +               acc_mode = MAY_WRITE;
> >> +               break;
> >> +       default:
> >> +               BUG();
> >
> >This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14.
> >
> >steps to reproduce:
> >          - cd /opt/ltp
> >          - ./runltp -s execveat03
>
> Yup, that patch has been dropped, thanks for testing!

After reverting this patch I see these messages while testing LTP execveat03.
[ 87.931537] overlayfs: upper fs does not support RENAME_WHITEOUT.
[ 87.937693] overlayfs: upper fs does not support xattr, falling back
to index=off and metacopy=off.>

- Naresh

> --
> Thanks,
> Sasha
