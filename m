Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5E3432C52
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 05:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJSDke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 23:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJSDkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 23:40:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE66C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 20:38:21 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id t16so7399288eds.9
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 20:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6v/Mt4fBV71aSvKwsHjvF9UUdBQqDQB9fIY21m5wO4=;
        b=Qo2PQdjlT2H4b7oUHJF/iAJHs1k0Nn9sRTGKIIP6S4dCs0FKYY+2755mSc1m+EmJml
         UnDUQEYEjCEGXNV1crZrgNCB5MyqvgKh8x4Z6qFcXOTBueUo1hY6j78tAqqHj555vaVu
         NEOQTspae33UyLoKqDruDgcYi2neb8MN9ltFOo0N5LtGOpsSSU139wj1DubDxD0whHst
         fHDjqKr1fkz4CR5hxSTwbjfhEehZORiIQvYyH6oNA7mGNqfWGqkuCaosryFc/Px9OnJ4
         A1sCR6MX3U3IljJ6xR9tRoeeOhpD1+soy33I9fbQDOM3oespuz7Ni61eDZVg22in66SV
         4IIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6v/Mt4fBV71aSvKwsHjvF9UUdBQqDQB9fIY21m5wO4=;
        b=Q4W+dKbAV8cQM7onu7ZlzqI6hgS7ZBvdqwOhb9bsxXOnJGQqccY1WjCowve7wjxEcO
         LDa+spT7ZS+BciSkTwJ9V8qj/NLSETwfrcRV+BPFrffBsY+qHsbFHsxi244HhzPVCLpI
         TPxTL8FweOaieWyiGpn50fCgV3vKXH4RcRshfMLA1YwB7S5OH5d+pahnwfvs21Y8KkmH
         q0cb93ehOGJehfHr1zIOO+GYYert5abqaYAAHdQMz/nC4VDngYPME7P/CbOnF4hsdlU9
         KjnUbAVObv+dxrJRgYDrzUsevVBCkLrMm1SwyqQg8f/344U9PnF4w4IKb0tT0rq0wA2a
         YQYQ==
X-Gm-Message-State: AOAM531o+FZZVScdX8BTR29MpkIcXcB9SQoFsSJ1F8BFkTetxBz5TTEl
        EnC7DV9R8BcCkYKZYuNhEYAAHwsyl+FPB2TExJJDVw==
X-Google-Smtp-Source: ABdhPJzsvq+63J4r045SwxshqJsbP5kyW2EiHEjzKuP7+1Kehol6CsymXj6wY93upNjaXmuKU5DSYwHrbLe3wmlSj2U=
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr50064702edc.182.1634614699563;
 Mon, 18 Oct 2021 20:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211018132340.682786018@linuxfoundation.org>
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Oct 2021 09:08:08 +0530
Message-ID: <CA+G9fYtLTmosatvO8VBe-RDjEHEvY01P=Fw5mvRvwbxL31ahOA@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jens Wiklander <jens.wiklander@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 at 19:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build errors noticed while building Linux stable rc 5.14
with gcc-11 allmodconfig for arm64 architecture.

  - 5.14.14 gcc-11 arm64 allmodconfig FAILED

> Sudeep Holla <sudeep.holla@arm.com>
>     firmware: arm_ffa: Add missing remove callback to ffa_bus_type

drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int
(*)(struct device *)' from incompatible pointer type 'void (*)(struct
device *)' [-Werror=incompatible-pointer-types]
   96 |         .remove         = ffa_device_remove,
      |                           ^~~~~~~~~~~~~~~~~
drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for
'ffa_bus_type.remove')
cc1: some warnings being treated as errors

Build config:
https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

steps to reproduce:
https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
