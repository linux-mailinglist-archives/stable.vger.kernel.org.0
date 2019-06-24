Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4961A500D7
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 06:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfFXEwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 00:52:24 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36999 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFXEwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 00:52:24 -0400
Received: by mail-yb1-f196.google.com with SMTP id 189so5231986ybh.4;
        Sun, 23 Jun 2019 21:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxIiZU+7r8Cu/qKtSFv+Ru1JRgd24V/4BLiVHwftvOw=;
        b=JUs0OICD2tB/RSrD6/PCjhwWDQeuWK5E6fITecldhUdBXV+uuhxXSovFjI6g18Hfnt
         Ni6tz4Fp6HF6OaY3NVyfjvzhwnm4o6fkDNzYnuJnnE2VD13I06ARouZAdSvmlNEjeLkM
         9Bnogv3p9JLTNO4C/eAGVLFghNgAEVOicG7xAi9VT1lHRxWeZnVoaLeFaZwuy3IE80kd
         a2YRxIbK0Sj3DddZSjd1/Vz/OUeQecssJi+C+I+0AreTq77FFGM6bbUR6nSM+xHlLoB1
         PyFB5Ltvfb2JZ+GbN/UiJfAkw+EiK2GdYpxuKjChndLBt5vwNrlCyZNFci5350MBQW9I
         6mlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxIiZU+7r8Cu/qKtSFv+Ru1JRgd24V/4BLiVHwftvOw=;
        b=Hw5lSjqv1RolqXEqYSKjEvBOElvaWl4/up2WkzHf7x0OhMoOZcgQHbqAxDG1V6l7PD
         4qo6xe2CFmpgMdcoPpoFzl5QJP1SNVqIPoEINUxSGVLUDqepcUkYqKS8VaHdvAveLCYQ
         O0C9QAFUbDFtnGVi4EtaNL0W9NmzDj2ksOAEbea4Gv5mapnNGyI15y+FLEn/O/hmimu7
         FZgER67KZEdQOoL75xcjMbZllfDiJ1U2tAz7u/zEyVadcowLn5EctPO1ThiYgYO8h8lN
         mLiQywqbGTFibyyhBuTgzCYOiK9edYN0MhDRIHCJn2zjLjVAXjWAJMXPLqqMZxlw3uDt
         Ek9A==
X-Gm-Message-State: APjAAAXAbMpOk99pXeKsH3f3jnEmNzubrDbBBslYRQ9KXYyMuDV1mJZw
        WEnMfGMQjdTqddlB0Y/xj789sP3d5g0B0dnHOmM=
X-Google-Smtp-Source: APXvYqwP6eLeklvT+YewIEHkGrS7r2UZ39+abhFXurFtn2myMvZbDWLcSpDN7Cxp+GhwZLgJ7M3Ry1U33rq1eu4IUDQ=
X-Received: by 2002:a25:744b:: with SMTP id p72mr2669029ybc.439.1561351943407;
 Sun, 23 Jun 2019 21:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <1560073529193139@kroah.com> <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
 <20190623010345.GJ2226@sasha-vm> <20190623202916.GA10957@kroah.com> <20190624003409.GO2226@sasha-vm>
In-Reply-To: <20190624003409.GO2226@sasha-vm>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Jun 2019 07:52:11 +0300
Message-ID: <CAOQ4uxiz5CkGojr5yquUd__TS_eae+ZapqyGaojiOUGniFPMsg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 3:34 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, Jun 23, 2019 at 10:29:16PM +0200, Greg KH wrote:
> >On Sat, Jun 22, 2019 at 09:03:45PM -0400, Sasha Levin wrote:
> >> On Fri, Jun 21, 2019 at 11:15:47AM +0300, Amir Goldstein wrote:
> >> > On Thu, Jun 13, 2019 at 11:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >> > >
> >> > > On Sun, Jun 9, 2019 at 12:45 PM <gregkh@linuxfoundation.org> wrote:
> >> > > >
> >> > > >
> >> > > > The patch below does not apply to the 5.1-stable tree.
> >> > > > If someone wants it applied there, or to any other stable or longterm
> >> > > > tree, then please email the backport, including the original git commit
> >> > > > id to <stable@vger.kernel.org>.
> >> > > >
> >> > > > thanks,
> >> > > >
> >> > > > greg k-h
> >> > > >
> >> > >
> >> > > FYI, the failure to apply this patch would be resolved after you
> >> > > picked up "ovl: check the capability before cred overridden" for
> >> > > stable, please hold off from taking this patch just yet, because
> >> > > it has a bug, whose fix wasn't picked upstream yet.
> >> > >
> >> >
> >> > Greg,
> >> >
> >> > Please apply these patches to stable 4.19.
> >> > They fix a docker regression (project quotas feature).
> >> >
> >> > b21d9c435f93 ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
> >> > 941d935ac763 ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls
> >> >
> >> > They apply cleanly and tested on v4.19.53.
> >>
> >> I've queued these for 4.19.
> >>
> >> > While at it, I also tested that the following patches apply cleanly and solve
> >> > relevant issues on v4.19.53, but they are not clear stable candidates.
> >> >
> >> > 1) /proc/locks shows incorrect ino. Only reported by xfstests (so far):
> >> > 6dde1e42f497 ovl: make i_ino consistent with st_ino in more cases
> >>
> >> And this.
> >>
> >> > 2) Fix output of `modinfo overlay`:
> >> > 253e74833911 ovl: fix typo in MODULE_PARM_DESC
> >>
> >> But not this one. Maybe we should be including these in stable trees
> >> since the risk factor is low and it fixes something user-visible, but
> >> our current rules object this this kind of patches so I've left it out.
> >>
> >> > 3) Disallow bogus layer combinations.
> >> > syzbot has started to produce repros that create bogus layer combinations.
> >> > So far it has only been able to reproduce a WARN_ON, which has already
> >> > been fixed in stable, by  acf3062a7e1c ("ovl: relax WARN_ON()..."), but
> >> > other real bugs could be lurking if those setups are allowed.
> >> > We decided to detect and error on these setups on mount, to stop syzbot
> >> > (and attackers) from trying to attack overlayfs this way.
> >> > To stop syzbot from mutating this class of repros on stable kernel you
> >> > MAY apply these 3 patches, but in any case, I would wait a while to see
> >> > if more bugs are reported on master.
> >> > Although this solves a problem dating before 4.19, I have no plans
> >> > of backporting these patches further back.
> >> >
> >> > 146d62e5a586 ovl: detect overlapping layers
> >> > 9179c21dc6ed ovl: don't fail with disconnected lower NFS
> >> > 1dac6f5b0ed2 ovl: fix bogus -Wmaybe-unitialized warning
> >>
> >> I've queued these 3 for 4.19.
> >
> >What about the ones that are needed for 5.1?
>
> Ah yes, I haven't realized that the syzkaller ones are needed for 5.1.
> I'll queue them up.
>

I don't think syzkaller ones are more relevant to 5.1 then the rest of
the patches applied to 4.19. If anything, its the other way around.
According to syzbot dashboard, it is being run on LTS kernels, not on
latest stable.

Please forgive me if my language caused confusion, when I said
"please apply to 4.19" I meant 4.19+.

Thanks,
Amir.
