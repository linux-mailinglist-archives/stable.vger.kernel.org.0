Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79A334CD21
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 11:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhC2Jbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 05:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbhC2JbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 05:31:23 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77586C061756
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 02:31:21 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id j3so13411151edp.11
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 02:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0j+t6lau5xTyZN2P72KjinwP5BzscTS1+Z8rBvItJNA=;
        b=As83FuzrvlA4PAsvF8I8UtbL+ELomm1SIaKyU9Y0it9//9VkIVdiMWFeK7oHMu/5NY
         CY0hckWcs7H9YTFfbxE4wPlyKW09J/XanL3C7bPbY1yggKTy4vbqhpld0UJ5PUZJ1zR0
         OcgJsSMfQgfXYGRz8J9PiCJJP+x7YbHCN5Itu058jqA3nQf8u+k1EZgCerNVZxO3idFM
         SIYQLZxgDbTRA7mDSRZ1Q7uivFD4j1Q3ed7oDk1TiAUXwc3FFf9d3a5TH5OznX9Ae+hh
         Qhxe1mUs1YH7JOihXjUkd2bTmSyzbsSiHQ24wIXG3ryIPVKhgrtrVN1QTuu6ueEJNA8Z
         WrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0j+t6lau5xTyZN2P72KjinwP5BzscTS1+Z8rBvItJNA=;
        b=ETM0VGb21mKyt81HJATv9BoIoJYud8jkGy5Y+18/FQe4InNWHatQxGIqukuxN7K9IY
         CUM93Nw2qjVzfJJynE2lEIOilD3WrdkShb9eOEQUE+ZT457WgTiBCL+Zih8pyyomF7NM
         ZCU07IN/tF3Jzz/5VM5267ODJhA0TgGIYJPdds/FvmzXD7+X6w8/Wt1vem7nJvwOOK5X
         LH+Ann02gBLw5Py0FApEVVMVwfh22uz5KgukmJRSAlUxnENlTMoKbyL1+qr+2tQQwypd
         azN3fhNiauPRa+Z/bAYgHebe5b+6dP3MoOnqOrDhxV4yuOeXvOj5QRhcHHPawqrvWv0o
         mf9g==
X-Gm-Message-State: AOAM533YuwmDkwSNzGOiqTdYy50SYNUTmCCwi/lhUyHbQSaPI6ulL5UC
        qJTet37HkY7pdB0gz64wo66sQtUI2zIF6nozhpXVUA==
X-Google-Smtp-Source: ABdhPJy2W9+TrQcuiH1qBAXDKRO6qa4K/TX7ougyqx0JlJ5hAamJsxm1rPu85qWVjBoq750+Lu+UWUG+yX0e0Gy0Wds=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr27672618edx.365.1617010280122;
 Mon, 29 Mar 2021 02:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075629.172032742@linuxfoundation.org>
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Mar 2021 15:01:08 +0530
Message-ID: <CA+G9fYvGQr1dyCqTnK1qOO-9Hn24gU8VwSYEMvU22H4hz9yiwg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/221] 5.10.27-rc1 review
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 at 13:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.27 release.
> There are 221 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.27-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The stable rc 5.10 and 5.11 builds failed for arm64 architecture
due to below warnings / errors,

> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: define arch_get_mappable_range()


  arch/arm64/mm/mmu.c: In function 'arch_add_memory':
  arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
[-Werror=implicit-function-declaration]
    VM_BUG_ON(!mhp_range_allowed(start, size, true));
               ^
  include/linux/build_bug.h:30:63: note: in definition of macro
'BUILD_BUG_ON_INVALID'
   #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
                                                                 ^
  arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
    VM_BUG_ON(!mhp_range_allowed(start, size, true));
    ^~~~~~~~~

Build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull

--
Linaro LKFT
https://lkft.linaro.org
ReplyReply to allForward
