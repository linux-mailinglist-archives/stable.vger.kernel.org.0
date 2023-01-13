Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96886689D5
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 04:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbjAMDAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 22:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbjAMDAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 22:00:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BCD5DE4D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 19:00:47 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u9so49337588ejo.0
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 19:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4qDazh6QwMY3LvG+D+8H3mKX/MyNkX+etoMzkezwE8=;
        b=pYTE8kAoX/zWZB4SBkbDjTTBh9UWIFd+P6SC5jQkDEeDj7PdVlns9VanBfpC7qY5kO
         MiGmJTQ7FQnjxnzX6GW5X28SLY8Q3CMu+fFKhPhJ3ItVJa0BivOqTLXojoCrL+IjSgGn
         5Pa6324U9cLfYcL+Csd2ytA4CDUMZ+D+3GkubrvDJFdkcX3m4/o5hQ0D8s1LKCIMS7mV
         H9ZEgSXw+J/DMm1ojfv4nYY8stBifqXGnU/lYH+GGkwCCji7nxKvLSSx4VpPL9QbRy/m
         D7QCeR+kr056reSnTMDH8uD34/UwFZwHU9Hu63SSd4eTfpWLyFlHWs7OvOgtkd5RytIX
         Kosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4qDazh6QwMY3LvG+D+8H3mKX/MyNkX+etoMzkezwE8=;
        b=UNo6UuvTSKkDnl9BLjJ8/H+EFabUOr+Mamx5onh7FRymWBfYh6vqSYbIycEGBr33De
         iVNCO3PATGFZR/VXMV5tnw2OeCN6bE22CBwWeNdoYus3Nv7fZolVRkYBQxP8QND+wVzP
         AftUVNOb6EiOE+xtHVbmxsFxwuNZjfZKCdGb5ZfCu3KK6x7H4Sl5vSAIhDCwrKWiLjq3
         3jSxa3OqGb7mDGjYzNtur1+jm/bchnVMGuPxj7L+XYRDdmpfF+m3wYk+0OAmZ8/n4SUE
         Jn0v1zkollUz0KDbhkcL044PY8cGxgKeitXleRkAzYGgflU8gTXAo/KcJBdq062lYnUe
         XdlQ==
X-Gm-Message-State: AFqh2kqRePCb1ga02NKL2I3qG4QL4/a7TumBi+5gN/JwgoABStsv40D5
        ggMOsan0+CnCU0liUPgTH2BUkBPJGsHJYyhokTCnOw==
X-Google-Smtp-Source: AMrXdXsbh24iYUuFadTTe1PMFifWTOQcuum+A9Uz95nsAZ60lsYQu66zxBEUz4ouiTYVDeR6nqEhn+NNkGF3JuYlD0s=
X-Received: by 2002:a17:906:3b5a:b0:82c:356c:c4c8 with SMTP id
 h26-20020a1709063b5a00b0082c356cc4c8mr4396513ejf.649.1673578846300; Thu, 12
 Jan 2023 19:00:46 -0800 (PST)
MIME-Version: 1.0
References: <20230112135326.981869724@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Fri, 13 Jan 2023 12:02:42 +0900
Message-ID: <CAKL4bV6F5KmT0iE4MLVVW0o_SMyFN1dj-Y+Rt6xN63yAhXtAXA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.6-rc1 tested.

x86_64

build successfully completed
boot successfully completed

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
