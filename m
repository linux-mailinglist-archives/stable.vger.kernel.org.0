Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD4E441A87
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhKALQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhKALQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 07:16:57 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F98C061764
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 04:14:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w15so63285477edc.9
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 04:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXDHlbSPugY8V/EpqsO3wPi5bv74fgafM1WOTqLgchc=;
        b=YOZcYSzJ5/mTPVPh3SbD85G6oNRTA6S1HjmLvdia1Jski5Kxtcs10s8MwFoXa1O+TZ
         SobS35GBbsNajdQeKJvyWWsXtM8cAUXnV1yeuF2bYWAdEWMjr/to8HX1aBSfeaxIu6TC
         /EaPCVC1QKe1pbJ3fc0RPefs79YO8RJUjov1jGPXv5EjGTHYp9Y1EmeiKylR/a3Exm1g
         0SHXuhV6E4mi9pw+fSg4dnLzQvA2ammt/u2Nc98LUJceHmY+JkHs/heaFqImlRuKNG0E
         +/stYKbQpeu+HWCmK3ObCDe/7zb5eDHZBJvJmVSXkqVDe6/SIH4V6Xb3DHnxQOhgmD7q
         Kgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXDHlbSPugY8V/EpqsO3wPi5bv74fgafM1WOTqLgchc=;
        b=0OMVf6Sldfm2IRnn6uQW5S/yp42WwBetCGtlyLXpPTYM/B/NF1hZV0RrdU2ZaApb7e
         KJkdJ0fNkmAjB6DE4kNASkPlCdjuPQqKdokkLNjY3dd6zbn5kWqMev++ZkMHvrosFqWK
         Ow2sLeOO/iFn5DPQr3QOjPCqx0MgpnVA0Nbz2pbdWuGcLMIYPw+NLNJgAmJ9qwFyjykO
         5AN43Nu4ptm5C7v8tc67EmawwXGQ5JkTqMHNQgl9vcRFoiByFChMxFhngwS+fNkilP4y
         +pQ9kq7G87H/tzNQZiG8Zh4RF6ypt7dDSCQedybMpQkqgBYPu8+NoeYBlDo4qR+a6zso
         5lRg==
X-Gm-Message-State: AOAM5301TTc8zaA/yM84bG0T/8Wg9H2DkAi/nTXuywtqGBijI5N7fc72
        785nRi2jxLKUmwraoCRyRmcxjZC1/iPec6kVW+JZVQ==
X-Google-Smtp-Source: ABdhPJytJQXxnAo9T7FU9hJ9MrP+7g0Jz+tUEm5IZUmRNaelTgPTkdRVMnQ0qKQZ25Sax0fz5ycDwFWK1e7zpG73RzI=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr35702232ejc.69.1635765262483;
 Mon, 01 Nov 2021 04:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082447.070493993@linuxfoundation.org>
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Nov 2021 16:44:10 +0530
Message-ID: <CA+G9fYvsNtCJ7wT-ONaunmuGDwpPxbyHcZp_u9evtN7d8RwDeA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/25] 4.14.254-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haibo Chen <haibo.chen@nxp.com>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Nov 2021 at 14:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.254 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.254-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regression found on arm builds
Following build warnings / errors reported on stable-rc 5.4, 4.19 and
4.14 builds.

> Haibo Chen <haibo.chen@nxp.com>
>     mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

build error :
--------------
drivers/mmc/host/sdhci-esdhc-imx.c: In function 'esdhc_reset_tuning':
drivers/mmc/host/sdhci-esdhc-imx.c:1041:10: error: implicit
declaration of function 'readl_poll_timeout'; did you mean
'key_set_timeout'? [-Werror=implicit-function-declaration]
     ret = readl_poll_timeout(host->ioaddr + SDHCI_AUTO_CMD_STATUS,
           ^~~~~~~~~~~~~~~~~~
           key_set_timeoutcc1: some warnings being treated as errors


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
