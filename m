Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172693A6834
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhFNNmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbhFNNmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 09:42:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F803C061766
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 06:40:06 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k25so16766682eja.9
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 06:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=web591Pt5+AQQiKHLxdfvUXAI+r6XXpcpBp1AONGuYI=;
        b=nHXvVeV+RWdRQ8gPuuchzQGLIUzG40Tx94jZVClbV/vg74FWlli0P5wF5ZDGRkpLG0
         KMwsXiXQgq660HJENaaoHpe7Sb+I0PFzGLbho/dIqw8FUQKN4DOEHXPqEnP148qnRwlj
         P/FHPUzH/TcO9QYNYU5N5LQUAQcFGEqoYokCXXW4ngxnSa6zZqfR1GkJqIa0Igxbl7Pw
         o2Bkh4Y4fbTqhCVNJa7QX+cVm3MSPhK4I8RQDbagN8HkWG77jR6wprZDlFZNF9O+FQzq
         015VId31RjCvTOpXJ0DIcKalf+WRniFzL39wJlL5BC7QnF8ehiYi1X3AhERzKCUbGny+
         dGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=web591Pt5+AQQiKHLxdfvUXAI+r6XXpcpBp1AONGuYI=;
        b=fwEJMpBEynXmaSxT0I7W8oIWJ/eY1IAkbwEJcnnKmUomuNVOtC7IIojSZyl78EKyCP
         tsp3YASEoAsmLm5nwnHHVkbia3fdQy0r7Wm+SsqpB2mNa8dAnC1N0SaWaIDEP9KE/Cnq
         O6Av33KUgtP6KTb1uLwLloMvQ4WeouOFCu4S6gljr86lGrRRZwYHZtMTl1t4YRuLMAjq
         rEuqoUxGhWpDXT4IoV1te9ODEfF1MoeqV6vVTWqCdanmtdWAR3qpHzsoOBSOELuLJVVS
         Npu8dhaaTPpX8TMPduB6+lZXTepYfxEYtF4oUmgAV9gC4AMGnqmAOSMjLEivkUrGb/Fq
         eTRQ==
X-Gm-Message-State: AOAM531dFhJrKGIn0OMG6iF/4nk7eTVsoQhSQI5nCuN//Ajdi/HMwpBp
        lyG128ugltSfcBfFlZrgCvLKGIZT6WqNhhgHEFjC+w==
X-Google-Smtp-Source: ABdhPJzSBdx7sGxpqiRcmQ0LmzbbXwVt/v35DOQ9xEKx+nNZRHKXL3MZq2bjf4K462vUGfFm6HYfaX19XreYeacWFck=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr15005693ejb.170.1623678004491;
 Mon, 14 Jun 2021 06:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210614102652.964395392@linuxfoundation.org>
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Jun 2021 19:09:53 +0530
Message-ID: <CA+G9fYuQy0c6_POrWNs51rKyuQ2O-PnY5edCDMDgyGTA-txA_A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/131] 5.10.44-rc1 review
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

On Mon, 14 Jun 2021 at 16:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The following kernel crash reported on stable rc 5.10 arm64 db845c board.
I have not bisected this problem yet.

But there is a crash like this reported and discussed on a mailing thread.
https://lore.kernel.org/linux-usb/20210608105656.10795-1-peter.chen@kernel.org/

Crash log on dragonboard 845c:
[ 0.000000] Linux version 5.10.44-rc1 (tuxmake@7e2c3dff6c75)
(aarch64-linux-gnu-gcc (Debian 9.3.0-22) 9.3.0, GNU ld (GNU Binutils
for Debian) 2.35.2) #1 SMP PREEMPT Mon Jun 14 11:22:34 UTC 2021
[ 0.000000] Machine model: Thundercomm Dragonboard 845c
<>
[    5.095538] dwc3-qcom a6f8800.usb: failed to get usb-ddr path: -517
[    5.113805] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000002
[    5.122686] Mem abort info:
[    5.125531]   ESR = 0x96000004
[    5.128635]   EC = 0x25: DABT (current EL), IL = 32 bits
[    5.134005]   SET = 0, FnV = 0
[    5.137106]   EA = 0, S1PTW = 0
[    5.140297] Data abort info:
[    5.143212]   ISV = 0, ISS = 0x00000004
[    5.147092]   CM = 0, WnR = 0
[    5.150103] [0000000000000002] user address but active_mm is swapper
[    5.156530] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    5.162151] Modules linked in:
[    5.165254] CPU: 7 PID: 251 Comm: kworker/7:3 Not tainted 5.10.44-rc1 #1
[    5.172011] Hardware name: Thundercomm Dragonboard 845c (DT)
[    5.175959] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX,
TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
[    5.177738] Workqueue: events deferred_probe_work_func
[    5.190098] ufshcd-qcom 1d84000.ufshc:
ufshcd_find_max_sup_active_icc_level: Regulator capability was not
set, actvIccLevel=0
[    5.194832] pstate: 60c00005 (nZCv daif +PAN +UAO -TCO BTYPE=--)
[    5.194843] pc : inode_permission+0x2c/0x178
[    5.194851] lr : lookup_one_len_common+0xac/0x100
[    5.207380] scsi 1:0:0:49488: Well-known LUN    SKhynix
H28S7Q302BMR     A001 PQ: 0 ANSI: 6

ref:
https://lkft.validation.linaro.org/scheduler/job/2896831#L2835

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

metadata:
  git branch: linux-5.10.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: 406cd5feace812b3715b6fc8114472b6e3bd6d1f
  git describe: v5.10.43-132-g406cd5feace8
  make_kernelversion: 5.10.44-rc1
  kernel-config: https://builds.tuxbuild.com/1twAFGbHcDipBArvNuGfeOtyY9H/config

--
Linaro LKFT
https://lkft.linaro.org
