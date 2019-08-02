Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93B17F53B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfHBKjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:39:52 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37833 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfHBKjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 06:39:52 -0400
Received: by mail-lf1-f65.google.com with SMTP id c9so52553450lfh.4;
        Fri, 02 Aug 2019 03:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5482PCZzUMFMKuxfVvg4Yev3g0GqmaJh0s8a2jYMhWU=;
        b=oEJYr5HtY21v/R0yUWUqTDOGxQ4aV+3YBib4fTTbtJ9LAsigZlma6ZgGrFk429vtTs
         8K6xXpykk661zyEbBcGOI1wahifn29OW21y14f8H6pZeB6Gglru5OLCBepG9BFgt28dN
         sH77qA8B59Vc9ZAb/dpiey2lmJbDl2NTzgDXoqgANURBQVCQE9U8e3RAF4RUoRerrfzC
         cGhHfrpE+e1Z43SpJanvXA2bWZr3wxJL+Bamm+fQ5dpH0H5swpLKyEcytkFSeViqktyO
         vf9+p4q2aYpiP4mduNmGwwvR3HfcHP8jdAvz+kQFiomUaBYinbXPTULM5O/CdBFqWdqw
         Bf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5482PCZzUMFMKuxfVvg4Yev3g0GqmaJh0s8a2jYMhWU=;
        b=IFoZcMECrCZrrnSK3Cy2lJeN66WHLjlkpyHMq7XRuQteUYwhRxFjlKrUE01KUn2d+p
         k0t0TRb3LLkR+AdmcLVAnqWwCXQGcnIowCTYBENfJz3QH/g4z5KmOfTfq6acMR4i2BvA
         glPTjhKOm81cKfClDRrWHf90ZsyZLf9kZ26jQGdksmmOXxHdddSFuo23pl/Nhzvg0ytd
         l5YWO3XJTcJLfjQbWEuK5E6PdzsgwRWSVCiew0wC/+O+YqqqSgO+5OXsDYOhDFtr2+n0
         wI9+xiZuT+q0Wio+uuTjOf036dhv5KVvZHuBX97nf/liTVgA2w/NkEwiDZLYSHh1PlCB
         kv6A==
X-Gm-Message-State: APjAAAUA36OLefjcSR5riKYi7VzhQvhBvz6bFU58opgCuScgBXJWfGtA
        RmL1VnCT3aHW4J7Pc9XPFH3RToOfJkT68BPm5sfeqm3+
X-Google-Smtp-Source: APXvYqyfHp5ss+YMsd9FBA/CWTPi5XIqr0RtlJ6Z2s+wPVY7vdlWXexjaMPryPpA5eC6RJi2x9ByMFoEKtCGCYcd8Z8=
X-Received: by 2002:a19:491d:: with SMTP id w29mr64758033lfa.149.1564742389620;
 Fri, 02 Aug 2019 03:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <259986242.BvXPX32bHu@devpool35> <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35> <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com>
In-Reply-To: <20190802103346.GA14255@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 2 Aug 2019 12:39:38 +0200
Message-ID: <CANiq72neLZLB5dKsqK8y=_JDNf=Ea07b_jYutBXJ8Y=kse1q8A@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Linux_4=2E9=2E180_build_fails_with_gcc_9_and_=27cleanu?=
        =?UTF-8?Q?p=5Fmodule=27_specifies_less_restrictive_attribute_than_its_targ?=
        =?UTF-8?Q?et_=E2=80=A6?=
To:     Greg KH <greg@kroah.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 12:33 PM Greg KH <greg@kroah.com> wrote:
>
> On Fri, Aug 02, 2019 at 12:19:33PM +0200, Miguel Ojeda wrote:
> > On Fri, Aug 2, 2019 at 10:17 AM Rolf Eike Beer <eb@emlix.com> wrote:
> > >
> > > Am Samstag, 8. Juni 2019, 14:00:34 CEST schrieb Miguel Ojeda:
> > > > On Thu, Jun 6, 2019 at 8:59 PM Greg KH <greg@kroah.com> wrote:
> > > > > "manually fixing it up" means "hacked it to pieces" to me, I have no
> > > > > idea what the end result really was :)
> > > > >
> > > > > If someone wants to send me some patches I can actually apply, that
> > > > > would be best...
> > > >
> > > > I will give it a go whenever I get some free time :)
> > >
> > > I fear this has never happened, did it?
> >
> > No. Between summer, holidays and a conference I didn't get to do it.
> >
> > Done the minimal approach here:
> >
> >   https://github.com/ojeda/linux/commits/compiler-attributes-backport
> >
> > Tested building a handful of drivers with gcc 4.6.4, 8.3.0 and 9.1.1.
> >
> > Greg, I could backport the entire compiler_attributes.h, but given
> > this is stable, we are supposed to minimize changes, right?
> >
> > I tried to imitate what you do in other stable patches, please check
> > the Cc:, Link: lines and the "commit ... upstream" just in case.
>
> If only those 2 patches are all that is needed, nice!  I'll gladly take
> them, can you send them to me (and cc: the stable list) in email so I
> can queue them up for the next round of releases after this one?

Done! Please double check, since I am not used to send to stable.

Cheers,
Miguel
