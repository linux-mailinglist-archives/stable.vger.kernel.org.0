Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC1452B20
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 07:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhKPGlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 01:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhKPGky (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 01:40:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF366C061200
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 22:36:46 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so82999417edz.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 22:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgnB3dn6p+QVrJDNmL+R3DzSxKspb3M/9++MQo05UvY=;
        b=eSzmfk6YUHEXXBbmFV+7AEtSLf8/91sWFV92eOVwrdpUpFHao9jih2TMdcQFpy1slT
         J1AOEsOcuxonern/w8KPanQpOpdxkOn4dFyDigIag1h5VWgcRfA6XDUQOFwj5OZPm4Sz
         /fWQSnn4IzMLgLxsPzqWmrkeBpDILWdYqlyUg8tm6dZXH1CbKCdUSdWBmA8BVbZ136B2
         zhb2hb696AlAQEgawKhDQ5w2v/dNKnDPwCRc7Dg76pZfQIeKf5L8E2YL3iLhIvM7o0jD
         OKzheLaLY1ahaJIATl3+VEk7GCz8mmMOSSEvZ9ophpyH/9VFWoV5pOHy9RLOH8PBXyxt
         6qVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgnB3dn6p+QVrJDNmL+R3DzSxKspb3M/9++MQo05UvY=;
        b=RatMP+xKFi/m8p/Z/DT3bWVTHhWIYekn7EUnCVmvRInomoEU2BPoYmdvMNQ/gMlXlz
         vAATK2itFw+fV4AZXDI+/QUMRGw2bbPYtwzLOtK4Jh8jpvpDrvR+cuUIQLFtPeNTkgnd
         MEF3WREv2qGahYGaSs2QX7CIiMPySoiT9a3j2VeTFXfdOOv7jTXRQoqCEAiSv+K0QyjE
         9n7ZG5zIMNicJeen6H8qc3ClDBlaFjjNhT496OMUS+9MjCqxeUNTeQYoac94/0Vx3eA2
         Mj12LOgDdQ+SdnHGguHTA4Srglf7J71+GEBRYHG+eovtIvSjUMCOguTqUvKSLkG5VdPl
         bh2A==
X-Gm-Message-State: AOAM532sJgizyfuecZ8bbBDYTe+9EYiZ9w7NUpIOgGPSTTmnPzCGcx8p
        vmzQBV/O8gNnXYi7iScePUOvXO1HYeaLo8shsIyJ0kF1xzXHqw==
X-Google-Smtp-Source: ABdhPJx3ZYZBorB0tLSiimk4R2+uqbpxMk+q0dnUnsM8LdIfI3iB2fWi3nB1bgYZ6ct9MERzzJpQyywSnWdXpCfe5aM=
X-Received: by 2002:a05:6402:2814:: with SMTP id h20mr7062145ede.288.1637044605083;
 Mon, 15 Nov 2021 22:36:45 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org>
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Nov 2021 12:06:33 +0530
Message-ID: <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 at 00:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 917 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regression found on arm64 juno-r2 device.
Following kernel crash reported on stable-rc 5.15.

metadata:
  git branch: linux-5.15.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: ff5232812521d01d1ddfd8f36559a9cf83fea928
  git describe: v5.15.2-918-gff5232812521
  make_kernelversion: 5.15.3-rc1
  kernel-config: https://builds.tuxbuild.com/20yUV5tYmCSzjklEffg3Dhkbdzi/config

Kernel crash log:
-----------------
[    1.178361] kvm [1]: Hyp mode initialized successfully
[    1.184780] Unable to handle kernel NULL pointer dereference at
virtual address 000000000000019b
[    1.193599] Mem abort info:
[    1.196394]   ESR = 0x96000044
[    1.199458]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.204786]   SET = 0, FnV = 0
[    1.207848]   EA = 0, S1PTW = 0
[    1.210998]   FSC = 0x04: level 0 translation fault
[    1.215889] Data abort info:
[    1.218777]   ISV = 0, ISS = 0x00000044
[    1.222623]   CM = 0, WnR = 1
[    1.225605] [000000000000019b] user address but active_mm is swapper
[    1.231979] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[    1.237559] Modules linked in:
[    1.240617] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.3-rc1 #1
[    1.246894] Hardware name: ARM Juno development board (r2) (DT)
[    1.252820] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    1.259793] pc : crypto_register_alg+0x88/0xe4
[    1.264246] lr : crypto_register_alg+0x78/0xe4
[    1.268694] sp : ffff800012b9bce0
[    1.272008] x29: ffff800012b9bce0 x28: 0000000000000000 x27: ffff800012644c80
[    1.279162] x26: ffff000820d95480 x25: ffff000820d96000 x24: ffff800012644d3a
[    1.286313] x23: ffff800012644cba x22: 0000000000000000 x21: ffff800012742518
[    1.293463] x20: 0000000000000000 x19: ffffffffffffffef x18: ffffffffffffffff
[    1.300614] x17: 000000000000003f x16: 0000000000000010 x15: ffff000800844a1c
[    1.307765] x14: 0000000000000001 x13: 293635326168732c x12: 2973656128636263
[    1.314916] x11: 0000000000000010 x10: 0101010101010101 x9 : ffff80001054b5a8
[    1.322066] x8 : 7f7f7f7f7f7f7f7f x7 : fefefefefeff6462 x6 : 0000808080808080
[    1.329217] x5 : 0000000000000000 x4 : 8080808080800000 x3 : 0000000000000000
[    1.336367] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff800012742518
[    1.343517] Call trace:
[    1.345962]  crypto_register_alg+0x88/0xe4
[    1.350062]  crypto_register_skcipher+0x80/0x9c
[    1.354600]  simd_skcipher_create_compat+0x19c/0x1d0
[    1.359572]  cpu_feature_match_AES_init+0x9c/0xdc
[    1.364284]  do_one_initcall+0x50/0x2b0
[    1.368125]  kernel_init_freeable+0x250/0x2d8
[    1.372488]  kernel_init+0x30/0x140
[    1.375981]  ret_from_fork+0x10/0x20
[    1.379562] Code: 2a0003f6 710002df aa1503e0 1a9fd7e1 (3906b261)
[    1.385667] ---[ end trace a032e96fc9ec202d ]---
[    1.390350] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    1.398018] SMP: stopping secondary CPUs
[    1.401947] Kernel Offset: disabled
[    1.405434] CPU features: 0x10001871,00000846
[    1.409794] Memory Limit: none
[    1.412849] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com/20yUV5tYmCSzjklEffg3Dhkbdzi/build.log

build config:
-------------
https://builds.tuxbuild.com/20yUV5tYmCSzjklEffg3Dhkbdzi/config


--
Linaro LKFT
https://lkft.linaro.org
