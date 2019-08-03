Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7B580390
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 02:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389626AbfHCApR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 20:45:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44549 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388048AbfHCApR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 20:45:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so78835039wrf.11;
        Fri, 02 Aug 2019 17:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2nPvXeiMRCbIp019RSfslQHC+wLOXTRda/OBXWWDLk=;
        b=O9jHmeinzFdk0HUuIlJYgzDWnzM0u/x89eydbjc0Ghqs9dQwrVClCrv9PxjAO+nOgc
         UOhhFPzo1owoGQIYIbwtLNbSohjjCktGzuHET0iRF2QA2d7mzBqYX5Lub0aXtTk7KCBH
         5Tq0YAeLRgjykjvHLZFq6LbX21DCzAx/ZZ6ZA72t94EC6LrZ2T3w8YHLFTvBlzdk1Fkv
         cMDYxoepav+xVwtYSk5C5gClah5xHmXVYLncS/ZqKkmiYw5QYMot3pnZtGB89pH8fGfi
         PpwhR1YAdNMBP6PvYzcU3lI6yYINT4r0v7cQ3Ml4rUX7CMXfAaqchh909fzszg+/c1D1
         YDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2nPvXeiMRCbIp019RSfslQHC+wLOXTRda/OBXWWDLk=;
        b=knFA99sDtWbxyE41VFtk1Hp0SgyUO/ZRfUa/c23maYcRN7zQcRhCMQPcakUZ70RW4f
         yMvGC1YMqpG7x7ifNPyp5w1Ax/iXleP6kWvrLPYY71J6I5QIPnjxQBRwz9acyShJMLrl
         TDldhyD2CSsXb1jR0Fg4RqzmlXjwfafytrHYkPb49g++07/EVsAuy14Tc3QWc+NREKBH
         hy3HwztlqD+Ei3ojR1rxsoRRH7vGcsi3kD/VWIJXo9/HGMp2uX6SJ86EtFmCOqAM2N1D
         hQqOd6GdHW5OsBHNkHo9mFM+pnETcdboTlzwC9lHAKtE+AUeJo97YRMvt3syUzWtszOf
         wEuQ==
X-Gm-Message-State: APjAAAVUfbEanzh2fJsrYi82JeKr6UwE6siKRpMpGGlfGrsDyyZalHUX
        t8vMmmlQmtE7CRsppHIJu5GnXiDNBeD2YUvkWllUdFAhfa0=
X-Google-Smtp-Source: APXvYqycYdpO8LrjkPFP5CxL4/LTWJJoR+m/XspgpFNdlVEJi3FOAxMCgZIZIQCoyJqzoMZul1a4qVtyziPxQ0M2MTA=
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr17510387wrt.124.1564793115204;
 Fri, 02 Aug 2019 17:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190702080123.904399496@linuxfoundation.org> <20190702080126.138655706@linuxfoundation.org>
 <0f105a3696611dc10aa4d7c5c22ffac031b3c098.camel@nokia.com>
 <20190802072834.GC26174@kroah.com> <88c88ec44e93c07170891bdf391d2b6251c7041a.camel@nokia.com>
In-Reply-To: <88c88ec44e93c07170891bdf391d2b6251c7041a.camel@nokia.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Aug 2019 08:45:03 +0800
Message-ID: <CADvbK_cOU00xqML35NMf3jk+S81kRLteHODf6Y-OsxPRDurSoQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 43/43] tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com" 
        <syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com>,
        "syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com" 
        <syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com>,
        "syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com" 
        <syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com>,
        "syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com" 
        <syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com" 
        <syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com" 
        <syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 7:03 PM Rantala, Tommi T. (Nokia - FI/Espoo)
<tommi.t.rantala@nokia.com> wrote:
>
> On Fri, 2019-08-02 at 09:28 +0200, gregkh@linuxfoundation.org wrote:
> > On Thu, Aug 01, 2019 at 10:17:30AM +0000, Rantala, Tommi T. (Nokia -
> > FI/Espoo) wrote:
> > > Hi,
> > >
> > > This tipc patch added in 4.14.132 is triggering a crash for me,
> > > revert
> > > fixes it.
> > >
> > > Anyone have ideas if some other commits missing in 4.14.x to make
> > > this
> > > work...?
> >
> > Do you also hav a problem with 4.19.y?  How about 5.2.y?  If not, can
> > you do 'git bisect' to find the patch that fixes the issue?
> >
> > thanks,
> >
> > greg k-h
>
> Hi, please pick this to 4.14.y and 4.19.y, tested that it fixes the
> crash in both:
>
> commit 5684abf7020dfc5f0b6ba1d68eda3663871fce52
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Mon Jun 17 21:34:13 2019 +0800
>
>     ip_tunnel: allow not to count pkts on tstats by setting skb's dev
> to NULL
Thanks Rantala,

sorry for late, I was in a trip.

The patch belongs to a patchset:

https://www.spinics.net/lists/netdev/msg578674.html

So this commit should also be included:

commit 6f6a8622057c92408930c31698394fae1557b188
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jun 17 21:34:14 2019 +0800

    ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL

Next time I think I should put "Fixes:" flag into each patch.

>
>
> For 5.2.y nothing is needed, these commits were in v5.2-rc6 already.
>
> -Tommi
>
