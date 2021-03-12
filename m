Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD44339828
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 21:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhCLUY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 15:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbhCLUYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 15:24:11 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEB0C061574;
        Fri, 12 Mar 2021 12:24:10 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so11619538pjb.2;
        Fri, 12 Mar 2021 12:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=McbnXM+kiRQEBgpIuZLeYsdY/J8NTO03vNbmYL9lEEc=;
        b=V7f65MekivXFCb+FiqY/MBKQX9Ni5kOIPy7i9DhzW+ViKxT5T59VelMtenFEzYUuT+
         44VsDbiZGbkG9sZJq5b5KWwxcIM0wXHDw7+HAtya4SMRSDiKcL87JsXqTMfLrHcPAlgA
         c3HzqNYHJwzqdVgENlgCbvZgIXP6UQ/4U/+kPQ+W0itdszaiSG15WYX0UFHmCnc5ZzJc
         oPAMZ1EF670MvBky7igM0skcZYspRuXnjHYhd8/WZPVpJ516vtnDj3KDc/AdlY+hfOb0
         7c/BKAhndLvaXKCfkie4KcCpu0cfK3q9jbxY7Sxedjpy4+loH/ua8Z23LWH6BrYxPH7G
         Ll0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=McbnXM+kiRQEBgpIuZLeYsdY/J8NTO03vNbmYL9lEEc=;
        b=anT3EPS9B2rtr8uhWqnw7waj7QyrQjA+yRJ4KwkDCFN9hiKMwQcmUO8ZZ4a2sHH12r
         wD7RfLuALjSbtGjtfIfJ0J1T7cdpeJAKozLtrhZMEpR1jveSB7Br5o0c8RIaO4nVzqys
         oTunP6B+i/+7tVXlFvkcqAmPfUWrlVbGVf7kdWZd8rV6RV5aBpfhj5x6vcPrB2P1mCsf
         ETZJM/TdMTnayAYMKs+JGxfy7k2a9VXbEnDCSSBAXDnX7UdlMXGjGZfFXuabPCPqD42F
         CAIXAJHxjukg+L5kmeFi2Y0VMAnI15XHQER/O/HT+YuMAUHPobeyGodBjTMcCI6wk8UV
         izhQ==
X-Gm-Message-State: AOAM530FMi698pfJ1/r1FCiEvfn02nB2MXGtUpjTMdH/U5TZNYHwcbis
        RIIr2J+lI2YGlgi5rspEnhp0xrK9tMQ=
X-Google-Smtp-Source: ABdhPJyCAio1zOBHRM2VS3CSqMEGXj7yCI3QQNUrr3x6tl4qr1BrELgDZgXj0wzp5vRn9lJuI/Ln0Q==
X-Received: by 2002:a17:90a:e542:: with SMTP id ei2mr61578pjb.134.1615580649910;
        Fri, 12 Mar 2021 12:24:09 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w4sm2818144pjk.55.2021.03.12.12.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 12:24:09 -0800 (PST)
Subject: Re: [PATCH 4.9 00/41] 4.9.260-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210305120851.255002428@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7f9b37bf-4ba1-fa92-1b51-084fcb8e2dc4@gmail.com>
Date:   Fri, 12 Mar 2021 12:24:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/5/21 4:22 AM, Greg Kroah-Hartman wrote:
> Ben Hutchings <ben@decadent.org.uk>
>     futex: Futex_unlock_pi() determinism
> 

Hi Ben,

This particular commit above eventually triggered the following warning
below, this was not caught in my initial testing of the v4.9.260 kernel,
when I gave my Tested-by tag. This appears to be easily reproducible
upon initialization of one of the modules being loaded for that test.

Are there additional changes that we are missing in linux-4.9.y with
respect to futex code?

[  233.128367] ------------[ cut here ]------------
[  233.133104] WARNING: CPU: 3 PID: 1845 at kernel/futex.c:1584
do_futex+0x800/0x974
[  233.140707] Modules linked in: wakeup_drv(O) nexus(PO) brcmv3d(O)
[  233.146950]
[  233.148511] CPU: 3 PID: 1845 Comm: nx_sched_idle_s Tainted: P
   O    4.9.261-1.22 #1
[  233.157072] Hardware name: BCX972180SV (DT)
[  233.161326] task: ffffffc075e12e00 task.stack: ffffffc073110000
[  233.167328] PC is at do_futex+0x800/0x974
[  233.171410] LR is at do_futex+0x784/0x974
[  233.175490] pc : [<ffffff800810f468>] lr : [<ffffff800810f3ec>]
pstate: 600001c5
[  233.183003] sp : ffffffc073113d10
[  233.186380] x29: ffffffc073113d10 x28: 0000000000000000
[  233.191800] x27: 0000000000000735 x26: ffffffc073113df8
[  233.197220] x25: ffffffc07401bc90 x24: 0000000080000735
[  233.202638] x23: ffffffc073110000 x22: 0000000000000000
[  233.208055] x21: 000000000c0cd220 x20: ffffffc07401bc80
[  233.213472] x19: 0000000000000001 x18: 0000000000000000
[  233.218890] x17: 0000007f82b8dfe8 x16: ffffff800810f5dc
[  233.224309] x15: 00000b1a97b40980 x14: 0033240a01207260
[  233.229727] x13: 00000000604b3cb0 x12: 0000000000000018
[  233.235144] x11: 000000000636eae9 x10: 00000000000000e9
[  233.240562] x9 : 003b9aca00000000 x8 : 0000000000000062
[  233.245979] x7 : 0000000000014e26 x6 : 0000000000000000
[  233.251396] x5 : ffffffc07401bcb8 x4 : 0000000000000000
[  233.256814] x3 : 0000000000000001 x2 : 0000000000000000
[  233.262230] x1 : 0000000000000000 x0 : ffffff8008cdf7dd
[  233.267644]
[  233.269192] ---[ end trace 18db5bc47ae34623 ]---
[  233.273877] Call trace:
[  233.276389] Exception stack(0xffffffc073113b10 to 0xffffffc073113c40)
[  233.282913] 3b00:                                   0000000000000001
0000007fffffffff
[  233.290873] 3b20: ffffffc073113d10 ffffff800810f468 00000000600001c5
000000000000003d
[  233.298833] 3b40: ffffffc07401bc90 ffffffc073113df8 000000000c0cd220
0000000000000735
[  233.306791] 3b60: ffffffc073113bd0 ffffff800810e004 0000000000000000
ffffffc073113cd0
[  233.314751] 3b80: 000000000c0cd220 ffffffc073110000 0000000000000000
ffffffc073113cd0
[  233.322711] 3ba0: 0000000000000000 ffffffc076b65bc0 ffffffc073113bd0
ffffff800810e1a4
[  233.330670] 3bc0: 0000000000000000 00000000000409ff ffffffc073113d10
00000000000409ff
[  233.338628] 3be0: ffffff8008cdf7dd 0000000000000000 0000000000000000
0000000000000001
[  233.346586] 3c00: 0000000000000000 ffffffc07401bcb8 0000000000000000
0000000000014e26
[  233.354545] 3c20: 0000000000000062 003b9aca00000000 00000000000000e9
000000000636eae9
[  233.362506] [<ffffff800810f468>] do_futex+0x800/0x974
[  233.367638] [<ffffff800810f738>] SyS_futex+0x15c/0x184
[  233.372861] [<ffffff8008083180>] el0_svc_naked+0x34/0x38
-- 
Florian
