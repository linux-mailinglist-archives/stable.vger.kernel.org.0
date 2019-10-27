Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3BAE6491
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfJ0RkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:40:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46285 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfJ0RkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 13:40:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id n15so7465133wrw.13
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 10:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FkHYFiDsqcrhh/x1p2m9DSaSG+KUAmaOqRNCjiDWvoQ=;
        b=oLXoo3oi2skejIH/dt1cK91nZ5IqjDglwEaOkev5Inlb2GkvtJXPaLQSIqZEzp56Mc
         9hU/WR0a0ElL+ElqXZsbP5J1UTncwnHFtw37q7v1L19NYotEtRgiVRcpwDZ3Oc1uCmx6
         xs0QHTj8bmN9Y42sliiCwlOPyOqdXgQcuWSmm/x8T90dJW8oO5YKpGspVyv6SNcUuHNl
         scpCW/EINUOlVC0N4EMRzP8Elgfq1ldc4pRpgqKcXHY6xQSbSfJmB1M2A1YyIMBoDJ+K
         TDtIY2cS6eZfnydzfOW7Wy22PbakAGZJgF1B1dQN5z2LYusj7QGT2PIv6OHF1TSVU9Ix
         jpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FkHYFiDsqcrhh/x1p2m9DSaSG+KUAmaOqRNCjiDWvoQ=;
        b=C+AfpOFKXbhsn62pJl/nWiHaaljDAOk0p32hUw4p/ISegIxpAdqsMQutJpwKoKmGoU
         6NkQEbcFAmkaEwleZuPOBko+Z1F9qXQDTKB4WljnQ+SeSej8XJBniePMc988nN2KIURx
         JpZq4ckvAtT3ZJXy1EQnIVoWfnicjr2COjkv50/lbb6W6m+YLRQthfcGXU+HWTvPVXNC
         kLxJ0rmAazg0ayRnuCLFWToQY+2lUaMEB90QrLFklfZcnjdnOf/n0pnP6RtDGVqs9mRC
         2w/1foG1UDGFC5NwN1R3Zkt+F+rGxYx42JFBThra8m40NhaFCOkmCHNobA4zvHF0UTan
         3lPQ==
X-Gm-Message-State: APjAAAVGKFFmffVtAknwyqxUZllRxcliyKxTymUojDRQFkfSUnFV6Pax
        H4EhpYpnuZ7J1encvb1gwwscjmNCZUDT4n1fBTqDzg==
X-Google-Smtp-Source: APXvYqzofjHJy+wG6fao9JMFBVbG6KV82wZ2RG51e0Gx9IEDcoAiIRH1iM8w1GHXtlTrVKD2K5RdMjOiI7qNniKZH7o=
X-Received: by 2002:adf:f685:: with SMTP id v5mr12387947wrp.246.1572197997372;
 Sun, 27 Oct 2019 10:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org> <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
 <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
 <20191025152534.GF31224@sasha-vm> <CAKv+Gu9_BtF2Zd9=9_wDukwKinmSMwes5R7Eu9jx315PQFk8dA@mail.gmail.com>
 <CAKv+Gu-2LXayWyP=3Eur_toGo4xqhENWeK6n+TCDcEy8xrKmXQ@mail.gmail.com>
 <20191026080121.GB554748@kroah.com> <20191026154020.GK31224@sasha-vm>
 <CAKv+Gu86eKUFz0TKOZxMzTXrWtW7Sq8EyHdZ=vWSBxOeRWfhVg@mail.gmail.com> <20191027133936.GA2195060@kroah.com>
In-Reply-To: <20191027133936.GA2195060@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 27 Oct 2019 18:39:55 +0100
Message-ID: <CAKv+Gu8mZP2g3itH355c29oscvf8Qc4ngd_hWTnoRUoPn+i3Fw@mail.gmail.com>
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Oct 2019 at 14:39, Greg KH <greg@kroah.com> wrote:
>
> On Sat, Oct 26, 2019 at 05:46:03PM +0200, Ard Biesheuvel wrote:
> > On Sat, 26 Oct 2019 at 17:40, Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > On Sat, Oct 26, 2019 at 10:01:21AM +0200, Greg KH wrote:
> > > >On Fri, Oct 25, 2019 at 05:39:44PM +0200, Ard Biesheuvel wrote:
> > > >> On Fri, 25 Oct 2019 at 17:28, Ard Biesheuvel <ard.biesheuvel@linar=
o.org> wrote:
> > > >> >
> > > >> > On Fri, 25 Oct 2019 at 17:25, Sasha Levin <sashal@kernel.org> wr=
ote:
> > > >> > >
> > > >> > > On Thu, Oct 24, 2019 at 04:37:12PM +0200, Ard Biesheuvel wrote=
:
> > > >> > > >On Thu, 24 Oct 2019 at 16:34, Alexandru Elisei <alexandru.eli=
sei@arm.com> wrote:
...
> > > >> > > >>
> > > >> > > >> This breaks when building, because __hardenbp_enab is decla=
red in the next patch:
> > > >> > > >>
> > > >> > > >> $ make -j32 defconfig && make -j32
> > > >> > > >>
> > > >> > > >> [..]
> > > >> > > >> arch/arm64/kernel/cpu_errata.c: In function =E2=80=98check_=
branch_predictor=E2=80=99:
> > > >> > > >> arch/arm64/kernel/cpu_errata.c:492:3: error: =E2=80=98__har=
denbp_enab=E2=80=99 undeclared (first
> > > >> > > >> use in this function)
> > > >> > > >>    __hardenbp_enab =3D false;
> > > >> > > >>    ^~~~~~~~~~~~~~~
> > > >> > > >> arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared=
 identifier is reported
> > > >> > > >> only once for each function it appears in
> > > >> > > >> make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel=
/cpu_errata.o] Error 1
> > > >> > > >> make[1]: *** Waiting for unfinished jobs....
> > > >> > > >>
> > > >> > > >
> > > >> > > >Indeed, but as discussed, this matches the state of both main=
line and
> > > >> > > >v4.19, which carry these patches in the same [wrong] order as=
 well.
> > > >> > > >
> > > >> > > >Greg should confirm, but as I understand it, it is preferred =
to be
> > > >> > > >bug-compatible with mainline rather than fixing problems when=
 spotting
> > > >> > > >them while doing the backport.
> > > >> > >
> > > >> > > Is it just patch ordering? If so I'd rather fix it, there's no=
 reason to
> > > >> > > carry this issue into the stable trees.
> > > >> > >
> > > >> > > We reserve "bug compatibility" for functional issues that are =
not yet
> > > >> > > fixed upstream, it doesn't seem to be the case here.
> > > >> > >
> > > >> >
> > > >> > The patches don't apply cleanly in the opposite order.
> > > >>
> > > >> What we could do is squash the two patches together. That way, we
> > > >> avoid the breakage without having to modify the patches in order t=
o be
> > > >> able to apply them.
> > > >
> > > >No, don't do that.  Just take all of the needed commits.
> > >
> > > Right, just make the patches apply in reverse, this shouldn't be more
> > > than moving some code from the 2nd patch back to the 1st one, right?
> > >
> > > We usually don't do this in stable backports, but there are three goo=
d
> > > reasons to do it here:
> > >
> > > 1. It'll be nice to maintain bisectability.
> > > 2. The end result should be exactly the same, so there's no room for
> > > error here.
> > > 3. It's a backport for an older kernel to begin with, so there are
> > > changes from upstream already.
> > >
> >
> > I really don't see the point of doing this for v4.14 while v4.19 and
> > mainline have the two patches in the opposite order.
> >
> > Would you like me to resend the entire 48 piece series for this?
>
> No need, I've queued the whole thing up now, thanks.
>

Thanks Greg
