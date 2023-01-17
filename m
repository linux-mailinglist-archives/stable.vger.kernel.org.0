Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F566DEB1
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 14:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbjAQNVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 08:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbjAQNVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 08:21:33 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4EF3ABF;
        Tue, 17 Jan 2023 05:21:33 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q23-20020a17090a065700b002290913a521so14856240pje.5;
        Tue, 17 Jan 2023 05:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XyysVZNRdlhZXXRBwjfaPZSitQ3Ii1qKei/kMDd/RTY=;
        b=D328E8IJUcmuTi+HvX7P0teTBwMSvKWOMzykD66qbZfFTux0EPcgxtgpjYPuvoZfvv
         wwV6Erx7V1Vmxo9rMeR8FKpEKlBqGpvtYx09ZJvRqrRTR1aB0zaz0TGpHIaMSYk2ub5B
         ulN6K6ZG+OHfniSBGTTXfhZGHcR9SEV5RyCv+R91o9i5eQ4K+b368ATPtuuxyVdHSo7m
         AQIqph8ZoE/0iJwofzUhXjJx4+8hidUaakpH7TtKN22lHkdWflQlb6li3gLLtM5AKvL5
         /RaQx2eThKF2ybVMfsXpzB6SVHMdvVXkwojYy4u+cgxjsGatsXyK6GMqwrmEbwTQtosV
         XJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XyysVZNRdlhZXXRBwjfaPZSitQ3Ii1qKei/kMDd/RTY=;
        b=MLVDO7bXP2vFuO7MwMGt3sWEH45ZXTtGWtvPtRn7mrlLuL8c4YnjYfKNnJzIFOtZu5
         haw0Fn8EXNdP6I26R/Yyt0BWbWyNiqE8Ery6Cy0xVBjAI0i2WAaJ8LOKgnP90336Tj1K
         7HU6xQ9+3j1uOaZS8gICa8t5SZBv+/9oEiHXV3LpvYXuPNBY86mtAjQqYdfaeOYaqGAf
         0GX4N+RfF2aPZ5VU1H/J2pU4V5QUJt0pY6nOudYAK2rXBq/y3oczFuNckDenLU/rlsDE
         AQAT5I4tlS9RG4LF2Nj2YwGuJMXZeerzpHiYEmx8eLver1aWO+NrYcwaLTDttLMAUCXU
         X2DA==
X-Gm-Message-State: AFqh2koAChOwChynXzZmJAcWBxIPTssEXycR9av1um5kvtg/Iha9prnB
        iNWytxsHUNxttmRpBdq9L1i+u9swDqoCk1hyiDc=
X-Google-Smtp-Source: AMrXdXsyOfi65HllV91zUscNWocOYNoKuUEONuiqoyDqpXuhRXFlaiLNRj/nePP0DhG0hhbEkX0N1axrfQBQ8PuOACU=
X-Received: by 2002:a17:902:e043:b0:192:c6ad:4c35 with SMTP id
 x3-20020a170902e04300b00192c6ad4c35mr229368plx.15.1673961692342; Tue, 17 Jan
 2023 05:21:32 -0800 (PST)
MIME-Version: 1.0
References: <20230116154803.321528435@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 17 Jan 2023 05:21:21 -0800
Message-ID: <CAJq+SaDw751Z5x0OLZGQdoCCwsWDiZuMdRM4yDzetDkZ=NgHYQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
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

> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
