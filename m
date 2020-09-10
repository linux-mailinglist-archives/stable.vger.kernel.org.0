Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57CB263D79
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 08:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgIJGg2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 10 Sep 2020 02:36:28 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40695 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgIJGgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 02:36:24 -0400
Received: by mail-oi1-f196.google.com with SMTP id t76so4912105oif.7;
        Wed, 09 Sep 2020 23:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hPGNyTwwUC632Hhbju4GIdkO+X61wOtKriG815nPY+Y=;
        b=Qakn7Fc1Aqexy2mYE3MIbo1iqnZSTmVKIv6UcrLBlmVGPBpnrh/PftmC40vEmRg32a
         yXLmVl3dQPafAgp0tl5cKiE5Ye21sAw4OcJ2daXMGAUnT5vqe83fx8yi+tSp2gWoTbek
         1OgVm3rRnyNMLRSFR0DAwDKqJgKBVQsozaK81/bvyEFdGvEHpZ9FMIsMG7OJ2+TgmUQB
         VO7pAK65smbdfbN52FrLISstJVs2Rq2lWUO1hEUrSnM95UShnqM8N42wmPFBgOVW23cB
         a0mnc9xNezJqaKtOzB4hEO6Nb//14UOQdss9Kb2IGKX7etwq8BXPihvTsZsTaRgDp4Km
         iy9A==
X-Gm-Message-State: AOAM533s8X99R/2VNN8lDwy6JMuO9/8irtX13fFE4IKNexeWqwQ6CbtF
        blwhLe3e+8MBwUXhtEdfI+mEiVMzVN7DaqJ9afI=
X-Google-Smtp-Source: ABdhPJxo5O9LUp8vWoGEiw2+IA5tjdafqulzyCfzRdf5q3oI9K1w5d+wSdCEy2eloAqTo4fMm+nfH+NjAednwodtdrY=
X-Received: by 2002:aca:4441:: with SMTP id r62mr2725769oia.153.1599719783692;
 Wed, 09 Sep 2020 23:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200908152241.646390211@linuxfoundation.org> <20200909164705.GE1479@roeck-us.net>
 <20200909180121.GD1003763@kroah.com> <5ea4e73b-778d-e742-7ba7-f1cbe0307a0f@roeck-us.net>
In-Reply-To: <5ea4e73b-778d-e742-7ba7-f1cbe0307a0f@roeck-us.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 10 Sep 2020 08:36:12 +0200
Message-ID: <CAMuHMdXwqC-B-CHQ0zzZ8YY+BDdq6ffqO6j85hsna-PUdwqz_g@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Günter,

On Wed, Sep 9, 2020 at 8:24 PM Guenter Roeck <linux@roeck-us.net> wrote:
> On 9/9/20 11:01 AM, Greg Kroah-Hartman wrote:
> > On Wed, Sep 09, 2020 at 09:47:05AM -0700, Guenter Roeck wrote:
> >> On Tue, Sep 08, 2020 at 05:22:22PM +0200, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.8.8 release.
> >>> There are 186 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>
> >> Build results:
> >>      total: 154 pass: 153 fail: 1
> >> Failed builds:
> >>      powerpc:allmodconfig
> >> Qemu test results:
> >>      total: 430 pass: 430 fail: 0
> >>
> >> The powerpc problem is the same as before:
> >>
> >> Inconsistent kallsyms data
> >> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> >>
> >> KALLSYMS_EXTRA_PASS=1 doesn't help. The problem is sporadic, elusive, and all
> >> but impossible to bisect. The same build passes on another system, for example,
> >> with a different load pattern. It may pass with -j30 and fail with -j40.
> >> The problem started at some point after v5.8, and got worse over time; by now
> >> it almost always happens. I'd be happy to debug if there is a means to do it,
> >> but I don't have an idea where to even start. I'd disable KALLSYMS in my
> >> test configurations, but the symbol is selected from various places and thus
> >> difficult to disable. So unless I stop building ppc:allmodconfig entirely
> >> we'll just have to live with the failure.
> >
> > Ah, I was worried when I saw your dashboard orange for this kernel.
> >
> > I guess the powerpc maintainers don't care?  Sad :(
> >
>
> Not sure if the powerpc architecture is to blame. Bisect attempts end up
> all over the place, and don't typically include any powerpc changes.
> I have no idea how kallsyms is created, but my suspicion is that it is
> a generic problem and that powerpc just happens to hit it right now.
> I have added KALLSYMS_EXTRA_PASS=1 to several architecture builds over
> time, when they reported similar problems. Right now I set it for
> alpha, arm, and m68k. powerpc just happens to be the first architecture
> where it doesn't help.

This is a generic problem, cfr. scripts/link-vmlinux.sh:

        # kallsyms support
        # Generate section listing all symbols and add it into vmlinux
        # It's a three step process:
        # 1)  Link .tmp_vmlinux1 so it has all symbols and sections,
        #     but __kallsyms is empty.
        #     Running kallsyms on that gives us .tmp_kallsyms1.o with
        #     the right size
        # 2)  Link .tmp_vmlinux2 so it now has a __kallsyms section of
        #     the right size, but due to the added section, some
        #     addresses have shifted.
        #     From here, we generate a correct .tmp_kallsyms2.o
        # 3)  That link may have expanded the kernel image enough that
        #     more linker branch stubs / trampolines had to be added, which
        #     introduces new names, which further expands kallsyms. Do another
        #     pass if that is the case. In theory it's possible this results
        #     in even more stubs, but unlikely.
        #     KALLSYMS_EXTRA_PASS=1 may also used to debug or work around
        #     other bugs.

Adding even more kallsyms_steps may help (or not, if you're really
unlucky).  Perhaps the number of passes should be handled automatically
(i.e. run until it succeeds, with a sane (16?) upper limit to avoid
 endless builds, so it can still fail, in theory).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
