Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411A16219AC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 17:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbiKHQmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 11:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbiKHQmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 11:42:00 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0D25657B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 08:41:59 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id j130so18004786ybj.9
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 08:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JD3PRe74QR2mJ+orp5KCKp7oflDuwpBWOjw8obsvdQc=;
        b=ezAdGSbLm5hnxH9a3UKs0v0CGNhaTm5NwZtDjS9EEqbMnkp1Y2iUV48IxyEfmZ+0Kx
         unxFChxpGKrMIO/AKuVpdPRMAOH4GAvvbcqOl2jUOyIhcD0e+2cXmwK836XVVX2abv2I
         DDn3JnLzfMjf0qZJui350cU5ptyGDxUq2cA1/rnwTac3XS4TbsbX9r7S3lYSoSRJcblK
         divx9A5gGxFXwdlV3pQj0M3zehum+TE28Ws14aurCYj2DL903dBJ6dujNz4nMLYfgKgQ
         8U1AKAlyaWjm/nI2lZlnL6DYCTFMALUWDcKVrQthayTqYPSYWiRh+8HOUpCN4JMHDJGb
         fWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JD3PRe74QR2mJ+orp5KCKp7oflDuwpBWOjw8obsvdQc=;
        b=1f1UXKA6DuK2EBEW+zQcMADPPGg7fAUebdyLO17BqEy7bzDbRj92JkerRxCyjJkopG
         62QiJbH7c6FzBVHvSkacoQaw87lBoSniqsYXED7WmUKrs77IsRjqi60uMIXyqCm/p40C
         JfsKcqePqba5jxz/exUIKPfr0oWlXl91R3I513PkbT2HBYXXq7rWs3Msi+E2Tm4HEeHd
         OV/gJXxgrx7GU8Z9cLIiPNtDDptFBOguoMfu8AzIzhgeGntC+0GnVM4VRMCpj/2ZPM5Z
         wfwn1qtKrZLKsnsp6YEr6895KgOZXASpgMI2s2l1/SM/yhNq+Ybiy+XLPkWiNTFIk0uy
         taDQ==
X-Gm-Message-State: ACrzQf1s+YN9KBOS51y1v22o4N+cIv2Lo3BpFMETynsZAz5YG419jfdE
        ucVJLo0heYb5/M5CPYw5rkbEsdPJPt50plyev6QT9A==
X-Google-Smtp-Source: AMsMyM7b5keHpnrPp6sbB8q5Ph5lxpcIatBUP8MgjCIRGloZ+3MsJQch3obqOYW8dlqcALhXh82dmnZYmZrU003kRTI=
X-Received: by 2002:a05:6902:722:b0:6ca:260e:cc5 with SMTP id
 l2-20020a056902072200b006ca260e0cc5mr57709150ybt.336.1667925718127; Tue, 08
 Nov 2022 08:41:58 -0800 (PST)
MIME-Version: 1.0
References: <20221108133340.718216105@linuxfoundation.org>
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Nov 2022 22:11:46 +0530
Message-ID: <CA+G9fYtSBS77MiW99t7HGyBPnnpxyu-6L3HUPsA+pXd_fkZRVg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Nov 2022 at 19:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As other reported LKFT also noticed arm64 build failures.

Error: /builds/linux/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25
syntax error
FATAL ERROR: Unable to parse input tree
make[3]: *** [scripts/Makefile.lib:326:
arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-cx.dtb] Error 1
Error: /builds/linux/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25
syntax error
FATAL ERROR: Unable to parse input tree

URL:
https://builds.tuxbuild.com/2HGddiHMonVVZRsckAWkubW4tdh/

- Naresh
