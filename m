Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D255156561
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgBHQNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:13:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44169 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbgBHQNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:13:25 -0500
Received: by mail-lf1-f67.google.com with SMTP id v201so1312861lfa.11
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BkYFBfPyKvzswGG782ra4Cz2lr/kus4X+MdHQ5OLnxY=;
        b=g13xT9lRDBeSSVFO+kBC3mdWI5j/QJCzhboNBShh6kPm1TZqzhX30e23v9f3eZxIA5
         FjEDqbcigQAODS24Y9dE/P91Ne94AB65F2YT/QU/cCjesANOJKSEuEbxfDW3OQWjU69I
         pXGrLq1oHlNdpOUh2j6vFjgGGIMdx3SPZ+0oNX3GWxWC7DLMFoabTFAFrtUlj8r2QidB
         ZpJHd9S8b1Is1Rii9fw8UiloEg6sVDZthJYg46tCMYn95K0/HobWb8vtyW0glSoYC5cG
         dBLa3jJM/NZfVHKSJx4QGTcI7ZKztP+TlK4IDsM4W20HN4MHytROUCSMcjPAlR3q99Id
         8xHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BkYFBfPyKvzswGG782ra4Cz2lr/kus4X+MdHQ5OLnxY=;
        b=g3F7VR2MN5FIvYqm9HNJXPRDmA6BIn7GsPSzMBv5GfcsaxuThqNfXS+7oATmI/Giz5
         qOPvBzbNIlUUwQ5YEL2MRKpSeiljYRTSEUV7U2F9+hcCab1bD67t1G89d9th6d5c60dV
         NMokTfYCjF0+xbv5Hf8DhYgX1r3MxDii0lFHzT/poQEF83XPwj35+TLjOQTyrtczBZzN
         3Xz3lfZQHjK3/jhqcG/Bxd/9c8bQySlfPbJWl1zUu2lRUKb2nIubN0230JLnn/hfqGfM
         nx2XAh2UsVewzgyyzSWFAOwU7SQNzIiF+mgxsHmSO58Y5A4bFK9LrR0DKW0mOHVfzTsg
         pMyQ==
X-Gm-Message-State: APjAAAWqpLg432cagfYwYXGjjUprN5aTY0Ox68CEIoQnzoIfZCBYb8ck
        8NXaZVDNpCidAw+egxfUea1WwBzUQLSBbAS7AjSm9Q==
X-Google-Smtp-Source: APXvYqzuJN8dkvQp+rwG/MibhW0AJPGZ/u9gK+LJnQwiyGSEYMA7Grr36OxXieQ+lWGoDpkTrhzsEJ/YuBgvZ5541ew=
X-Received: by 2002:ac2:5f65:: with SMTP id c5mr2252748lfc.207.1581178401452;
 Sat, 08 Feb 2020 08:13:21 -0800 (PST)
MIME-Version: 1.0
References: <20200203161902.288335885@linuxfoundation.org> <CA+G9fYuzYzwqaL6_5=2+KmRHy=BDRS0WgW2dGSL6wi+_FFFhCg@mail.gmail.com>
 <20200205130706.GA1208327@kroah.com>
In-Reply-To: <20200205130706.GA1208327@kroah.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Sat, 8 Feb 2020 10:13:10 -0600
Message-ID: <CAEUSe79EBivBWSxjNfoZBWKaO-uv2tzMChuiLRjFwQuGAPvBsg@mail.gmail.com>
Subject: Re: [PATCH 5.5 00/23] 5.5.2-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Wed, 5 Feb 2020 at 07:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Feb 04, 2020 at 09:15:44PM +0530, Naresh Kamboju wrote:
> > On Mon, 3 Feb 2020 at 22:08, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.5.2 release.
> > > There are 23 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.5.2-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.5.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
>
> Thanks for testing all of these and letting me know.
>
> It would be interesting to figure out how all of the different build
> errors on this "round" of releases did not trip up your systems...

We're not building these configs:
  allyesconfig allmodconfig omap2plus_defconfig imx_v6_v7_defconfig
nor building for ARCH=3Driscv, which were the ones failing.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
