Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A4C47B48D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhLTUtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:49:53 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:39811 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhLTUtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:49:51 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MWiYi-1mx7KP1UGe-00X5pM; Mon, 20 Dec 2021 21:49:49 +0100
Received: by mail-wr1-f52.google.com with SMTP id e5so22514739wrc.5;
        Mon, 20 Dec 2021 12:49:49 -0800 (PST)
X-Gm-Message-State: AOAM533/6UV4jqalZ3JM0SOxNZ4gp1QjWuTFtlmAf/2D10ZL6DQw+mOS
        aGEgp+fbxhIV4K6IEK4gg4vZD61iLmYQh4ra1DY=
X-Google-Smtp-Source: ABdhPJwWDWTHZHgNTSQ0wUTfz4jo1LccX5HWkJMwwdvMUlK5BwiPavZdpQ4FzYCH7w8gBRNjEdFErZH7zpIbmXFg6qY=
X-Received: by 2002:adf:f051:: with SMTP id t17mr14325348wro.192.1640033388952;
 Mon, 20 Dec 2021 12:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20211220143023.451982183@linuxfoundation.org> <20211220143024.049888083@linuxfoundation.org>
 <20211220203136.GA4116@duo.ucw.cz>
In-Reply-To: <20211220203136.GA4116@duo.ucw.cz>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 20 Dec 2021 21:49:32 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3XVPWJqoRoKz-jvAkbVwcNVrrjq9pj9OCPN9bQsizisg@mail.gmail.com>
Message-ID: <CAK8P3a3XVPWJqoRoKz-jvAkbVwcNVrrjq9pj9OCPN9bQsizisg@mail.gmail.com>
Subject: Re: [PATCH 4.19 18/56] hv: utils: add PTP_1588_CLOCK to Kconfig to
 fix build
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Linux on Hyper-V List <linux-hyperv@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:H3uwgO1U98h6P06K3X8mALyoked0McQHHkSd6U3OWk1oTX80Cez
 xoSeykkLmDluSCGUqhL9LtsrM0HlSe71gnLaytpVmPDKXubwOtFm1kkPCbMqW2qnEtH5Hbr
 LoTjCTUplqBg//TDvyMXx2hn9Pt0TE+ls8lpUtaaXhQleX1oBETXH3RIplMR1eYZNpoCxz5
 Jhyr8V47zQeOhK9dUfJTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:An6FaNtMhHc=:Qyg8QVs+NhTPUnQOXQ/KpR
 rfhFgOsQKC6Vli6mw1Hav9ruQHn/0EV8WHZHfV+nCztHnDaDE7fb4am7PEtencFGVdMg+3oRF
 1tWefsN3PcZkI1dScd+26JdR16qvsYEzwEzXg+2pyfEY4nE+4ucQk0YPQqkqP2lZzBTA4DRmM
 hQkW28RrOnn5uOAHuIzWeUw7nBdmF+2tZ6h40ZQrdWxsKNOpotqb5EJ53OnDNWTCcy/Tz2ey8
 ARdrkwvDK19sFxBz8KbgwGQaVGrhSStekobPxv7PHVB8DCMwBInOJmlNSTtYN0gLOKDDZYvQw
 7ewSUBoZMyL4ytI6DBF3YY0CosjVNPNlV+TVrvAGyDH+Hc+prArvVWbj9hjuk2aJGjk/b4Ysm
 Rs7DTaVs1JzEjOaZ6aNJ68NReX2nEo9VJI0XWIjG3qdc4hgyoatkJpgQY/U0FEKF3ZuXrYOM8
 4sO59zbYn0VV0xUxev5yOlg2B0lFsz7lR2fqCqTH38a3MyN9kbIUgTlKcNJxnMjERY7tHXGhW
 R4qkVvX4Xi9ZLAr6etvaQnqN8o7GBJtWTVSFHQaABnxIUt+SW4TAtjJpPnUv6chRcqizg3Iaa
 vK2/MxlP61DpMNdfTg48nqQng6XTEljAN3tHeNz18vzAHCePwKhHneBz+W/b5664vtcdPrKux
 2cj3OccHapus/RgPfWNW8ZlSW8EzcyglgPqEKYZSP4Dwk0A9xXYVwMNK4Qs0rUDrQRco=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 9:31 PM Pavel Machek <pavel@ucw.cz> wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > [ Upstream commit 1dc2f2b81a6a9895da59f3915760f6c0c3074492 ]
> >
> > The hyperv utilities use PTP clock interfaces and should depend a
> > a kconfig symbol such that they will be built as a loadable module or
> > builtin so that linker errors do not happen.
> >
> > Prevents these build errors:
> >
> > ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
> > hv_util.c:(.text+0x37d): undefined reference to `ptp_clock_unregister'
> > ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
> > hv_util.c:(.text+0x738): undefined reference to `ptp_clock_register'
>
> This is bad idea for 4.19:
>
> > +++ b/drivers/hv/Kconfig
> > @@ -16,6 +16,7 @@ config HYPERV_TSCPAGE
> >  config HYPERV_UTILS
> >       tristate "Microsoft Hyper-V Utilities driver"
> >       depends on HYPERV && CONNECTOR && NLS
> > +     depends on PTP_1588_CLOCK_OPTIONAL
> >       help
> >         Select this option to enable the Hyper-V Utilities.
>
> grep -ri PTP_1588_CLOCK_OPTIONAL .
>
> Results in no result in 4.19. So this will break hyperv. No results in
> 5.10, either, so it is bad idea there, too.

Right, this doesn't work, but the bug does exist anyway, and could be
fixed by listing the dependency explicitly as

           depends on PTP_1588_CLOCK || PTP_1588_CLOCK=n

The PTP_1588_CLOCK_OPTIONAL was added as a shortcut to
avoid the odd Kconfig syntax that most developers struggle with understanding
at first.

         Arnd
