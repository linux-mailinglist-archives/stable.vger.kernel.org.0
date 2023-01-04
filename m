Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE465DD10
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 20:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbjADTqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 14:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240204AbjADTqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 14:46:31 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF4262C1;
        Wed,  4 Jan 2023 11:46:30 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 141so4643920pgc.0;
        Wed, 04 Jan 2023 11:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lfp41JQ/onUmjvZ07AVTcvQ52DwcrIfI2vmD2kQlaH4=;
        b=kO1or/RXoA05nURTG3xyN7muAUlj2ebxkGpDEctbc4x6Nqwc9T5PxVV04perKzOzW9
         SX6g6Y8JUF48swj3lmNF14tIlC/U5klThXu4dbx1aukENqSQUMfFWG/jJB6Q9xbl1ltK
         qNpSfcQ6np3P6rpVcRUp9mC8cnnqijDUGEiEa3zFJIlnzS17Pzo8ryM7Pf7d5Xtkz6De
         d6c/bZR2mtvKLev5k1qwzFkOo676v92PcZ4Pdu4mwwzepQ38u9h6q16OeI0OAU6XWltd
         XlFkx5ntnXOFPR1ByE2rVojIUXNjYviqtVUQH7Boc2uHlHZljhmmamshUGtZcT5Rh9XN
         QtbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lfp41JQ/onUmjvZ07AVTcvQ52DwcrIfI2vmD2kQlaH4=;
        b=Rvg7QEDqNIV7fP3cG3F7kUweMPnuu1UW0j6+x3WT2GyRdMuVf8NrmMBAfUCepSB7Y4
         ZNdfU1dT5VCVbhfXZTLZBMT0OvekHcM3Dm8PL2n1LbQyaUFzeYNbRiDGJWqK4FESTaKq
         yMs6TaOIBHgiFrwZfoNcdsdXmre5I5ezrpkw1EnXJIeZf4jcSHHJnyh886Xyr8VXJ+cO
         T9G5EPxrQXFgIHwgZulc3i6uYR4frcxkqFSajLXn3nQVCDdEhgSI/qLtGiHYI9YettRq
         nWhCJ8+tOAuzDMaXhwmR4qTZ0XZdNOyV8X4VyykneSwB7kNPmOwS+mVOgrSAoZXEFnuf
         tKug==
X-Gm-Message-State: AFqh2kqxJmutStX/CrNWvZmmZXNXaFmFOQJfe7mA8IC2AHmEnXNvkcHc
        dVTktxko/WVvrAj9uJ6oEVOBZMwQ6Kj3brTAtYE=
X-Google-Smtp-Source: AMrXdXuUI87EkFUiq+H9wnUuDjm36Sg0u4sCXF0UhtLLaXBCzOjCNdY2tjgwN9QtDTcSCPtYCShEKY9S0cZg3XH6MT4=
X-Received: by 2002:a05:6a00:27a0:b0:57e:7d2e:cbea with SMTP id
 bd32-20020a056a0027a000b0057e7d2ecbeamr3153172pfb.27.1672861589963; Wed, 04
 Jan 2023 11:46:29 -0800 (PST)
MIME-Version: 1.0
References: <20230104160511.905925875@linuxfoundation.org>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 4 Jan 2023 11:46:18 -0800
Message-ID: <CAJq+SaAqX7ikxOEsNvqyAyrtDes5-r1aeOMSx2fapddk8s3U=A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
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

> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
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
