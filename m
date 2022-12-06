Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76293644FC7
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 00:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiLFXoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 18:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLFXoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 18:44:14 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BA03FB98;
        Tue,  6 Dec 2022 15:44:14 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g1so7972417pfk.2;
        Tue, 06 Dec 2022 15:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLj6FO6Z4ww2omFd1kn1UspeQgtvv8OxuT7l+R9qe3w=;
        b=m0BGW15E4sHqmyn5sz3zzu0YEs8GVqOArKugrcw9QkYqFP4gPLpUc4S2X2zEZ8XgTj
         gAv6HET91FT/S6z/ktCof+Kso3s1r1w7pVFEGOwK+1p1LKx4KLsyY/dmhylObzzdkH0o
         r8Uu52XOHnrbDn3Yw/pL2Zd6GG6w7208Ds4ZpCAm3DBeZipKz+PkoMG3XHQS1/eiyvBh
         Zv5NoTvm+EuQxu/h9f9urBsEi5Hwh51hbNledA/CBMVHmDt991OIE8SIDHsclo7S+7oR
         mI7HQZRe0DjdckkUEf/2egNhtelgDSgbe9nvQZTxgU4TCl3jIPOnEoJT3SqQ7EsXwYxG
         rFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLj6FO6Z4ww2omFd1kn1UspeQgtvv8OxuT7l+R9qe3w=;
        b=BSlb3di09HMf8pfbZNir8lM4aXOz/S0awfIbHg2FyFLtLrbHu20Jj28pMBKmUuIlPL
         RJ47d5wso2geVIeF0GV7D0bWdH9nXJXFQU68SQrOSdrIXlBj0CgyuQl3to85zyeDPz4A
         3yjaM9Yt7+GaRyStc6i0UemUFDxLoAC3+H21NtS88wY1ko5t6bpGLBUDUEhTcQfGIv+D
         aGGv2htISY1Yp99A5nqdiuqQ80oy3MhcAwxGTaWk6Q3yLw8t22ofqrlPLsegr9XYUWmT
         cAq0tn6sE0vmUybW7a2LHtXD40chTb53+mQ4W98aAciZ/+0ZdYs68QSN8BTnQS0ofvpo
         xLJQ==
X-Gm-Message-State: ANoB5pna4i2OElV2RaOo69tqEw6AJtzwKk7PHd/bv7tomgOcy5/w+DIh
        Lj/Wo4dwxBzCb1e3hxwW/asgWuJ2AflpMmYf9hQ=
X-Google-Smtp-Source: AA0mqf4Od+ktH+6qycNy0wKHzZi3kph1ACv4NO0bywRiejqCAHblHR8ALWi8UtF/Fenmf/ulepYQE6OYhGpBvPYp6Bw=
X-Received: by 2002:a63:ff62:0:b0:476:898c:ded8 with SMTP id
 s34-20020a63ff62000000b00476898cded8mr71448926pgk.251.1670370253608; Tue, 06
 Dec 2022 15:44:13 -0800 (PST)
MIME-Version: 1.0
References: <20221206124054.310184563@linuxfoundation.org>
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 6 Dec 2022 15:44:02 -0800
Message-ID: <CAJq+SaCAedOkQfYQu7DXZC0AvXx2WYcqBJJbasNVB+-Wiv+Pag@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
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

> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
