Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B093A75A5
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 06:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhFOENo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 00:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhFOENo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 00:13:44 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF106C061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 21:11:38 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g18so47255278edq.8
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 21:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xf+ppaOavJa4FbRMvUgbiviXSm9wb7B+jcy4AwONiss=;
        b=DPjp73xj0bPxaDO+CvFruBinLpBb3nksSn7akB9av9XgXboAVlbY2kueaTReVJgbzE
         E5SeaeC06kK2HRHdeZQo4uZLqja9s3tuKn8Q5fSSU8PtYC8RMLqYHW5AdED01lL2vuCJ
         ke9PJxHEKRCRl+yYCU0TXkHZtYh3JzgzVDJ4uoBTDmAd77neFXEbo+MDG8DhT03mGLTu
         JQB8Chg7IRCJF6dt29HcRwC2URl6+cuPwE8SnOONyfAzxuDEg5hUvHmhKd5PWcWxh/4D
         mRu8SdRkO2Hl3km+NGHZ6ECeWZQ31qq1X+TuZufyuLrw4LhI+rMYYlKKWJSSQgMaDcFP
         /RNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xf+ppaOavJa4FbRMvUgbiviXSm9wb7B+jcy4AwONiss=;
        b=ojMbUusRIXc6XkZZFsHcjaIq0+n4PgWD9B0O65hMuM4uYzSxL4z87yTi6gg7ITVbuT
         TN979e/gc4Fvd/AKCBo0gsSkCwjl6lWpBIDZldvHGzj4Uec3CaLRKPP/oS0/2XYZ0ynH
         VoGdZTJwoXhLF3cuAHxxxgMHF5UOEfv+7wiSU3Jn+CRXq37TTNyMi6T4+aRUUrHOqS6z
         SlICtNFiN0XihrjA+6ieYIYCw6a73K9NOT4Gt0vAUYAIFNXYDD1ZtrTiR9c/1uBnyupg
         T/l9RYlb3uDSOHCmM9C9PDxy8WPo38EGgIoF4IeCJV9QbEvOorugdPDtMECJiDp1qELc
         UAlw==
X-Gm-Message-State: AOAM531uWmwfg3fi8ekkr5ejd935LKn4ZzzAH5OmuiU9jSUE4opCvm+V
        7xoBbCQhZhhZNdja0iBKirELqCDvOlehwLRZvnxUnQ==
X-Google-Smtp-Source: ABdhPJwEM6M1ppIVZKMbekWPKdaG8sqBBdieF8fvmVvz67P3jkdBWzyGmFEBHtPraZkh0JtVKsxyrSNpTcHuZvp4apY=
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr12550897edb.52.1623730297198;
 Mon, 14 Jun 2021 21:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210614161424.091266895@linuxfoundation.org>
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 09:41:26 +0530
Message-ID: <CA+G9fYsfvtr7NNcb0bvEZpYYotdY7Uf+wMY22iLhr0weZ8Om3g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-usb@vger.kernel.org,
        Peter Chen <peter.chen@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, 14 Jun 2021 at 21:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following kernel crash reported on stable rc 5.10.44-rc2 arm64 db845c board.

[    5.127966] dwc3-qcom a6f8800.usb: failed to get usb-ddr path: -517
[    5.145567] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000002
[    5.154451] Mem abort info:
[    5.157296]   ESR = 0x96000004
[    5.160401]   EC = 0x25: DABT (current EL), IL = 32 bits
[    5.165771]   SET = 0, FnV = 0
[    5.168873]   EA = 0, S1PTW = 0
[    5.172064] Data abort info:
[    5.174980]   ISV = 0, ISS = 0x00000004
[    5.178860]   CM = 0, WnR = 0
[    5.181872] [0000000000000002] user address but active_mm is swapper
[    5.188293] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    5.193922] Modules linked in:
[    5.197022] CPU: 4 PID: 57 Comm: kworker/4:3 Not tainted 5.10.44-rc2 #1
[    5.203697] Hardware name: Thundercomm Dragonboard 845c (DT)
[    5.204022] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX,
TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
[    5.209434] Workqueue: events deferred_probe_work_func
[    5.221786] ufshcd-qcom 1d84000.ufshc:
ufshcd_find_max_sup_active_icc_level: Regulator capability was not
set, actvIccLevel=0
[    5.226541] pstate: 60c00005 (nZCv daif +PAN +UAO -TCO BTYPE=--)
[    5.226551] pc : inode_permission+0x2c/0x178
[    5.226559] lr : lookup_one_len_common+0xac/0x100

ref:
https://lkft.validation.linaro.org/scheduler/job/2899138#L2873

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

There is a crash like this reported and discussed on the mailing thread.
https://lore.kernel.org/linux-usb/20210608105656.10795-1-peter.chen@kernel.org/

metadata:
  git branch: linux-5.10.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: 3f05ff8b337097d73b2c408d60befe39dac31bb8
  git describe: v5.10.43-131-g3f05ff8b3370
  make_kernelversion: 5.10.44-rc2
  kernel-config: https://builds.tuxbuild.com/1twkN9cmRWOK3boqZes7Yi1t0OO/config

--
Linaro LKFT
https://lkft.linaro.org
