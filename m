Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72A2678296
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjAWRJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjAWRJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:09:00 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FC093ED;
        Mon, 23 Jan 2023 09:08:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso7082343pju.0;
        Mon, 23 Jan 2023 09:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DQx1ZYz4K0qsZVhAjIXu9/aggRexBv0BEFKN2lOjUzU=;
        b=Ayu0j2rJRSbWpuBTQlalSiwe8BcTOeWjyYwmCK8klCW4poeumbUA1PJ7ZviFKBTuwT
         KPbr518xRALuDsTHxJeQ+tgzghJWMK+2tpC5vypdsMQlIdiyPV+w8tFxqhP4eiQMDDG8
         icfTxfz6dVhMvCM2obNp0KuTESNcMgJXOjGxhJ/2ROjnRwn0y3VmCI72JheJ8Is+PpVK
         PebrulyP5e9sTdQM/RryYxM4/0rneknyePPlX7cypxNDVlkd5mtg4gncXoT6lpzZoI59
         v0SinIWZF3O8m/RWEqBdwXZteVhWBVWgZYAm2KlxliH4AwOMSUBiAKWcUFUrMXP6vkVa
         Uihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQx1ZYz4K0qsZVhAjIXu9/aggRexBv0BEFKN2lOjUzU=;
        b=dVPeR41v/zHzEp3Qs8ThmltCYKLDr9gLhoIt6aNVSvbux8J9zj5r+/jyu2lR1oP1I9
         wA3pfdFyRY2XmHt5W4HVx1Q7ygb4S4TShaiL8kRvGnOdSaUbM9NhtqC+qDYQDMuttzt0
         L7LzJetEJcWvjyijoSv5qp+IIAC11Ahj1RQpnjrHgdvFR2i1quKFNN8zAp9gRV+ETpFd
         6W2dSC6LVmKEA/B18m55z3Ut7jX7r05ulq2NtzLwMWXQb8tEpuBKaniZweQ/t38tyWyW
         pmcoAGEZhV5clT6ZJUZfAR7w1uqaUIDwK/998Z1OVAIhizhJ1Mg3LivwYoWHeNd/N39l
         mQUQ==
X-Gm-Message-State: AFqh2kqidGxBZakVcy6nMfD3+Dr3qHhR+jdi4nD3EGXokrPHR0031IwG
        AXXdpipAL7F9bbyqfKptwOkPCiJypZX/oaVuJhc=
X-Google-Smtp-Source: AMrXdXvC+r5V9h1FTjDzrRDiH3ZAgPcyxh+tifryaeZ7LyOUg7otR8yjyXkyACzVn/INg3sMtBL55Zp5cxZq0x9aTu4=
X-Received: by 2002:a17:90b:d8a:b0:229:15d7:8a27 with SMTP id
 bg10-20020a17090b0d8a00b0022915d78a27mr2916998pjb.12.1674493739108; Mon, 23
 Jan 2023 09:08:59 -0800 (PST)
MIME-Version: 1.0
References: <20230123094931.568794202@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 23 Jan 2023 09:08:48 -0800
Message-ID: <CAJq+SaA_RFiRPh3X_dn0az2-A2wDiQKK+c_W9sYUaDs0gcUFvw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
