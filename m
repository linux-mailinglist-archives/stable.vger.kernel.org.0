Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B628637D36
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 16:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiKXPry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 10:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKXPrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 10:47:52 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16291DA7E
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 07:47:48 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id e141so2223762ybh.3
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 07:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h4SSPuvhYffhFxePiwJ39RwPGg7tQbtiVDjXCFISW8g=;
        b=LsbRhfvUIWkKiDqkYWNoaVfGGGmdnrw2/hWFF6wuZr6aOhLs75ccrr8mys9fid0xyP
         ZtAWcd5VCQMrmfDx6SMNWGWwINeFFL/MHgpxCZny0dMc/B9OsIRAexstOZIgM7gK/q5f
         kGRkEMohMduN2R5W2ZqF7WzqTteeMYYoEsKH57gm1iBQQVvYKCGdCiTTE1edsZLPmoap
         37x3JLMBouAUxW2AOzzDAKb/oK8/Pc/TtQkUbtrVix0G85Sr3hCDUD0NMxshPkrvSk6M
         7GHoy+DdE4/zzWxVCnEvWRukfe7l/DzoPrr/u3YdJkU85XP6+tkYb6jrbB6kQ5eMQLWw
         bnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4SSPuvhYffhFxePiwJ39RwPGg7tQbtiVDjXCFISW8g=;
        b=hTBAOQAeH5bcGlZTQcHAKxQYnbxTSLijBBJgkX7GmrGDB3bpTVX2O0bYc6jp9+EEwS
         2FaolU/wMqHMDjgqMDtuw+TgUDs9MLg67/e+hSIjal/VpKAi71gJYuVGLGkf37YDReVT
         ppo920M/Z9yUj6p18nAvQlbgH8+cs5lR8Iwfix+WpE9MOBu1Yr8u5rr+cWVofSD0j3WJ
         oxL/iJs3cEIGIOvgDHaY7gZ956zEHLZYAi4bK6rD7G/hja6wtG+o9mj9PCWRs83cPuOw
         hkSJhOvIJKso7ukaxy5+V7g0yE5KY98Cn/hch2GERwiY3iJHJoqd6IgugyeQMlsuLZOW
         bIwg==
X-Gm-Message-State: ANoB5plKFvCoWc+oLjEO4c+Bqx5IGzGhXYom0pdBZCRYVqD+L2uklH4G
        sxZUHp1Fr/dIa2U0OOHbW4cBIOLn10KhwOHMJcHceg==
X-Google-Smtp-Source: AA0mqf5kc8lHtLyUfaXXXit+VFn6RsjS45esjbJUMBQ3kt/egSQtBW3It5ZQsDAj2Mmdm6OXhRf/Ub3gqeuh4oaeSsg=
X-Received: by 2002:a5b:f0f:0:b0:6d2:5835:301f with SMTP id
 x15-20020a5b0f0f000000b006d25835301fmr21381074ybr.336.1669304867700; Thu, 24
 Nov 2022 07:47:47 -0800 (PST)
MIME-Version: 1.0
References: <20221123084557.945845710@linuxfoundation.org> <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
In-Reply-To: <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 24 Nov 2022 21:17:36 +0530
Message-ID: <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Nov 2022 at 19:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Wed, 23 Nov 2022 at 14:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.156 release.
> > There are 149 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> With stable rc 5.10.156-rc1 Raspberry Pi 4 Model B failed to boot due to
> following warnings / errors [1]. The NFS mount failed and failed to boot.
>
> I have to bisect this problem.

Daniel bisected this reported problem and found the first bad commit,

YueHaibing <yuehaibing@huawei.com>
    net: broadcom: Fix BCMGENET Kconfig


> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
>
> [    0.000000] Linux version 5.10.156-rc1 (tuxmake@tuxmake)
> (aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0, GNU ld (GNU Binutils
> for Debian) 2.39) #1 SMP PREEMPT @1669194931
> [    0.000000] Machine model: Raspberry Pi 4 Model B
> ---
> [    3.253965] mmc0: new high speed SDIO card at address 0001
> [    7.229502] bcmgenet fd580000.ethernet eth0: Link is Up -
> 1Gbps/Full - flow control off
> [    7.237710] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [    7.253259] Sending DHCP requests ......
> [   81.086546] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[42e6766b]
> [   89.106504] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[42e6766b]
> [   98.657252]  timed out!
> [   98.683997] bcmgenet fd580000.ethernet eth0: Link is Down
> [   98.691276] IP-Config: Retrying forever (NFS root)...
> [   98.698404] bcmgenet fd580000.ethernet: configuring instance for
> external RGMII (RX delay)
> [   98.707190] bcmgenet fd580000.ethernet eth0: Link is Down
> [  102.813504] bcmgenet fd580000.ethernet eth0: Link is Up -
> 1Gbps/Full - flow control off
> [  102.821680] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [  102.841257] Sending DHCP requests ....
> [  119.840915] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[34e6766b]
> [  127.860148] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[34e6766b]
> [  132.513252] .. timed out!
>
> [1] https://lkft.validation.linaro.org/scheduler/job/5880584#L392
>
> --
> Linaro LKFT
> https://lkft.linaro.org
