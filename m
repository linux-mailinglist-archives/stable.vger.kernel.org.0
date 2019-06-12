Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357BA42A29
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 17:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbfFLPBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 11:01:47 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41711 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfFLPBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 11:01:46 -0400
Received: by mail-lf1-f68.google.com with SMTP id 136so12386126lfa.8
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 08:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HHCDrti6hZOHHFd1mpKnLx73brcB9mCERSd3hAVv5pE=;
        b=KkwQ3OChlT1SGhZHjb9KzgGArXdQ0Dq/std7lS1DpML+cI6hpP/WBT4ne8hr2hmYkw
         PqYf+g1JoepAjFhtN4AONq2Y9oe/QcsF5s7ZEMjrhzjPzEuTX8Wzpfb5AdborLNmQsHE
         8p3d6NsfYZIW5C3BrbDXWCiymcil4LNea/80AlG9Uvfu0Q0MjoLG2viuI3z4cBnH5yef
         b4TUUqzUa2BIu7E0XcaUUOitQIlHSTF3sSaurPeWkDEnDZ9yzW7We8sXG1uQADJmkSD9
         6IF5aJ+vpR50hNyD/iQwdoUXgukc7tCtqIlGYiRFZuCtzWj5TuItQF//y37eSc/spbTY
         CR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HHCDrti6hZOHHFd1mpKnLx73brcB9mCERSd3hAVv5pE=;
        b=RO8O7ZUUJH5IVlJe5jGeSGVv32B8qqoG0NNSPPrYze2UC+CkmEXHHUqTclLqBWwBdg
         KqVTqs6JyF7Rvqps5XncSOo0l9WTZfcGYf19b/Nc7YB7w/kZKlcXfVFGObtw6HxneIpl
         BsjJVxg/ayCz12GMofSIhpvKTFwwsfJpwpWsvs1f8jqDtbhl16jkSHs8EQ+0sdpV0StB
         zd2ZJSK/MxQfQaIP/cv8gz5vvu/jvBwl4pPMKMxlZzegOe3WvuVX2JkYMdGPiLXF0uyp
         n2dMpHulz1omaP8oQ8MmojYJMJRgVMsSdNkMEzUbFaJV1PLKN2TyvQHIL/gj/Dl5JRpT
         YUeg==
X-Gm-Message-State: APjAAAVLqxbaMei3PScaRjO1au6ji3vXvmBxubM11mvWG7cPAS/mBikO
        6PI97fFJmnIXvcY7WcYtUa8qzNGdcOQTLTBpF8xP
X-Google-Smtp-Source: APXvYqzUa4qPIMP44F+BRabfYCSqJIepdYV6MTPHD6iv/GuQEMcoUX0OYLpUf6gPQK1dgHDLAI0smjWtlweRABY8wvI=
X-Received: by 2002:a19:230e:: with SMTP id j14mr2053068lfj.13.1560351704859;
 Wed, 12 Jun 2019 08:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190611080719.28625-1-omosnace@redhat.com> <CAHC9VhSXZp6QierOGRBXmyUf=pT3Y4mf=78AmQAquuQ8-WBSGw@mail.gmail.com>
 <CAFqZXNsD06JYYNmpOYyGrxLHCfvVyUSJMZ3mRTWG5-b2Ws7zQw@mail.gmail.com>
In-Reply-To: <CAFqZXNsD06JYYNmpOYyGrxLHCfvVyUSJMZ3mRTWG5-b2Ws7zQw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 12 Jun 2019 11:01:33 -0400
Message-ID: <CAHC9VhSs4pEDL+fSFCqd4xNLqXgEQ42Qh0p2uhePnbx9ZuxwgQ@mail.gmail.com>
Subject: Re: [PATCH] selinux: log raw contexts as untrusted strings
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     selinux@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 3:37 AM Ondrej Mosnacek <omosnace@redhat.com> wrote=
:
> On Wed, Jun 12, 2019 at 12:56 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Tue, Jun 11, 2019 at 4:07 AM Ondrej Mosnacek <omosnace@redhat.com> w=
rote:
> > > These strings may come from untrusted sources (e.g. file xattrs) so t=
hey
> > > need to be properly escaped.
> > >
> > > Reproducer:
> > >     # setenforce 0
> > >     # touch /tmp/test
> > >     # setfattr -n security.selinux -v 'ku=C5=99ec=C3=AD =C5=99=C3=ADz=
ek' /tmp/test
> > >     # runcon system_u:system_r:sshd_t:s0 cat /tmp/test
> > >     (look at the generated AVCs)
> > >
> > > Actual result:
> > >     type=3DAVC [...] trawcon=3Dku=C5=99ec=C3=AD =C5=99=C3=ADzek
> > >
> > > Expected result:
> > >     type=3DAVC [...] trawcon=3D6B75C5996563C3AD20C599C3AD7A656B
> > >
> > > Fixes: fede148324c3 ("selinux: log invalid contexts in AVCs")
> > > Cc: stable@vger.kernel.org # v5.1+
> > > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >  security/selinux/avc.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > Thanks, the patch looks fine to me, but it is borderline -stable
> > material in my opinion.  I'll add it to the stable-5.2 branch, but in
> > the future I would prefer if you left the stable marking off patches
> > and sent a reply discussing *why* this should go to stable so we can
> > discuss it.  I realize Greg likes to pull a lot of stuff into stable,
> > but I try to be a bit more conservative about what gets marked.  Even
> > the simplest fix can still break things :)
>
> OK, I was a bit unsure whether to mark it as stable or not and
> eventually inclined to do so... I'll try be more careful about it in
> the future.

If it makes you feel better, it's not that big of a deal, I just felt
it was worth mentioning since we've been doing a bit of a "best
practices for submitting SELinux kernel patches" on the mailing list
lately and I felt this was worth mentioning.  The basic idea is that I
think marking something for stable shouldn't be taken lightly and it
is worth a discussion, even if it is short.

--=20
paul moore
www.paul-moore.com
