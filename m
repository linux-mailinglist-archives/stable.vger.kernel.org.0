Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081704539AD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbhKPTDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239669AbhKPTDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:03:36 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8647C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:00:38 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 7so556062oip.12
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SZihyt5308KW2rYcee3G+gbznNj92iM9/GOhpLQbwOk=;
        b=lv/Z3JAzNlVh9cOuwZ42QWpRROkBiiG/ZCnV3JunqT0ONI9ZVIuntPCjXLaamLT+9n
         8lzkt7cfVehpVa4P7FLPWQU5zimSMjGOkKdHIOx7U6zU1M634VF370CQDsMUnCDCn/6I
         BUiT/a3b/lo+LyzoY3bbdyOz+AwkcqHuspyJjH9yU87fQ60fe3SaiGGH6FHK2E3sWBOI
         dYrJbBCPWhHYJUPtfM00EPplHRnjm+fKe2ofMcTNR/Rc9/QsfZQdHHm7/jWY5ah6V7tc
         qTikh0zcU3tehgEA3D3C8ABNgXUUdQJaseXFZkyjJXM0WAG0oCXo4DW7UXefvMk/paqS
         mCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SZihyt5308KW2rYcee3G+gbznNj92iM9/GOhpLQbwOk=;
        b=Ww6YLoJxI10PPhnJ0I4cuTuqcKNp+w3cfqcAK5yoQmfOvfg/i4zVILQupFtwwNM4Pz
         Rk5ihWUw7x5Edxx8SywxVr90OEXnLHqgN+G8jIX9dPJ5kFvUEfXPMJbhgSsXCWSUyqqG
         5p5pQnajbo87TTtklk8tSNWvwJ0fP8VK1KMIGq7a2SEFxISRKPTFoMFjQS+/gJVIxLzG
         wE9R84VNJ2m7s6EvH9JIXqM66hvNTRzLfTBPxwiOUkWv3VLsuFJEkA1W2HjkVY0gHc8u
         bmyfKdncKM310czWZ5LhsXvANZzXe+SRP9p4XUJYtBc3cDV+EtIiLVsWs9lpBtWTumxx
         oFCA==
X-Gm-Message-State: AOAM533bMqC3iGz/DTkiQ59tyYGTIUPBwm4jdBo/aYLc4E/rGiSVceES
        XnvyOpAsv3eRZWtcm/thB8iaqxJLEr1AJgaLX5gwoA==
X-Google-Smtp-Source: ABdhPJw7eWObgd2uYvlbAdRg36KHRNAU98h+fYoR0YaKoZ6nSoPKyP/j1J7/CK9iHxmYavd6liXAvESnWsDefzojiwo=
X-Received: by 2002:a05:6808:d1:: with SMTP id t17mr8257345oic.161.1637089237997;
 Tue, 16 Nov 2021 11:00:37 -0800 (PST)
MIME-Version: 1.0
References: <20211116142631.571909964@linuxfoundation.org> <CA+G9fYvyATAWicFbnKnOTqc=MKUXNrbCBYP6zej3FJJyA31WPQ@mail.gmail.com>
In-Reply-To: <CA+G9fYvyATAWicFbnKnOTqc=MKUXNrbCBYP6zej3FJJyA31WPQ@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Tue, 16 Nov 2021 13:00:26 -0600
Message-ID: <CAEUSe7-eCDLo_qcDVUZgvZHVan_igPvE16-PYnXMOh3TZdQ9+w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Tue, 16 Nov 2021 at 11:18, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Tue, 16 Nov 2021 at 20:31, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.3 release.
> > There are 927 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.15.3-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regression found on arm64 juno-r2 / qemu-arm64.
> Following kernel crash reported on stable-rc 5.15
>
> metadata:
>   git branch: linux-5.15.y
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git commit: cb98d6b416c1a202f89fa1a3cebf05b054c3aa96
>   git describe: v5.15.2-928-gcb98d6b416c1
>   make_kernelversion: 5.15.3-rc2
>   kernel-config: https://builds.tuxbuild.com/210RSpE88PsYvgxZBgc8tYKzSYL/=
config
>
> Kernel crash log:
> -----------------
> [    0.368057] kernel BUG at crypto/algapi.c:461!
> [    0.368438] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> [    0.368921] Modules linked in:
> [    0.369233] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.15.3-rc2 #1
> [    0.369974] Hardware name: linux,dummy-virt (DT)
> [    0.370280] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    0.370829] pc : crypto_unregister_alg+0x100/0x110
> [    0.371266] lr : crypto_unregister_alg+0x90/0x110
> [    0.371699] sp : ffff80001003bce0
> [    0.372003] x29: ffff80001003bce0 x28: 0000000000000000 x27: ffffb7ae6=
ee804f8
> [    0.372643] x26: ffffb7ae6ef51060 x25: 0000000000000006 x24: ffffb7ae6=
f068344
> [    0.373291] x23: ffffb7ae6ee6d348 x22: ffffb7ae6fc72728 x21: ffff80001=
003bd18
> [    0.373939] x20: ffffb7ae6f93d598 x19: ffff0000c0d6f500 x18: fffffffff=
fffffff
> [    0.374582] x17: 6120737265746e75 x16: 6f632037202c7265 x15: ffff80009=
003b9d7
> [    0.375225] x14: 0000000000000001 x13: 293635326168732c x12: ffff0000f=
f7f49e8
> [    0.375868] x11: 0000000000000010 x10: 00000000000000a5 x9 : ffffb7ae6=
d74c190
> [    0.376509] x8 : ffff80001003bcc8 x7 : ffff80001003bcb8 x6 : ffff0000c=
0d6f510
> [    0.377325] x5 : ffff80001003bca8 x4 : ffff80001003bcc8 x3 : ffff80001=
003bca8
> [    0.377970] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 000000000=
0000002
> [    0.378617] Call trace:
> [    0.378846]  crypto_unregister_alg+0x100/0x110
> [    0.379260]  crypto_unregister_skcipher+0x20/0x30
> [    0.379726]  simd_skcipher_free+0x28/0x40
> [    0.380251]  aes_exit+0x38/0x70
> [    0.380575]  cpu_feature_match_AES_init+0xac/0xdc
> [    0.381010]  do_one_initcall+0x50/0x2b0
> [    0.381348]  kernel_init_freeable+0x250/0x2d8
> [    0.381747]  kernel_init+0x30/0x140
> [    0.382068]  ret_from_fork+0x10/0x20
> [    0.382398] Code: 910ea000 9433fa21 d4210000 17ffffee (d4210000)
> [    0.382954] ---[ end trace 9a836623ed63b8f4 ]---
> [    0.383842] Kernel panic - not syncing: Attempted to kill init!
> exitcode=3D0x0000000b
> [    0.384527] SMP: stopping secondary CPUs
> [    0.384904] Kernel Offset: 0x37ae5d200000 from 0xffff800010000000
> [    0.385452] PHYS_OFFSET: 0x40000000
> [    0.385771] CPU features: 0x000042c1,23300e42
> [    0.386169] Memory Limit: none
> [    0.386451] ---[ end Kernel panic - not syncing: Attempted to kill
> init! exitcode=3D0x0000000b ]---
>
>
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> boot log,
> https://lkft.validation.linaro.org/scheduler/job/3939198#L401
>
> build link:
> -----------
> https://builds.tuxbuild.com/210RSpE88PsYvgxZBgc8tYKzSYL/build.log
>
> build config:
> -------------
> https://builds.tuxbuild.com/210RSpE88PsYvgxZBgc8tYKzSYL/config

Anders' bisection led to this:

# first bad commit: [f3cb2b65eb9a206007e83679945b082aff1362c9] crypto:
api - Fix built-in testing dependency failures
commit f3cb2b65eb9a206007e83679945b082aff1362c9
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Sep 17 08:26:19 2021 +0800

    crypto: api - Fix built-in testing dependency failures

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org

--
# bad: [cb98d6b416c1a202f89fa1a3cebf05b054c3aa96] Linux 5.15.3-rc2
# good: [7cc36c3e14ae0af800a3a5d20cb17d0c168fc956] Linux 5.15.2
git bisect start 'cb98d6b416c1a202f89fa1a3cebf05b054c3aa96'
'efcdec78c4504aba664ccd7e1bfe4a6493126c96'
# bad: [e4c9bb1c1409f4a5f83bf9b859580175789d7e1a] mt76: mt7915: fix
bit fields for HT rate idx
git bisect bad e4c9bb1c1409f4a5f83bf9b859580175789d7e1a
# bad: [21c1a3174ff915ed8d83d4d390d97bcc390a78e4] brcmfmac: Add DMI
nvram filename quirk for Cyberbook T116 tablet
git bisect bad 21c1a3174ff915ed8d83d4d390d97bcc390a78e4
# good: [359fa686d83b7f5410ab48f629f0bbac9286a546] power: supply:
max17042_battery: Prevent int underflow in set_soc_threshold
git bisect good 359fa686d83b7f5410ab48f629f0bbac9286a546
# good: [5b6273aa9d9844b865e2b34857b0f1b155102541] serial: 8250: Fix
reporting real baudrate value in c_ospeed field
git bisect good 5b6273aa9d9844b865e2b34857b0f1b155102541
# good: [0420c03e13550855a7697b8c9eb373696f9ff4b2] mwifiex: Run
SET_BSS_MODE when changing from P2P to STATION vif-type
git bisect good 0420c03e13550855a7697b8c9eb373696f9ff4b2
# bad: [627e09916874a7d944a880f27377ac3039a95702] media: netup_unidvb:
handle interrupt properly according to the firmware
git bisect bad 627e09916874a7d944a880f27377ac3039a95702
# bad: [f2c14d46beb5c26e3e48b2477e0bae1ed48a1914] selftests: net:
fib_nexthops: Wait before checking reported idle time
git bisect bad f2c14d46beb5c26e3e48b2477e0bae1ed48a1914
# good: [5c4480638561e3d49b25747d78e78094b279d6b8] fscrypt: allow
256-bit master keys with AES-256-XTS
git bisect good 5c4480638561e3d49b25747d78e78094b279d6b8
# good: [2164859616e308f031897488558b5460b4dcd96a] drm/amd/display:
Fix null pointer dereference for encoders
git bisect good 2164859616e308f031897488558b5460b4dcd96a
# bad: [f3cb2b65eb9a206007e83679945b082aff1362c9] crypto: api - Fix
built-in testing dependency failures
git bisect bad f3cb2b65eb9a206007e83679945b082aff1362c9
# first bad commit: [f3cb2b65eb9a206007e83679945b082aff1362c9] crypto:
api - Fix built-in testing dependency failures
commit f3cb2b65eb9a206007e83679945b082aff1362c9
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Sep 17 08:26:19 2021 +0800

    crypto: api - Fix built-in testing dependency failures

    [ Upstream commit adad556efcdd42a1d9e060cbe5f6161cccf1fa28 ]

    When complex algorithms that depend on other algorithms are built
    into the kernel, the order of registration must be done such that
    the underlying algorithms are ready before the ones on top are
    registered.  As otherwise they would fail during the self-test
    which is required during registration.

    In the past we have used subsystem initialisation ordering to
    guarantee this.  The number of such precedence levels are limited
    and they may cause ripple effects in other subsystems.

    This patch solves this problem by delaying all self-tests during
    boot-up for built-in algorithms.  They will be tested either when
    something else in the kernel requests for them, or when we have
    finished registering all built-in algorithms, whichever comes
    earlier.

    Reported-by: Vladis Dronov <vdronov@redhat.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

 crypto/algapi.c   | 73 ++++++++++++++++++++++++++++++++++++++-------------=
----
 crypto/api.c      | 52 +++++++++++++++++++++++++++++++++++----
 crypto/internal.h | 10 ++++++++
 3 files changed, 108 insertions(+), 27 deletions(-)
