Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F91D4F89A4
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 00:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiDGWOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 18:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiDGWOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 18:14:00 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E064D2F86F1;
        Thu,  7 Apr 2022 15:11:58 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p135so2653380iod.2;
        Thu, 07 Apr 2022 15:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ylv8ysKqkQworgDGiPnXpJySf+31QVkFYz+fqxBta7w=;
        b=Fa4IjDqn4hStKyQ1dZGJEN8G/3NaZ73lsPRJjizLbh3bRcWgBXS/BIcZPnbclYRDyp
         9CXLK0d9jsmD/aHE0rn+LFlGt30GamoPlrnTHiWDKEvLuzSFb/T8uXSmiUMeksB8gknN
         0Dx1tPae/qdTQKE+1BJTXvUFFaIqmzJdn4O5SsmuDVy6nGndzOINZJMvsEtQUy7FdUL5
         RmeeOTyBaDmpIM+FrJt22Ux1rvmAr+7JUB+hiSWfITbGnzAQhfM01u/HV3DO2oYZ0WDN
         RgN2LYD9eUGzXTeDXjwCBP8RXEge0ajrbfn9G3Lmde/DMprvOgItP7kV+m6wDmne8T+h
         RaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ylv8ysKqkQworgDGiPnXpJySf+31QVkFYz+fqxBta7w=;
        b=3RUONAxKXp6zHop4lUirA4PHE4TZ3//7V5W7AWYRHVbt09vwnGsLWz4CuS39bJhB+Z
         1HtiUeuka6o6QpKt2Yg7S1raHlPujYXCHjVoeW3awqrRBqsff0lFBRgQRavY3Aqv2EFa
         rKE5tD9AYyDrFWZsYCoxFZy0h+9ISgoQChamrERqzchPuX9NrJ0/0+3Tcj5LMahGyWzA
         kPaAGekzmqFZvvx2OFGTFiei3JKLp0Xbbe+sg5JM5l1VbVu+ARtEkLcvNeToeqlSdA9R
         NhTfeuKdk3mGumvHCF2VKwrTqG8rnSjQQ8+2bkvqhbgoLYhvGJU7C+ZqOn2UM8GPVgAo
         Bm8A==
X-Gm-Message-State: AOAM533+Cbr/p6wZfXd6sdbRNXw59QlaM6HOTk/yn2Y1Mz3E+3RnTjXE
        5KaSjIa7JnkMLRWmwgTJcAUviOQ11NPP62JprAk=
X-Google-Smtp-Source: ABdhPJxmm/35yadSqgC3w+Co6kSfeZaggqMVla0MyKITyqp2H+fuvR2wAvn+AGiKYrdvPwtC53CML+SuTwo8xSK94NM=
X-Received: by 2002:a05:6602:2d10:b0:649:c671:2014 with SMTP id
 c16-20020a0566022d1000b00649c6712014mr7306083iow.39.1649369518238; Thu, 07
 Apr 2022 15:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220406133122.897434068@linuxfoundation.org>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
From:   =?UTF-8?Q?Sebastian_D=C3=B6ring?= 
        <moralapostel+linuxkernel@gmail.com>
Date:   Fri, 8 Apr 2022 00:11:31 +0200
Message-ID: <CADkZQanrccDUKaT3LG2Bxu7dwAD6V2k=PiRPR0kUPwhb8xidSw@mail.gmail.com>
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 6, 2022 at 6:52 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled (clang 14) and booted successfully on x86_64 (intel
NUC8i5BEH). No obvious regressions.

Tested-by: Sebastian D=C3=B6ring <moralapostel+linuxkernel@gmail.com>
