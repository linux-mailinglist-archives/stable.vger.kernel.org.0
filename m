Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4824A644AD7
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 19:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLFSIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 13:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiLFSIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 13:08:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EDD2630;
        Tue,  6 Dec 2022 10:08:34 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 62so14062672pgb.13;
        Tue, 06 Dec 2022 10:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ebNy6ciyWP/1wiyDXiZM5ebyIeGQ1+JDe4V/MHiBZ+Q=;
        b=OtUqvnwUVOzkQtcy9vnKjntBdvIkNoE1QdM6g7d4AFJQnKruGjuo/jIu+0Why58dxo
         Cwk/orPSQPpBPc6O12Mfd2+BGM3xeAxVJASCTKRpnWguwv/Jwr8aQLUNDhZrx4Hlq6lP
         5GqdrF8v8myEeXDypCZgW9mmN74IRaLMZ6w0Ipsn7iOQDY5JPThw2UeqJfCd45HSa1ht
         6JjQx4q4gqfVcAbQ6zvL3yYfbyP6NiebJe3QgJJwUJNBQvfP3TjYqEC0t0cJB3sRDsTA
         JZIlormHlVuav8KMtAFgkcywAfCmW5qYtN2VvEcxIsAsIzM+1g6dxPV3/iw7fT4nm77o
         TTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebNy6ciyWP/1wiyDXiZM5ebyIeGQ1+JDe4V/MHiBZ+Q=;
        b=x6f0ZuTiobPp2GuB2waHPlFOfJa/XH8V2WRG1u1KiEDzB/RmluL2awUTxCkeyu3HAb
         EBzN31gQM2TPZKHXn5RfooHwHxmEscfZ/QfKXrCqI/TDgqZJgAO4BLlURX3MXbMlg1n9
         +m7QE6Zc2TnoF5P4QOMeISJe/dRCxDVQ1+u5FrNdpWYxqX7YW8AzycCj2lyEPfLtmdWQ
         kFoWHzqxRdBYT5XHYHvSORANdJdXVf8UEKYBvetz/NmMvTG5FVsgtFiHrYfoKFxwHRej
         spddbW/hCuN7J8okoeMgs4iGlWd2qt6DGsrdBXnZqXGZsArHUPwe84YVNP8NHhRrjJRo
         bY0Q==
X-Gm-Message-State: ANoB5pkQrkOzPdeABSh6JepYCOKODG12KJviVKP1/lPRM0ZRssers7c3
        xgC+pn7KndjVNV7kQl1mTpQp2JKDUHq6oYmKiwo=
X-Google-Smtp-Source: AA0mqf7MgxRO98B9Da0Eyo7NARQx3m8FWTBB2bKRqrCBhIW4Wo17Y44H1pXz3YVK4KbEL1WLqDEbyHVAeVaDQ1b7pLk=
X-Received: by 2002:a05:6a00:1d22:b0:577:16ac:8447 with SMTP id
 a34-20020a056a001d2200b0057716ac8447mr7955316pfx.56.1670350114320; Tue, 06
 Dec 2022 10:08:34 -0800 (PST)
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 6 Dec 2022 10:08:23 -0800
Message-ID: <CAJq+SaCrQG4WBvPPV05E-206-G=kVjyEBNyVs498nOEGzzx9Sw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
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
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
