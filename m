Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD02636110
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 15:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiKWOFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 09:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbiKWOFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 09:05:01 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A914856ECD
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 06:00:56 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id x24so295949uaf.4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 06:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WTYTRYk6f/wEnl7mJzNrGBfYtp6molz9on9Z5eyVh7Y=;
        b=dOyMTxXjwVGwKVthIhRYDaAtrpahmmifx8Qf979kDzdG0O/ly0ey6ZDqNlFtRNv0AZ
         MyT2vWpH1YkG0bi8xh2pfB3jFxZW4ZdpH9ABAlvtdqPgGq91GkzUqq5Xy7e/WrsONF3h
         2Yx9mKtvq/I4tZS5dehNlBDNTUbfEpbokf7NdBWRPbQ2uhQRb1OFOzKJQYRNkJ+1gMK6
         527rH3q6Rxu2s6TlwOGnCyv8f4dVbAPTZBahB8OLE1x0YHAR07AIV/nOTD1BviYEXQev
         sn59XdvndRwckymR2UIH3GH0jWU9TzCkcTwfhWWEQQS9RvMWn1L3FCljBfQ8Vp9UfsRw
         YpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTYTRYk6f/wEnl7mJzNrGBfYtp6molz9on9Z5eyVh7Y=;
        b=vCJnF3OxhqR0J4qN5X3jPT/MRsAggnGH+2alwOplRfTMUv36qQ3v15HvSoKnxJ5Tr2
         YHN178tnWZuuvbMifijndZC6JL9Xt4qyPOMwfVTup/GVx6YSD5F4TlkeLavht31PWVU+
         wKHU67j/OBk+m05ijsMJaO4jKx1uBZcmZTY13Cife9m+ZGNe5v5ORU8AgQb1qWoLjfuK
         20st9PBnab4iRiH7dKIMLIbzcyOeru7NgcERNh4kxJNYecaoK4vJPJS2XHCj2KyEuQIA
         Lq+gn3pK0W+Jd3MhymBM6DPpH1f15fsa36kQwaD0+0V8oWFJSTkFRqOqtHVdA29fWb0w
         xT2A==
X-Gm-Message-State: ANoB5pmT6tRetM6aumfb6Mu4hmLZOqHjABXUaLq/OzhmL3N8ja3nZgzF
        HFrrW0eXyl8iiT+MpuO18n6p/uIyym16ABerOyUQw2v7WQk0iw==
X-Google-Smtp-Source: AA0mqf5sFmUBzHQ+l6kKNO0dh5atgZv8TBPL9cQGGpRXs3zWuwYppj+h7nEHVfjqs/k/q5ZejLgXlnCiIXc05201a7E=
X-Received: by 2002:a5b:f0f:0:b0:6d2:5835:301f with SMTP id
 x15-20020a5b0f0f000000b006d25835301fmr16235642ybr.336.1669212026059; Wed, 23
 Nov 2022 06:00:26 -0800 (PST)
MIME-Version: 1.0
References: <20221123084557.945845710@linuxfoundation.org>
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 23 Nov 2022 19:30:14 +0530
Message-ID: <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
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
        Paolo Abeni <pabeni@redhat.com>
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

On Wed, 23 Nov 2022 at 14:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


With stable rc 5.10.156-rc1 Raspberry Pi 4 Model B failed to boot due to
following warnings / errors [1]. The NFS mount failed and failed to boot.

I have to bisect this problem.


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


[    0.000000] Linux version 5.10.156-rc1 (tuxmake@tuxmake)
(aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0, GNU ld (GNU Binutils
for Debian) 2.39) #1 SMP PREEMPT @1669194931
[    0.000000] Machine model: Raspberry Pi 4 Model B
---
[    3.253965] mmc0: new high speed SDIO card at address 0001
[    7.229502] bcmgenet fd580000.ethernet eth0: Link is Up -
1Gbps/Full - flow control off
[    7.237710] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.253259] Sending DHCP requests ......
[   81.086546] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[42e6766b]
[   89.106504] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[42e6766b]
[   98.657252]  timed out!
[   98.683997] bcmgenet fd580000.ethernet eth0: Link is Down
[   98.691276] IP-Config: Retrying forever (NFS root)...
[   98.698404] bcmgenet fd580000.ethernet: configuring instance for
external RGMII (RX delay)
[   98.707190] bcmgenet fd580000.ethernet eth0: Link is Down
[  102.813504] bcmgenet fd580000.ethernet eth0: Link is Up -
1Gbps/Full - flow control off
[  102.821680] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  102.841257] Sending DHCP requests ....
[  119.840915] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[34e6766b]
[  127.860148] DHCP/BOOTP: Reply not for us on eth0, op[2] xid[34e6766b]
[  132.513252] .. timed out!

[1] https://lkft.validation.linaro.org/scheduler/job/5880584#L392

--
Linaro LKFT
https://lkft.linaro.org
