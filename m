Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B7F453863
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhKPRVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbhKPRVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:21:47 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951FCC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:18:50 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y12so34639743eda.12
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdFEU6pNgQOBChXYcUsmxgSDbYHNzCd9Uf5YNeoU5lg=;
        b=u/ZfexgmdISGdW+1dvekoBbMMxK64HeiHciruGR4iSCVPtcuIf2NIASg2eU0121XDT
         peitI8dt6nEb2H/3JzKS2EFu1gtJ/RFrHDCzYRSjaGhiG4U9At9D+dtbVbjiiUm7Ucco
         QO9TTqkTTiuhdYZwsWdHG8arOyKiGGQSmjhw6GFr7ZbbmucZHmgWNXGfZzUfvq3Kopbt
         vMftNChJkP4QWq5yVLa61J4MI7DxD36w6gMciaM/zfqzdG/I0YaJTn/99npXErGpvyPU
         OfbsMlFoVhZ9rFbpDxRygLI49rcojBrLRNjBiKCAy4xHRD154RgvsUbtQkNvI5QaD/bE
         0gtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdFEU6pNgQOBChXYcUsmxgSDbYHNzCd9Uf5YNeoU5lg=;
        b=cvLD9PmnyjGrAzQs8+F1Y6TuXaJab11MEULwW4jXHzea0meiGumn9e9VSxb8ScunGP
         7or6DynvVrV2NUl0RqsSm91F78PcRLMbjcULbh2+p1zKMzbIHSTIhHvoWlHaN1G1zQql
         OdFUl6zqoFyZxY50gcs2GJbVtL8OGQLrzQvG8EznYyBgD9t3r4dFBDZmeGAg1oNf5Of1
         HpIN9z68N8ywM7o0U+rdD6g/+4sRqrZQxwZAJPZLM3lflaTwsBwVXTZ2sXFx7baBb2Is
         u9ZKEf2dEYb1AVapQY0sqsMnMCIPy679L5nib1J54hy6uD2pCf90wLoeRLyrKepQnEtc
         LiPw==
X-Gm-Message-State: AOAM533oZssF35Zdv8jmQ4kL2c0n/xzpcy8++EapND2S2HhBOqy9EcBA
        vB2xcmrVW1yiNHdKPn0phF+UQUivkedXErPiJJYF1w==
X-Google-Smtp-Source: ABdhPJxcDPilPp/983yTSr19IWo04EwqC1zn3IPSojuXLnAn67qgpmXCzfJoGdKuAwKoeKA+3nJE1qqrGeqnars809M=
X-Received: by 2002:aa7:c415:: with SMTP id j21mr11770930edq.357.1637083128746;
 Tue, 16 Nov 2021 09:18:48 -0800 (PST)
MIME-Version: 1.0
References: <20211116142631.571909964@linuxfoundation.org>
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Nov 2021 22:48:37 +0530
Message-ID: <CA+G9fYvyATAWicFbnKnOTqc=MKUXNrbCBYP6zej3FJJyA31WPQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 at 20:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on arm64 juno-r2 / qemu-arm64.
Following kernel crash reported on stable-rc 5.15

metadata:
  git branch: linux-5.15.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: cb98d6b416c1a202f89fa1a3cebf05b054c3aa96
  git describe: v5.15.2-928-gcb98d6b416c1
  make_kernelversion: 5.15.3-rc2
  kernel-config: https://builds.tuxbuild.com/210RSpE88PsYvgxZBgc8tYKzSYL/config

Kernel crash log:
-----------------
[    0.368057] kernel BUG at crypto/algapi.c:461!
[    0.368438] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    0.368921] Modules linked in:
[    0.369233] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.15.3-rc2 #1
[    0.369974] Hardware name: linux,dummy-virt (DT)
[    0.370280] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.370829] pc : crypto_unregister_alg+0x100/0x110
[    0.371266] lr : crypto_unregister_alg+0x90/0x110
[    0.371699] sp : ffff80001003bce0
[    0.372003] x29: ffff80001003bce0 x28: 0000000000000000 x27: ffffb7ae6ee804f8
[    0.372643] x26: ffffb7ae6ef51060 x25: 0000000000000006 x24: ffffb7ae6f068344
[    0.373291] x23: ffffb7ae6ee6d348 x22: ffffb7ae6fc72728 x21: ffff80001003bd18
[    0.373939] x20: ffffb7ae6f93d598 x19: ffff0000c0d6f500 x18: ffffffffffffffff
[    0.374582] x17: 6120737265746e75 x16: 6f632037202c7265 x15: ffff80009003b9d7
[    0.375225] x14: 0000000000000001 x13: 293635326168732c x12: ffff0000ff7f49e8
[    0.375868] x11: 0000000000000010 x10: 00000000000000a5 x9 : ffffb7ae6d74c190
[    0.376509] x8 : ffff80001003bcc8 x7 : ffff80001003bcb8 x6 : ffff0000c0d6f510
[    0.377325] x5 : ffff80001003bca8 x4 : ffff80001003bcc8 x3 : ffff80001003bca8
[    0.377970] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000002
[    0.378617] Call trace:
[    0.378846]  crypto_unregister_alg+0x100/0x110
[    0.379260]  crypto_unregister_skcipher+0x20/0x30
[    0.379726]  simd_skcipher_free+0x28/0x40
[    0.380251]  aes_exit+0x38/0x70
[    0.380575]  cpu_feature_match_AES_init+0xac/0xdc
[    0.381010]  do_one_initcall+0x50/0x2b0
[    0.381348]  kernel_init_freeable+0x250/0x2d8
[    0.381747]  kernel_init+0x30/0x140
[    0.382068]  ret_from_fork+0x10/0x20
[    0.382398] Code: 910ea000 9433fa21 d4210000 17ffffee (d4210000)
[    0.382954] ---[ end trace 9a836623ed63b8f4 ]---
[    0.383842] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    0.384527] SMP: stopping secondary CPUs
[    0.384904] Kernel Offset: 0x37ae5d200000 from 0xffff800010000000
[    0.385452] PHYS_OFFSET: 0x40000000
[    0.385771] CPU features: 0x000042c1,23300e42
[    0.386169] Memory Limit: none
[    0.386451] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---



Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

boot log,
https://lkft.validation.linaro.org/scheduler/job/3939198#L401

build link:
-----------
https://builds.tuxbuild.com/210RSpE88PsYvgxZBgc8tYKzSYL/build.log

build config:
-------------
https://builds.tuxbuild.com/210RSpE88PsYvgxZBgc8tYKzSYL/config

--
Linaro LKFT
https://lkft.linaro.org
