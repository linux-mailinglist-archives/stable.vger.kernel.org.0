Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA33C39E5
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 04:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhGKCm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 22:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhGKCm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 22:42:58 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0DBC0613DD
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 19:40:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dj21so1046894edb.0
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 19:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5hLOnlcGooPP+0XvtSeeNz1VtXJ9AXoHVgYzYI06KsA=;
        b=wkdHk+afyxyHMGoc0KokYkOdx/rvGBdiKTFECi9e2QruXp5rG7f40HCtNY5753os7c
         tkWgobmSiAXx/z1c5JckxWWgOKAOxKjPKTYyjOqREMTT4Gftc5oJtDA9I94KBcPtdcUM
         wgsR8uTEp/FyDwDh0dooO61F1j28JGWeYq+DQ9GHtcUtNKtJZBFO/KhNpE2CSaWbMlxk
         MkSBpUC0mSEp0A98ZCNC1NcPV9kIeCLVWNOZR5b6LX+8BM0FLghEkec7LP3kWUlam0oj
         xOKOOqeceQkWnbIaWkDTC49P4jpP3We4NXjUP6+IITud3ja4e8QN9uyX0V4n5B9HjI/I
         l2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5hLOnlcGooPP+0XvtSeeNz1VtXJ9AXoHVgYzYI06KsA=;
        b=abKFVTmo59l6GJ1RY56aD0I07cpRc1klMunbn1dj+7Z/NhX47WqQNz8ZjgAgPdvb0H
         RYRhj/2YzUvbHs3gyIQiFdoTJ7xKylWCmQgCDgYbOXw5CxY2w7BhX2l14g3aZ7br19nv
         g8NDibuhiuF313HC8ABuk7lqVao7tRooxbR6UyGKMN9cuN8mc/Pjr0reU7pB+AEACzlR
         Xb1W6cGgybDneHnVSr+gXQtMfe6gwjbmanS8/UYV9z6NnftOKyGbzbe1y8LvdQF6Oqk7
         3iiSUQnsIH9LJ1XnW47Jhzi7F6LkClweqma5bn24c06AKbuEzt7QuaLxTt6icgzKu5mn
         fkeg==
X-Gm-Message-State: AOAM53356M9IyrtfP1ReoyhRCIUb9sgePMFnAIsi4ryp71UNaQls+V+V
        e1ZBOtDJ5ntR8t9qvlrraonEZeGFLlUk+2hQeaKdYw==
X-Google-Smtp-Source: ABdhPJxYYJUzDJIQIRkCN9sF34FnxMIAVGCsuFuq1HIAF6U59wUzQTqHWmRiqxOFEAwEu3njJaFbRzFxdY86LhNXKRE=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr56526545edu.221.1625971210207;
 Sat, 10 Jul 2021 19:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131529.395072769@linuxfoundation.org>
In-Reply-To: <20210709131529.395072769@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 11 Jul 2021 08:09:58 +0530
Message-ID: <CA+G9fYvBmvrivr+gnBhTPsYzzMPnRHigGGRNewp6X76n1Qw=Yw@mail.gmail.com>
Subject: Re: [PATCH 4.4 0/4] 4.4.275-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Jul 2021 at 18:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.275 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.275-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on arm64 noticed.

GOOD: v4.4.273
BAD: v4.4.274

Regressions found on  arm64 juno-r2 and qemu_arm64 device.
ltp-containers-tests failed:
- netns_comm_ip_ipv6_ioctl
- netns_comm_ns_exec_ipv6_ioctl
- netns_comm_ip_ipv6_netlink
- netns_breakns_ns_exec_ipv6_netlink
- netns_breakns_ns_exec_ipv4_ioctl
- netns_netlink
- netns_comm_ip_ipv4_netlink
- netns_breakns_ns_exec_ipv4_netlink
- netns_breakns_ip_ipv6_netlink
- netns_breakns_ip_ipv4_ioctl
- netns_comm_ns_exec_ipv4_netlink
- netns_comm_ip_ipv4_ioctl
- netns_comm_ns_exec_ipv4_ioctl
- netns_comm_ns_exec_ipv6_netlink
- netns_breakns_ip_ipv6_ioctl
- netns_breakns_ip_ipv4_netlink
- netns_breakns_ns_exec_ipv6_ioctl



Test output log:
-----------------
module tun: overflow in relocation type 261 val fffffdfffc000654
open: No such device
netns_netlink.c:103: TBROK: adding interface failed

netns_breakns 1 TINFO: timeout per run is 0h 15m 0s
module veth: overflow in relocation type 261 val fffffdfffc040000
module veth: overflow in relocation type 261 val fffffdfffc080000
RTNETLINK answers: Operation not supported
netns_breakns 1 TBROK: unable to create veth pair devices
Cannot find device \"veth0\"

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

step to reproduce:
-------------------------
 # boot qemu arm64 and run ltp netns_netlink test.

          - cd /opt/ltp
          - ./runltp -s netns_netlink

We have started the git bisection script to find the first bad commit
causing these LTP netns test failures.

--
Linaro LKFT
https://lkft.linaro.org
