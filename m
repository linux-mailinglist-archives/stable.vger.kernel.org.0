Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB9133C7E6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhCOUmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhCOUm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 16:42:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE40C06174A;
        Mon, 15 Mar 2021 13:42:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bt4so9450517pjb.5;
        Mon, 15 Mar 2021 13:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O6e8S7lh6iAwMopRVdoRppSa4LuJ+ayzrZbrIdMcAvU=;
        b=B2ZkDvaAj+Bp0Qzw0qkFL5KfWIaPT7HH3yGSGINZ70hMsMP78DCawnP2aK/j3gfikE
         6mJX2QHwgPqtMH/xLMMqZRug9agGhKiZF+0lPwNok/2zFimS12sL/Hfa5mK9TxMz7Pw7
         pK5eD10SdJo49R7Q1Bar2lmzlckM8cOiTEHBAOa7RlWqm/xt/xpUQdOvLQ8nQXC0fjef
         1FM9cD46b1uPD/iclC8CfdSOxm6hLpaYCCF08uv/npw0k44OS3xmUApWpIRUhcV5//cx
         CbOgNwscEeod/ckQ2pHrEKj5slLnApTO03GD7kgKirj7hMOTBdDYRZDtXh+xX5e8xtjA
         zBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O6e8S7lh6iAwMopRVdoRppSa4LuJ+ayzrZbrIdMcAvU=;
        b=TIUr1lfMnF8GziQuQwOFR+emlH9flE68CqglgKJr6bcv2zlqWq+ZUgt4mTM0ybL02q
         8l4XLATgvqlIyF3ZeX4RnSQNQSJirKjYe4ioQvI+sSRgc/wYidQmupMowbnh2ULOVk84
         SyDQChEr6s+M1SvMU0uUvSxcP9STx3Lmh2yc6N4l9SUB3wYBrQjF9aF0j1ImUrKSW0oS
         0VuSwV2lelcdlqwVZ2kMF8gImaTomr+DFbghdXOH0Gs/yA3zJoI4Kqn/B/go5oOYQIwd
         rRzlQm9+goI5xgI/yeNpYBdK20tA1ZM3GYp3ck9orF9BGeBVPTjh5UzxES4bksDfOiVw
         lJWw==
X-Gm-Message-State: AOAM533aFtVdBEPwxu/7jNkW835RwD2vH6ra57EJDfZf0NT5jc8f0lqH
        2WQX328Ut9w2/62pkn9GcboNSo5twb0=
X-Google-Smtp-Source: ABdhPJzv4HCdbNqFTYAiNiPmpXDxe8kGt5XtOLngOQl2RkR/z+SpaqhCj1uU7m4WaANyftZsfiFnWA==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr924038pjp.96.1615840944027;
        Mon, 15 Mar 2021 13:42:24 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w79sm14955596pfc.87.2021.03.15.13.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 13:42:23 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/78] 4.9.262-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210315135212.060847074@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11774be7-0738-1a23-f186-0875b9e82ef6@gmail.com>
Date:   Mon, 15 Mar 2021 13:42:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/15/2021 6:51 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.262 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:51:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.262-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, still seeing the
following futex warning, unfortunately simply running the function
tracers does not allow me to trigger the warning, so I am having a hard
time coming up with a simple reproducer:

*** 0[   66.551916] ------------[ cut here ]------------
[   66.557855] WARNING: CPU: 3 PID: 1628 at kernel/futex.c:1584
do_futex+0x800/0x974
[   66.565457] Modules linked in: brcmv3d(O) wakeup_drv(O) bcmdriver(PO)
[   66.572048]
[   66.573609] CPU: 3 PID: 1628 Comm: boot Tainted: P           O
4.9.262-1.22pre-g4c1466bf10ac #2
[   66.582693] Hardware name: BCX972160DV (DT)
[   66.586936] task: ffffffc07ae92280 task.stack: ffffffc0016ec000
[   66.592923] PC is at do_futex+0x800/0x974
[   66.596992] LR is at do_futex+0x784/0x974
[   66.601057] pc : [<ffffff800810f470>] lr : [<ffffff800810f3f4>]
pstate: 600001c5
[   66.608547] sp : ffffffc0016efd10
[   66.611912] x29: ffffffc0016efd10 x28: 0000000000000000
[   66.617313] x27: 000000000000065c x26: ffffffc0016efdf8
[   66.622713] x25: ffffffc079bf9090 x24: 000000008000065c
[   66.628112] x23: ffffffc0016ec000 x22: 0000000000000000
[   66.633511] x21: 000000000d72fbb0 x20: ffffffc079bf9080
[   66.638912] x19: 0000000000000001 x18: 0000000000000000
[   66.644313] x17: 0000007f845adfe8 x16: ffffff800810f5e4
[   66.649713] x15: 000017d28638a692 x14: 00055d4a5b4a1ca0
[   66.655114] x13: 000000000000012d x12: 0000000000000018
[   66.660514] x11: 000000001f758ce6 x10: 0000000000000042
[   66.665915] x9 : 003b9aca00000000 x8 : 0000000000000062
[   66.671314] x7 : 0000000000007070 x6 : 0000000000000000
[   66.676714] x5 : ffffffc079bf90b8 x4 : 0000000000000000
[   66.682112] x3 : 0000000000000001 x2 : 0000000000000000
[   66.687512] x1 : 0000000000000000 x0 : ffffff8009b0f7dd
[   66.692909]
[   66.694444] ---[ end trace cc7627749f0e27f6 ]---
[   66.699114] Call trace:
[   66.701614] Exception stack(0xffffffc0016efb10 to 0xffffffc0016efc40)
[   66.708121] fb00:                                   0000000000000001
0000007fffffffff
[   66.712143] arm-scmi brcm_scmi@0: mbox timed out in resp(caller:
scmi_perf_level_set+0x80/0xc0)
[   66.712155] cpufreq: __target_index: Failed to change cpu frequency: -110
[   66.731690] fb20: ffffffc0016efd10 ffffff800810f470 00000000600001c5
000000000000003d
[   66.739624] fb40: ffffffc079bf9090 ffffffc0016efdf8 000000000000065c
ffffff8009a26000
[   66.747559] fb60: ffffffc0016efb80 ffffff80080ddbec ffffffc0016efb90
ffffff80080cf2ac
[   66.755492] fb80: ffffff80099f6000 ffffff80080de170 ffffffc0016efc50
ffffff80080c88e8
[   66.763426] fba0: ffffffc07a6da280 ffffffc07a6da4a0 ffffffc0016efbc0
ffffff80083d531c
[   66.771360] fbc0: ffffffc0016efc00 ffffff800808e5c4 0000000000000008
00000000000409ff
[   66.779295] fbe0: ffffff8009b0f7dd 0000000000000000 0000000000000000
0000000000000001
[   66.787227] fc00: 0000000000000000 ffffffc079bf90b8 0000000000000000
0000000000007070
[   66.795160] fc20: 0000000000000062 003b9aca00000000 0000000000000042
000000001f758ce6
[   66.803095] [<ffffff800810f470>] do_futex+0x800/0x974
[   66.808211] [<ffffff800810f740>] SyS_futex+0x15c/0x184
[   66.813415] [<ffffff8008083180>] el0_svc_naked+0x34/0x38

other than that:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
