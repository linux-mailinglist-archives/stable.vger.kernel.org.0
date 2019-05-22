Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4FA25B3A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 02:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfEVAoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 20:44:32 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39127 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfEVAoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 20:44:32 -0400
Received: by mail-io1-f67.google.com with SMTP id m7so458149ioa.6;
        Tue, 21 May 2019 17:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pWCi9dROwOfQvBvMAXELot1dHsDW9NHuGvLhfRnJ4hE=;
        b=SfSWg9TeEu5DaP5TRGUM57CeTAi++dYX546ZT6YQE1GsntXdrEm80yuE3lgKb5R7hI
         Fxj0EWfVmZFdIz8GxjIpdKO+gtBRBBpLtejZBPnrYL4gZejAh01OTXkKGk/ZWOeJLhY8
         m9Z/pj1g6xv1c9tejcJjP4HFwp95EFIKLcOYDRyJJc9vGNOwoUSBjFmxy2yQhSuxRFtN
         Zn4kg3aVuL+lM2Ze13lYlR3bhDPX3FhOB4iHPIKyVjkp6s0epY1/DyCUykGga/I3dBQF
         e/JRdL3Vnx1SzeCcS2pZWHSjgpOXNUuUfCaPb7wutTP5guOmTphZc8f0CzptOO3mDluX
         dUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pWCi9dROwOfQvBvMAXELot1dHsDW9NHuGvLhfRnJ4hE=;
        b=KnwN1q0ZrpQAN/B9St6PAjwRklU1+P8tGId/kwAhhJ37AP2mtGWdk8GDEp0w/BRRi6
         Hv7yRKgzG23WRs+bJuOb5fqxL8264PKgACABrw+/pIHIOKRk6bw6HxnwhnHpcHCGEHzb
         PJsMnvJOa176nRlA3ERaIr8H66SF4Uc92p4wQNsmi2Uq8Rg5eiabaDjFEoTD+hGllOxd
         +wdzkVxwDNgQAzg5wZPSP2i5x51MVZ60voRQ7aS8F4wuQz5iYsPMTat478oIWzug9HD1
         7j/58rFR3kNSFrZ5mbqgte7EbcphrizWyfi1ntiZAeZKyWwtztJzaNJOI19ewLE26AWm
         IfCA==
X-Gm-Message-State: APjAAAUUwbxpgrUJgXIbaVBSsNESNd4+FAoFCPfimDxV5JsjHtX9+snu
        Q5HuwPecsGXYZ7QlrTz5S4GplmKUvz2OPUa75Bk=
X-Google-Smtp-Source: APXvYqxUpoov/lRK+3Nk9QPmCfxT+tSQOmPVQFA6wQLCtgq80Rq1EUYHAzQ+cZQrAKyBAe/Hzp+PszAlQTvkghjq1Lc=
X-Received: by 2002:a5e:840c:: with SMTP id h12mr6278956ioj.81.1558485871505;
 Tue, 21 May 2019 17:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190507043954.9020-1-deepa.kernel@gmail.com> <20190521092551.fwtb6recko3tahwj@dcvr>
 <20190521152748.6b4cd70cf83a1183caa6aae7@linux-foundation.org>
 <20190521233319.GA17957@dcvr> <CABeXuvoOGwOGmSz_vgTugLD1NPE=2ULvmESPTtK9d6r8S+WVdQ@mail.gmail.com>
In-Reply-To: <CABeXuvoOGwOGmSz_vgTugLD1NPE=2ULvmESPTtK9d6r8S+WVdQ@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 21 May 2019 17:44:19 -0700
Message-ID: <CABeXuvrT-mHomeH-CnuLsWzNCQOfymW01s+HGRaBTNA+u2t28w@mail.gmail.com>
Subject: Re: [PATCH 1/1] signal: Adjust error codes according to restore_user_sigmask()
To:     Eric Wong <e@80x24.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 5:35 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> > > > It's been 2 weeks and this fix hasn't appeared in mmots / mmotm.
> > > > I also noticed it's missing Cc: for stable@ (below)
> > >
> > > Why is a -stable backport needed?  I see some talk above about lost
> > > signals but it is unclear whether these are being observed after fixing
> > > the regression caused by 854a6ed56839a.
> >
> > I guess Deepa's commit messages wasn't clear...
> > I suggest prepending this as the first paragraph to Deepa's
> > original message:
> >
> >   This fixes a bug introduced with 854a6ed56839a which caused
> >   EINTR to not be reported to userspace on epoll_pwait.  Failure
> >   to report EINTR to userspace caused problems with user code
> >   which relies on EINTR to run signal handlers.
>
> This is not what the patch fixed.
>
> The notable change is userspace is that now whenever a signal is
> delivered, the return value is adjusted to reflect the signal
> delivery.
> Prior to this patch, there was a window, however small it might have
> been, when the signal was delivered but the errono was not adjusted
> appropriately.
> This is because of the regression caused by 854a6ed56839a, which
> extended the window of delivery of signals that was delivered to
> userspace.
> The patch also fixes more than sys_epoll_pwait().
>
> I will post a follow up patch.
>
> >
> > > IOW, can we please have a changelog which has a clear and complete
> > > description of the user-visible effects of the change.
> > >
> > > And please Cc Oleg.
>
> I will cc Oleg.

Also the commit message was brief because the issue was explained in
the link that was quoted in the commit message.

Detailed issue discussion permalink:
https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/

-Deepa
