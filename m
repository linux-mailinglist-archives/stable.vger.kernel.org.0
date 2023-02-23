Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423516A0D34
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjBWPlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjBWPlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:41:10 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B41AC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 07:41:08 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id j14so16142067vse.3
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 07:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uuKMW0ptMKJc4hjZHBFOqY7/EqIKmrJdpJ+S6Gp3nc8=;
        b=hmFtNVVUHYCsdcx8wi+yS7rNqKxZgNqV4MrOYwcGg1qvX8iLLjBR7kxWSInTyO23Jc
         JqnHYvQ+iVl57BwXXypnMe+Y5GAxnWsrnhGFslNHS67R0JQ/IeWQWoEVW/b1pZJ8tsvS
         iuV1dvN3AOpkA1YLIaEOP0CMVANUI3ClvMznUtQxvmOrR0rVEKXb1uXutZFmaC94Ylrv
         XUc2D2uJh42k07yZVtUCM7dHJ+wl0CTUvPRNvyIIxYSOOao+N/Aeoy7YoRqlx2Lm5EEJ
         zXzBt6L+T7CzAk7PQdE48rTh08HLpAClSKnHn1LbKEbh3+JjCRbmaQDFZO8O5y+LDoq2
         nQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuKMW0ptMKJc4hjZHBFOqY7/EqIKmrJdpJ+S6Gp3nc8=;
        b=ewL+dCTp1c83RIqONlWaW24SU9ANTHVJ2VUei/j9r27viyPvp4XOcLf2zAQgsJFKNi
         zGIX/81ObF2r8QJkHOtd8lSUcUc9u7GchwlI8aDuHljR+nQcn1xf/QteMrOeYx6YeJ2A
         psFjFcqnbFKswMZNcN6Ae7jOM8167OjkDBnrJ0wego6+riUDsxT1GDMLrBas5J/UKe2b
         R+ehDu9AMT6MFvkqIqRnrZIl5CEVzjgUU7xKSPihn0cBPrQng8W+ZiiE0lXpz0LwNm5H
         WbTf3zoAenpFLSxrN1/mziw6bc0WsPJ4QIjITOolwDBClStFHufRG7hcME4s29B5y9te
         mcKw==
X-Gm-Message-State: AO0yUKX60750vjH1UUhaI/OLRPW7eeUQVeRrhbW0ua9qwkZiaHiHhcQO
        Dh4e8VC0W9Yn55TfNGg0VJlhjiU+pbn/L30Tb+u9Ig==
X-Google-Smtp-Source: AK7set/8k/cmi1ZVJM0ILGR4qWng6lyqfkK4d7btSDpUzAcAh0vsL0Zpzwga7giOfJHSk+zPPTz1YN4pLR5lHAPSnvQ=
X-Received: by 2002:a05:6102:1161:b0:41f:2138:41eb with SMTP id
 k1-20020a056102116100b0041f213841ebmr570223vsg.28.1677166867671; Thu, 23 Feb
 2023 07:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Feb 2023 21:10:56 +0530
Message-ID: <CA+G9fYuhcaYO1m29-9vQr-HK7_xJYouAAkM=ouMYzOBk+otCVg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings / error notices on 5.15-rc2
anyone see these build issues ?

scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:
scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:
scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:
sh: 1: scripts/pahole-version.sh: Permission denied
init/Kconfig:97: syntax error
init/Kconfig:96: invalid statement
make[2]: *** [scripts/kconfig/Makefile:87: defconfig] Error 1


Need to bisect
--

commit 54fab3cc806aec70d7ce8440e511d56bd53a4081
Author: Nathan Chancellor <nathan@kernel.org>
Date:   Tue Feb 1 13:56:21 2022 -0700

    kbuild: Add CONFIG_PAHOLE_VERSION

    commit 613fe169237785a4bb1d06397b52606b2967da53 upstream.

    There are a few different places where pahole's version is turned into a
    three digit form with the exact same command. Move this command into
    scripts/pahole-version.sh to reduce the amount of duplication across the
    tree.

    Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
    to enable and disable configuration options based on the pahole version,
    which is already done in a couple of places.

    Signed-off-by: Nathan Chancellor <nathan@kernel.org>

--
ls -l   scripts/pahole*.sh
-rwxr-xr-x 1 naresh naresh 610 Feb 23 21:03 scripts/pahole-flags.sh
-rw-r--r-- 1 naresh naresh 269 Feb 23 21:03 scripts/pahole-version.sh



--
Linaro LKFT
https://lkft.linaro.org
