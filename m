Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49260BBA3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiJXVHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiJXVHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:07:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDF119017;
        Mon, 24 Oct 2022 12:14:34 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id jo13so5668068plb.13;
        Mon, 24 Oct 2022 12:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7C/ZOpjkydP0xF/9Wnjchd8lVlMRsTuGl32uGzpIAbE=;
        b=QrNdB+fTgLLXmwj1QbQ3Tsux2OnhLKWJBAvMMMGv5hmDt7ALW0ooJ6fxAhSBe11N4E
         kiCrI/Iml2/V0xirl9ydPoXb+iAxFX0YSv1EBmwYbcklQNe4zMyUqh3jvoHJ2JJrmE9Z
         KCpgjWpNonGWhwE5QbSAFTF4E36nwGz14dlM9TmLuZlqRV4EyPRQBEyjjf0x5RpxbZHv
         0qPEhn9h1rytwt8knfjKef41hNeAJQSdL0JZobPEluhRogbXmn5zXKYVoNY72ULWEPx1
         1Up5O7NYfQvuI2s7o5JQ/3h5bYf7k0V5YREMpo4i2hQBIX/SLN/p2gQMqkkGaGtMcS1B
         yEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7C/ZOpjkydP0xF/9Wnjchd8lVlMRsTuGl32uGzpIAbE=;
        b=E89kFUdU9HVs8vwNh6vVnG6NBmuKDBmRpJepE1aQ85SFh1FiraflIq5QPNR+UUZhx0
         KkqfJ+yjTNAXEIpe73bAYJ5+jZXdYQk/kRUcEYNMgW0EKRawrQ2CV6Jic2cfHgqITLqU
         mbOOUI3tsXc9Fswj8kvefx2l4pa5oHwz6N344JWZ8hgIUwVKlZ1d7H+eIv3V/55j2iFF
         lg102a1JksMD+teMz6GsADACvbPmGfstqXC8fOXEI/t+rj5I4XZCryZ8dj+eaSN1hEGC
         KYo4JErrKt/1iRojWf6mggPDdDKyx3mktOXGPb2G75+FHUoBpyQI8/69CFV8jKD5B2iD
         XdMQ==
X-Gm-Message-State: ACrzQf2Gm0HB1UI2wxrq/c0BPuA0xKQg+mCETpReI1MCDVWlEmxGNbd0
        v9n4f8b4EaLdbpX7vkhEQnpYU6N33XwL4INSnDc=
X-Google-Smtp-Source: AMsMyM5mSinzAbZb2UTP6Cd5Y72CYhkMnoFZI3YDAIbH/YfjPBSk3DR7VPBEjWSGDa9mCV1dA4g61uUk/gxH6Rc/4HI=
X-Received: by 2002:a17:902:6a87:b0:181:c6c6:1d38 with SMTP id
 n7-20020a1709026a8700b00181c6c61d38mr34695224plk.74.1666638779425; Mon, 24
 Oct 2022 12:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113002.471093005@linuxfoundation.org>
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 24 Oct 2022 12:12:48 -0700
Message-ID: <CAJq+SaCwKZSXMRciOxg_NBuUH5-6H5fWHeBdJ6BVgA7SxniecA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
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

>
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.220-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
