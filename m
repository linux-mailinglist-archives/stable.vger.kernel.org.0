Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55A812EAB4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 20:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgABT7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 14:59:19 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:34537 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgABT7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 14:59:19 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MkEdF-1jTL8m3e4f-00kifh; Thu, 02 Jan 2020 20:59:18 +0100
Received: by mail-qt1-f170.google.com with SMTP id w47so35440883qtk.4;
        Thu, 02 Jan 2020 11:59:17 -0800 (PST)
X-Gm-Message-State: APjAAAVsBkAL9t3XXzrBewL9njKi9g/4l3eoCPegtzBRQx6OTpGh8MCw
        Z9kvLn96VbHIb/s66fsshFr97oRBaMdNmavfU68=
X-Google-Smtp-Source: APXvYqyMexwubr905g8IFy5rPyKxmy5F8mo4h/FyF5+Eh+Q+KNUhRdx6WKOpGs5LIKlENSVsLmNfAAn4pjNodXYNVLY=
X-Received: by 2002:ac8:47d3:: with SMTP id d19mr60247574qtr.142.1577995156713;
 Thu, 02 Jan 2020 11:59:16 -0800 (PST)
MIME-Version: 1.0
References: <20200102172413.654385-1-amanieu@gmail.com> <20200102172413.654385-2-amanieu@gmail.com>
 <20200102175011.q7afo45nc2togtfh@wittgenstein> <CAK8P3a3a88e=hkzYG5mj=NuVQWMtyougkKzBznnn2y9ZoZfEGg@mail.gmail.com>
 <CA+y5pbTwsN6dUWQ+hAWpuo4c7418GV1RdpmKFiJW+cEu+ibGJw@mail.gmail.com>
In-Reply-To: <CA+y5pbTwsN6dUWQ+hAWpuo4c7418GV1RdpmKFiJW+cEu+ibGJw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Jan 2020 20:59:00 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2nqRkEnkLD8she+d34UhP=FNWSZXf_47dM4+g-eZMJNw@mail.gmail.com>
Message-ID: <CAK8P3a2nqRkEnkLD8she+d34UhP=FNWSZXf_47dM4+g-eZMJNw@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers
To:     "Amanieu d'Antras" <amanieu@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NAAa5NIq97OLTmzk7+wkiIlV6ntMsnPKSy62Uh3QFCN6mYMVhEc
 tiUyCwjtpDQ/7vNFvwwxZjo3QSbOSlq7KvOmx2M4FMbT489oKS41a1uFukF1HZUzD3EIa9D
 bUYgCFrqmdWKSJVOcD+7mG/GpFKlwdHz2vz/co9v17WpOVQV/BR6k3JvcS2uutbROPtlMFO
 mTzd2Ovb9jpxCkrid+mBw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VSMufNLHaao=:BSnmp30yY7PTpPxyySYwWw
 qx3y5ojoOmRKCGwNEwpNszm0yHjYCcc+g7MSr5p2Y0J0rMNVL+CFLhXCynKYSiRe+k2TkuenX
 TQkcvA3FHgQPE1CXOFKfG+OLSk5NPm2n4Gy0OTVztS3pvOgZuy5MkjMNVLsZpFUzQ0h1tlJY0
 BHE/0DHTMepOH062AjjWvC3+Gyju4hp5JlUb7xyAn6DEzvd6g80y/vQCPeCIimjgsbTRNky7h
 nSXM3RZxMuurWJTyU5XCEJYFgFkLgdCnjhbCYIC1bNTOCtjvJmfoRovfKz/lHvrwKiUQ6kYVR
 4EAE12V5//qvQUH30D1gDcGdAV0ia7NpIXQiL+eCL5bG2v9sr506xUU9Y9S7kg9tjalhy+z7E
 o6keq+GkaIJZzNhPhTpdmFv4d9s6nHhGuBnJRt10a6IJ3eWEWCUtL/tNtFostrFAb8A8rBvn5
 5N0gT0QosjbUSQ7/Ul40XEMr6tl/8EnaBETz3jq6bCXx/wgX2o/zHe/d96LtVCLi1IeI+qHue
 EcnG4d+KEkPvUD2PqE0Gus4rTmKsV56lnMfDp2autGqGlcw6SqYZEmX7GH5Uatc2OdSjPhLpv
 jdDBeox9gVbaBUDH7xqHz7AvIECGOWomyvbCEl/VzR4usBp+NPZezuzMIcHdv0nu6bIU3RlTB
 8520lU6BhGIkjZovDHb0WMl0BqMJ7t8/EQS6adIsDkg62Zb8etZ1ig9vlCEtWecYeiT92ajqC
 6MRVoGfgFSoCrfWU1mSmO343xJYkhUDn4xkK6baEEuLN5InlmCmF9u/V3jRFh/NbNYyBWJCCB
 kptQJK+o+x8jn0VSTr4B1VJvPVGfcaFnl1KsRoA17uPTosB3wT4MlDnwPqfpaj0FiSh967Zvg
 bW9NSgZaVDiGef75sDng==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 2, 2020 at 8:33 PM Amanieu d'Antras <amanieu@gmail.com> wrote:
>
> On Thu, Jan 2, 2020 at 8:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thu, Jan 2, 2020 at 6:50 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > > On Thu, Jan 02, 2020 at 06:24:07PM +0100, Amanieu d'Antras wrote:
> > > > Previously this was only defined in the internal headers which
> > > > resulted in __NR_clone3 not being defined in the user headers.
> > > >
> > > > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > Cc: <stable@vger.kernel.org> # 5.3.x
> > > > ---
> > > >  arch/arm64/include/asm/unistd.h      | 1 -
> > > >  arch/arm64/include/uapi/asm/unistd.h | 1 +
> > > >  2 files changed, 1 insertion(+), 1 deletion(-)
> >
> > Good catch, this is clearly needed, but please make the patch change
> > every copy of asm/unistd.h that defines this, not just the arm64 one.
>
> Actually __ARCH_WANT_SYS_CLONE3 only needs to be in the uapi headers
> for architectures that use the asm-generic/unistd.h header, which uses
> it to guard the definition of __NR_clone3. Architectures not using the
> asm-generic header don't need this define to export __NR_clone3. The
> only other architecture with clone3 that uses the asm-generic header
> is riscv, which already defines __ARCH_WANT_SYS_CLONE3 in the uapi
> headers.

Ah, of course. The patch looks fine to me then.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
