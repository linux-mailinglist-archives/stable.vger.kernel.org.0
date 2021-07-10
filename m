Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204AC3C3506
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 16:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhGJPC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 11:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhGJPC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 11:02:28 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586CFC0613DD
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 07:59:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eb14so18895823edb.0
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 07:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iwTsN5XOKXGhzX4XQB3p4yZQwijxEvvf7WDBj5MTa9A=;
        b=UZR7w0fUXOBaXILPOT6PxJCRyaCG+vo4HEC7wf6nVb1nO/MVCduuCzWZzrduiRdprX
         9wmIzTxnu4/qog/8zxgcLvVHY7FYCb4o3ea3XF7UiEi9fi9C6Uqpmp0rUmRzeUtcdM2J
         zt+eVvDISVMwdzZiIqMcmXgDYio3GhzTD7XiIlKxp44oFAgeat/G0FQKMNHiubUAEslR
         WsM+jJx/lZRyqQYlMt54+x6RMaiLgWTMM0bXAhWFL326DR9bQJdNJN8DxV4mOAkcT0Qi
         usBJpO/xyHjKpjLuSrrswdI4DARn6S7QQpPJE057xKQlV81/igb5fZjxaRxcI4hSiL8a
         WLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iwTsN5XOKXGhzX4XQB3p4yZQwijxEvvf7WDBj5MTa9A=;
        b=Kb5SViM3r907aO9MA+wC1uE3+ytSnEODVQF48wkm9/CBGCZWWIlnLSf7Aw8jZu8Mao
         niRIR9WtbI9VpgUS9uhgphzYYXJhhAUfZX2lAw+OWUVM6DXQMXLvQJsLfhLMUNdknn6m
         rz/FO5OYLzw9B+FDzW/f7zRsVM37bUPkKhKdPnpl5cuSvQLcSYNDq5w+IxKl+WtX3NSW
         efOOXmawbq8qjs124H//oeHzjed3P+/W4IffjXQ90DCTroDdIr4bbryHSJJQ58TwRL8M
         iKxLB6aRHT6qPsNy2Gbgohx45lww2yuUoFJY6WN/J6XanWJX8j7sY2tFYT7cKq57qVN/
         wqXw==
X-Gm-Message-State: AOAM532/V+BJuPpbiBShECQqfPKe92fJ/aij2IdZ+egM3jSacvyRAJ0d
        i7QyUx7C2acMS9L4a9Oz3C6HjcuIobnz+ehr330yAg==
X-Google-Smtp-Source: ABdhPJwEISgCDO6/PMaZvrOPVUKQiplGmAwbZYCHwVAalCGrawZ22ynWE1pg8CCGrCpGnuERXiXNA/32bRarctOdYDA=
X-Received: by 2002:a05:6402:90a:: with SMTP id g10mr54186908edz.365.1625929181816;
 Sat, 10 Jul 2021 07:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144256.34524-1-sashal@kernel.org>
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 20:29:30 +0530
Message-ID: <CA+G9fYv6u7fWHqz6-5Wk9iAk0D5eSSDQEAO+FW_0RS30Yuix=g@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/57] 4.4.274-rc1 review
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 at 20:16, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 4.4.274 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 30 Jun 2021 02:42:54 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-4.4.y&id2=3Dv4.4.273
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha


Results from Linaro=E2=80=99s test farm.
Regressions on arm64 noticed compared with v4.4.273.
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


We have started the git bisection script to find the first bad commit causi=
ng
these LTP netns test failures.

--
Linaro LKFT
https://lkft.linaro.org
