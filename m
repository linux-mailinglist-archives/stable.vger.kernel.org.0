Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620C9659C53
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 21:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiL3U6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 15:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiL3U6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 15:58:20 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FA813F7A;
        Fri, 30 Dec 2022 12:58:20 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id p4so23460945pjk.2;
        Fri, 30 Dec 2022 12:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A5HECF9+rVuUX+brSXubDgLVHbeqG015MmzEZ9FF8VE=;
        b=cSpq2X/PC9hjQIhn7TixPaxyLrIj2Echgf4Uompnm8LQwp9Xgo0+CSaK9/Sr/KXeJk
         mOtg8BP7ddm/QCWE7JpxN3LP9Aqg5QzZVdGjnEYCW8wx32yseo85V5xV92i5ZvItDK2I
         BfJVJkugU5z5I5OwKSA4dTR4rDLQjkw5mXhHAeqR1DLPATG9p8qVNS77vVFnkO06SMeJ
         BgvnScHLQWSBIGL4Zfyph+eosR5jG+mOVn7GQuqPug6mrisNZDAOT0k2mx0Z2h1GfKbk
         mI50xA2ykj84l2ZLzvjokG/uctzKIMfU8vI8kH3aXCrZ8NajkaxLNW2UONZZpeniHUsw
         LNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5HECF9+rVuUX+brSXubDgLVHbeqG015MmzEZ9FF8VE=;
        b=jmDQOm1oMzccirieGR3TVU2Y/PUbxE8EljswcDN2EDN77RPmt1WWDF30t4nauSTEQ6
         rKJIZyYt4eIspQ1NzNT5hR62E8aR91LEQme6vB0zrwssLW9fK8PfCRRFB7IsslrPh65Z
         YD+MBbwQMqW2Z6+z7CsiqqsJLlEG4Gi3huotMb32FcLYrQF4To0bMDAJnFGfmxcUN8iz
         Sve6cGDwtY0xT5z1H4xG7dvrzopP/ft7IKSZvDYgB/2yo1yR1h93Fj/dcF/N2xn7KfdW
         1iDaCP0SuaJGnMnzEE/4Zz9z/sysynkgXEr0sspT+8DcZzjpXfnR67bhkdGUxW5hh3Dd
         OpCw==
X-Gm-Message-State: AFqh2kpmLXe7c0GHZfAS9RJ/RDIHZd3KlgJQ4fBuO4YuDWpYEZPMh6e5
        ULcArlnxsR5iM/kKvlHISTdGNLbUibCsMLS257Y=
X-Google-Smtp-Source: AMrXdXs//T30asV4CVfSzhXj0gdwFo0Wu17EEcoS58I75cZvc0GcWON/DNDt1cGUFxotQ/fqO0EJG5T+Q1wMc6L5HFA=
X-Received: by 2002:a17:90a:fd03:b0:219:d32a:ef96 with SMTP id
 cv3-20020a17090afd0300b00219d32aef96mr2717571pjb.12.1672433899545; Fri, 30
 Dec 2022 12:58:19 -0800 (PST)
MIME-Version: 1.0
References: <20221230094059.698032393@linuxfoundation.org>
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 30 Dec 2022 12:58:08 -0800
Message-ID: <CAJq+SaATrjeJrBnqT9uR=i3OzmsPnYuvSvnv1N8cbaVDRN2djw@mail.gmail.com>
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
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

>
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and boot tested on my x86 and arm64 test systems.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
