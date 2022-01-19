Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D2249357B
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 08:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiASHar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 02:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245723AbiASHar (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 02:30:47 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61486C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 23:30:46 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id g81so4656554ybg.10
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 23:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Klx4RzQ0BDuNT+ki5g9oKkuf71RbnaB1NJYG//vbHCU=;
        b=dLFt7IMZdOeWJN+/buAb2gH8Pj1b1OfrdbHh9Ic3NoEL4vU6XfssQYw2jUSVTR/Dmu
         5dI2ITPJr1aMiOCRyuWaPL4FEts7Hy0IeM1NRR8jQb+rg1nAYMK5qMYBJhYwB8Y4Tpcd
         Ut9c/Abyo8mzf+g727gg/2AIIUuY7YVYGqXwmRwFOEjZS1mjQArNXsbL62wQ+8v0RmkP
         S4fCGubdX0BP2TLgTE6Wc8K6Em6+1Xj6vqQdlFJPJOWJBeZU6kOR34EYosG+l3UyGRVl
         B0+tDPF/bfmZNCXTH46KFniuQ7phsetxvnWutcF59U7BfO3tCrDpoLTNqV4YfWfT6o/0
         ELvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Klx4RzQ0BDuNT+ki5g9oKkuf71RbnaB1NJYG//vbHCU=;
        b=Kuy2fYqfR8j3nOSp9gtH+ERII7EYk/veP2nxQfDKm2Vwk1+yR9gofJT+MJkHrvJUF8
         WlM56WnzHIhdBMu3qz/G2RWVkjNX0czLMjCXuQOd5YYtn/YYRM0/aEzfjbK/A9zIcZXs
         QfVVpmXu+EAgaRCQyvOZifXTD9D/mmdDcsSicSpl3sG9BWNN5qeGG8wj9C6sw9A0Ou2J
         tMHrhw4zrV0QXP1c2eeSd4+eKu/AURnW23zBeUhImaEwnpdEgKNRy4RqZqR9YG8c7Bon
         AfBVzeamkVdyOFyEh/A65nnMJCxkQWuPRZ6Xv4PKvbfBGnYzvntSTN8Rpj/R6LsY1l5w
         NkXg==
X-Gm-Message-State: AOAM53095Y0jqouP7+N9Rac5qtcsROWYuAnDVd8HgHK243p8YC4w0tdK
        SBiDe1EQ3jZl7MLA16QcSOhgma5d7fesVyILEW1cGg==
X-Google-Smtp-Source: ABdhPJx14O3iuJhpQEbglBjfJUBPPdqOvAJzQIcvWXK74zSc3TPptBdwP6/Tm2mjBt/9Z+Lukq0BTo2sD/UcB5I266o=
X-Received: by 2002:a25:9082:: with SMTP id t2mr15698199ybl.684.1642577445341;
 Tue, 18 Jan 2022 23:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20220118160452.384322748@linuxfoundation.org>
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Jan 2022 13:00:33 +0530
Message-ID: <CA+G9fYvJaFVKu24oFuR1wGFRe4N2A=yxH6ksx61bunfR9Y3Ejw@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 at 21:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Following patch caused build regression for powerpc allnoconfig only on 5.16
with gcc-9.

5.16-powerpc-gcc-9-allnoconfig   - FAIL
5.16-powerpc-gcc-10-allnoconfig  - PASS
5.16-powerpc-gcc-11-allnoconfig  - PASS


make --silent --keep-going --jobs=8 \
  O=/home/tuxbuild/.cache/tuxmake/builds/current \
  ARCH=powerpc \
  CROSS_COMPILE=powerpc64le-linux-gnu- \
 'CC=sccache powerpc64le-linux-gnu-gcc' \
  'HOSTCC=sccache gcc'

Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround
make[1]: *** [/builds/linux/Makefile:1161: vmlinux] Error 1
make[1]: *** Deleting file 'vmlinux'

> NeilBrown <neilb@suse.de>
>     devtmpfs regression fix: reconfigure on each mount

Bisect log:
# bad: [979dd812ffb543a3f6218868a26a701054ba3b8c] Linux 5.16.2-rc1
# good: [80820ae87cc8c09b828faa951f44b2396a5b48c4] drm/i915: Avoid
bitwise vs logical OR warning in snb_wm_latency_quirk()
git bisect start '979dd812ffb543a3f6218868a26a701054ba3b8c'
'80820ae87cc8c09b828faa951f44b2396a5b48c4'
# bad: [6cb89b83384df47b2def88870be10db707a77649] 9p: only copy valid
iattrs in 9P2000.L setattr implementation
git bisect bad 6cb89b83384df47b2def88870be10db707a77649
# bad: [041b83007bd86ba0e7275e348eb13df13df669ef] vfs: fs_context: fix
up param length parsing in legacy_parse_param
git bisect bad 041b83007bd86ba0e7275e348eb13df13df669ef
# bad: [a7458144427accc2b602a672b1f9435e00ba578e] devtmpfs regression
fix: reconfigure on each mount
git bisect bad a7458144427accc2b602a672b1f9435e00ba578e
# good: [5c245afa643712977fd0a9c70ffbb9df5dbf204b] parisc: Fix
pdc_toc_pim_11 and pdc_toc_pim_20 definitions
git bisect good 5c245afa643712977fd0a9c70ffbb9df5dbf204b
# good: [677615cd2689a0898dd58e51d12abe6663567b24] Linux 5.16.1
git bisect good 677615cd2689a0898dd58e51d12abe6663567b24
# first bad commit: [a7458144427accc2b602a672b1f9435e00ba578e]
devtmpfs regression fix: reconfigure on each mount
The first bad commit:
commit a7458144427accc2b602a672b1f9435e00ba578e
Author: NeilBrown <neilb@suse.de>
Date:   Mon Jan 17 09:07:26 2022 +1100
    devtmpfs regression fix: reconfigure on each mount

    commit a6097180d884ddab769fb25588ea8598589c218c upstream.

    Prior to Linux v5.4 devtmpfs used mount_single() which treats the given
    mount options as "remount" options, so it updates the configuration of
    the single super_block on each mount.

    Since that was changed, the mount options used for devtmpfs are ignored.
    This is a regression which affect systemd - which mounts devtmpfs with
    "-o mode=755,size=4m,nr_inodes=1m".

    This patch restores the "remount" effect by calling reconfigure_single()

    Fixes: d401727ea0d7 ("devtmpfs: don't mix
{ramfs,shmem}_fill_super() with mount_single()")
    Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: NeilBrown <neilb@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 drivers/base/devtmpfs.c    | 7 +++++++
 fs/super.c                 | 4 ++--
 include/linux/fs_context.h | 2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

you may compare build results here.
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16-67-g979dd812ffb5/testrun/7410428/suite/build/test/gcc-9-allnoconfig/history/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
