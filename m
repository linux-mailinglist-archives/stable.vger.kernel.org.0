Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA3ECD6
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 00:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfD2WhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 18:37:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37056 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729651AbfD2WhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 18:37:19 -0400
Received: by mail-lf1-f66.google.com with SMTP id h126so9283651lfh.4
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 15:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2dc72lRn+QYapuQ0yA9PTxioiCc/T7YC5XTZWj4UPk=;
        b=MHkjAOjJ1zlE288eNCi6RUf76K4Ap+c0kFui0qtM+27x6jAsGsBRKcWFtVY3ouRBia
         c0c4Ue2F9PtcCyie8kp3hAkzCNk86fly/TyN4EZWqMOulVg3ByZsGG8GXtKWTSoXilIP
         iGWIzyEcqm86bWKghFP2A0OFPzW06Bdb3lfiwBhOY2tqFql2K6VcpgdG3ZnMimp8+OUO
         /i3Y23FpPkTkX+pDZUXck5cPKuQysX9TQRJdl/QToK1phYA9+UETKkKe42ptZQOjlGMM
         WiP1G+I2n6VnccugZpUI5De/dHzAv1+iaXiJI8dWVKoFuw0rDuDL6SH4KwOBOd3bcDYq
         P9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2dc72lRn+QYapuQ0yA9PTxioiCc/T7YC5XTZWj4UPk=;
        b=qgLAkLt1fc7MH7s6fX4ikV77P16FuHXy72alcbiDQl+Lh5gb4ZKoBL33wVhRAEe/oz
         PVbVFwvHaPWSTII9nM3tRt0TSGLXAc5WfO4MqHtQMOROtmUIHeX62YFB9YECoYbteUWT
         qG7U9osj7/RXuKYhvvjosF6gwFq5Q23lMTfDDPBjdDoGYn8MS5fJ+DeIhBRMSTy2etoN
         qySNh0wvKwJAnIkFcjprNeGGrGD19Pe6NhsaUZfUYDATibJfbYg0R6nR1IEUrxOXI/Jk
         GtluPtPjlhm0WKC33el1nRZy+7ZBEDfWM4lgkuBuf34m/6Bo0bhSrQFvne6M2Z77cyy6
         hK7A==
X-Gm-Message-State: APjAAAX4pIszpXwmXBmjGTi9+lVT05KOvPb7YOhySS/hXvWvVe9Mf2c7
        bQ7hNCjHRxj3/pidbaV6lMz/8R2HPs8qUtURz9Fhp1uNtw==
X-Google-Smtp-Source: APXvYqyWufR/IKGaa7TNZVDs6IZzBW+yXtG00anJgANfJMC8ALjMgxbcJ9J8w83x7kZRKocksidJKfy0K6pdvI9LorM=
X-Received: by 2002:a19:7702:: with SMTP id s2mr35331595lfc.102.1556577436849;
 Mon, 29 Apr 2019 15:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190422210041.GA21711@archlinux-i9> <CAHC9VhTtz3OA3EchaZaAeg=DxoGoz_WFdj+Mi9nd9i+cmjmuJA@mail.gmail.com>
 <20190423132926.GK17719@sasha-vm> <CAHC9VhRcdY7G_ES2VqNVpkoU=CRJkJySb3m1sFdgKJwh3JQ2oA@mail.gmail.com>
 <20190429124002.GB31371@kroah.com> <CAHC9VhQxrtYJTOj=aOL4FY=myA4ZO-rcY7TdCeFbjVnCmgOxew@mail.gmail.com>
 <20190429140906.GA7412@kroah.com> <CAHC9VhRDoYd=vfz3Sm8NKpMW_QoX7t_VohumUxU5i6AjTwCRyQ@mail.gmail.com>
 <20190429145248.GA7111@kroah.com>
In-Reply-To: <20190429145248.GA7111@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 29 Apr 2019 18:37:03 -0400
Message-ID: <CAHC9VhQNdSLfZK6QD1WnCzhdpa9NyjzrDwMks7SKgtuc6+5JgA@mail.gmail.com>
Subject: Re: scripts/selinux build error in 4.14 after glibc update
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss@m4x.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 29, 2019 at 10:47:00AM -0400, Paul Moore wrote:
> > On Mon, Apr 29, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Mon, Apr 29, 2019 at 10:02:29AM -0400, Paul Moore wrote:
> > > > On Mon, Apr 29, 2019 at 8:40 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > On Tue, Apr 23, 2019 at 09:43:09AM -0400, Paul Moore wrote:
> > > > > > On Tue, Apr 23, 2019 at 9:29 AM Sasha Levin <sashal@kernel.org> wrote:
> > > > > > > On Mon, Apr 22, 2019 at 09:59:47PM -0400, Paul Moore wrote:
> > > > > > > >On Mon, Apr 22, 2019 at 5:00 PM Nathan Chancellor
> > > > > > > ><natechancellor@gmail.com> wrote:
> > > > > > > >> Hi all,
> > > > > > > >>
> > > > > > > >> After a glibc update to 2.29, my 4.14 builds started failing like so:
> > > > > > > >
> > > > > > > >...
> > > > > > > >
> > > > > > > >>   HOSTCC  scripts/selinux/genheaders/genheaders
> > > > > > > >> In file included from scripts/selinux/genheaders/genheaders.c:19:
> > > > > > > >> ./security/selinux/include/classmap.h:245:2: error: #error New address family defined, please update secclass_map.
> > > > > > > >>  #error New address family defined, please update secclass_map.
> > > > > > > >>   ^~~~~
> > > > > > > >
> > > > > > > >This is a known problem that has a fix in the selinux/next branch and
> > > > > > > >will be going up to Linus during the next merge window.  The fix is
> > > > > > > >quite small and should be relatively easy for you to backport to your
> > > > > > > >kernel build if you are interested; the patch can be found at the
> > > > > > > >archive link below:
> > > > > > > >
> > > > > > > >https://lore.kernel.org/selinux/20190225005528.28371-1-paulo@paulo.ac
> > > > > > >
> > > > > > > Why is it waiting for the next merge window? It fixes a build bug that
> > > > > > > people hit.
> > > > > >
> > > > > > I place a reasonably high bar on patches that I send up to Linus
> > > > > > outside of the merge window and I didn't feel this patch met that
> > > > > > criteria.  Nathan is only the second person I've seen who has
> > > > > > encountered this problem, the first being the original patch author.
> > > > > > As far as I've seen, the problem is only seen by users building older
> > > > > > kernels on very new userspaces (e.g. glibc v2.29 was released in
> > > > > > February 2019, Linux v4.14 was released in 2017); this doesn't appear
> > > > > > to be a large group of people and I didn't want to risk breaking the
> > > > > > main kernel tree during the -rcX phase for such a small group.
> > > > >
> > > > > Ugh, this breaks my local builds, I would recommend getting it to Linus
> > > > > sooner please.
> > > >
> > > > Well, we are at -rc7 right now and it looks like an -rc8 is unlikely
> > > > so the question really comes down to can/do you want to wait a week?
> > >
> > > It's a regression in the 5.1-rc tree, that is hitting people now.  Why
> > > do you want to have a 5.1-final that is known to be broken?
> >
> > I believe I answered that in my reply to Sasha.  Can you answer the
> > question I asked of you above?
>
> If you don't submit it this week, I guess I can wait as I have no other
> choice.
>
> But note, this did break my build systems, and my main development
> system this weekend.  So yes, the number of people being affected might
> be "small", but that "small" number includes the people responsible for
> maintaining those stable kernels :(
>
> Anyway, it's your call, just letting you know I'm really annoyed at the
> moment by this...

It's against my better judgement, but I'll send a PR up to Linus now.

-- 
paul moore
www.paul-moore.com
