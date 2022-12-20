Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107596526A9
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 19:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiLTS5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 13:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiLTS5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 13:57:45 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A71B9D0;
        Tue, 20 Dec 2022 10:57:40 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u7so5002588plq.11;
        Tue, 20 Dec 2022 10:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mSPTHsXsrhOIwndCIwPpGYW6EAktLLgeTGWc4GBS0Ec=;
        b=CFYf2eZ3CxVmwaUbcrKsNBy1u3NuzGBER4gEuMCisQ0jtzy5T7WsAdO0uC81YTwpqv
         Lz7OJ3/Hvp19gi7jP53I5nGZV6qMTknqUI8pR8oaIQzh7zTkMgB5AeRBVmDOjpP+7O4Y
         nfBMDg+AH6rST6a7BkZXVsYQUIoHq0XuY/BB8zPvcJPium21oZKC3zEWhxQncGi2JbiJ
         1+GYdPezqgQPcHHE8TB/Ewz1FekLkzcPml+VQHnvWXI7zyPZxC2fI4Avhj5pWOXI7vet
         dWZJt2cjRqwZgU+b4GeKefFv5tesAJhGSy6+2a51JlMGJLSd5/nCRXmJcaLW9niefa33
         RAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mSPTHsXsrhOIwndCIwPpGYW6EAktLLgeTGWc4GBS0Ec=;
        b=5ZYM5elGWBM/4C6mnRSsiK1NnhJmJPFh0mCEVhzgXFMKFx6BmbrN1k1HoRt2zu/Bfv
         p1aN87tY6Bdn8LlJRcX3h7uxFznMn5JXL9QQOKUH1kk/8RA3JFT+GifISg3D+ZvAwcrD
         iQPqBO3R7mAr3cfdqGQIuooklTFlrHaHJhmOiMP2mb07alZfeUwd07jFZu4GbY06HfWw
         gMnf9tAumuYd9qIgR5rC8fIAdzeaaBPXUtK7lKsnHy3lHsA4AydxlRbtpMxkBqQ928yo
         X4miPq3iZQijOdm2h5Z8IECoQ4dJJ+Qb6AppJNx01ZpXWNDdFy5LzhcR7lzmFdV5KmeJ
         n7XA==
X-Gm-Message-State: ANoB5plsrOTapBJGyj3NciEMaDPZ9ZBNreAitSGkJOfdk2zE6ZW+uiJw
        KCkRkdZyFDdNVKthu5HvZZKlNnul45T4otBQdgU=
X-Google-Smtp-Source: AA0mqf6l0TavrCU9yrUNKxvMLdkUhelDFyBVVaaLkbmUpK9hN79cFp9gg2EuTkBDIgjjaIxXPqohuR4pcmNWkgGWx4c=
X-Received: by 2002:a17:902:c951:b0:189:e81a:1520 with SMTP id
 i17-20020a170902c95100b00189e81a1520mr16236577pla.48.1671562660294; Tue, 20
 Dec 2022 10:57:40 -0800 (PST)
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 20 Dec 2022 10:57:29 -0800
Message-ID: <CAJq+SaBiKCraBGBY7m8RmvSxrPF=Ccw579nMkCnhp+N1NYLPfg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
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

> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
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
