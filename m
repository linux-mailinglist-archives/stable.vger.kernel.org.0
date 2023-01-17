Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07366D544
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 05:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbjAQEPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 23:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbjAQEOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 23:14:40 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914CA25E28
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 20:14:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id mg12so138551ejc.5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 20:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zDKtcvtIFf+y3VGztWmfwnQISP0yBigN3Ccwm/hiUK0=;
        b=54pwdyFuQao0yiFXoRpb3zxlQhCUMcKCmJ2/n3bCVvo8cyajV60H6C5hcnRhJCIDzJ
         2td93sZbOnSa28pLgqAw0/PoCjHhZ4xtPpfUd89yOpY7VySpIlXbVyfQnlpUpGnS03lL
         9nv0rbf0WJJW443a1eZ5EOJ3Zx6S5bjRpQHoZCQ2lA1JPVCITvnlDDsLgmt3wkM6hByF
         scj8fCB+NUWKtsn8cHLKekKJZlSX6FLPkoD7BAX61xYnPheKGaCe7Q3r8Z7Ug6C5UqPC
         ObzUisWGAA97Wr6Fsxt7JgL26PPMtgEpsTN25KkJrjgNGpuL7BDzn4VmGtrOyu6Ihun0
         n0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zDKtcvtIFf+y3VGztWmfwnQISP0yBigN3Ccwm/hiUK0=;
        b=JURYz1P3RkuKk6xz2hTK6+O4IgS/V6xWr6oxNUimcUzo9yd/jZNLlj7K3CuKEY41/h
         4EXzAPRgQ2zBK0YGGlNMtV3FYTxboWnZifoQjCkjvxk7TtCpa3eVYzJCF66YrRguHjhw
         ATMyXqj4lvm6+e8pEnRyXeQs92zweSDcVZ+v38BFXkwJboQsUoSEt3buYbCe4ZE3vYBN
         /xzLcsIIQ/EpZvtiGThitDs1UPU68XNN/fbeaq4RQJP96T9ffjJHWXL7FJENN4jQ5azM
         R0+Kz+9VERyh4K60umBKao9uUVc3S73pc74Kfo0iELe3fZNSgYQkc964KJ5pr40ds1RQ
         Utug==
X-Gm-Message-State: AFqh2koXzRvxFf7+89/h2p+0S6wbFditA1yyYKBID1rauFOQ41xvbCCl
        NvfG8wg9XkFtZndWZjWZSqokQVdPLaeqeVu+M0FffQ==
X-Google-Smtp-Source: AMrXdXtJPZDPoMdGM+6WhpO0nIkoLS5sWjW5h+CYpA1K2txuLO3Ta6YC6FkoDbzeDHsMWYHGV1a7f87eAVCI7B8FbmU=
X-Received: by 2002:a17:907:78d6:b0:872:5a3e:3be4 with SMTP id
 kv22-20020a17090778d600b008725a3e3be4mr72348ejc.649.1673928877030; Mon, 16
 Jan 2023 20:14:37 -0800 (PST)
MIME-Version: 1.0
References: <20230116154803.321528435@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
From:   ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date:   Tue, 17 Jan 2023 13:14:25 +0900
Message-ID: <CAKL4bV7=cY5qWxtKpuLfKUkXEWd6tgSL2oeWVXPmiwNkrKZdHw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
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

On Tue, Jan 17, 2023 at 12:54 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
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

6.1.7-rc1 tested.

x86_64

build successfully completed
boot successfully completed

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
