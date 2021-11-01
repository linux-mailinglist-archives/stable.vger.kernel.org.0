Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4924C441A75
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhKALMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbhKALMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 07:12:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118FEC061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 04:10:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z20so63427822edc.13
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 04:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GnqQRd6hBaYfWki68lQPDIO80Hq57QzHkXr+8T/A1cg=;
        b=tGWmTFjDJz7ZHICrb2qpN56/6awLBIMQFdVKur6rqwzwJPCjyI9B+AzA9vu5adS5ju
         nYMkE6QElGtiy4pzpA7mXc5FKPQJmyfa8KyNRONybbWp1L4yR2tG95RQKZa6pQbXCh1d
         uc4EFFZv0ab3yZ0VRRYaXj3Z61IhU0HJDjrz+DQkE6hKB6SplYm7AguXedVSsQ/tXDr5
         Rmu8FSARakgsuXgdHZ2/lO4WrLgcBFjvP0A80Kvnq/VnrUDHpeiFF/In7/3ijMRo9MaR
         6CBRgDgNq7JBplCJlhhhHwv4gUUw0zW8xGC7QiU9PFp2STulnUeZlKymyC0raoAF3EMa
         AIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GnqQRd6hBaYfWki68lQPDIO80Hq57QzHkXr+8T/A1cg=;
        b=YbfoIC0D8XiAkHmOXMHYn0RKwRsmUt+FM3ivUHFRr8jFdP2neiwB/ZeAp8GAbPeQrY
         xptIwnWUOP8OQ2C628Bxmo6We4+WNOFhWb3azw/v826ozwBJrF4vqMalO/1cjSyUklG0
         Zv9xVtsGQjXrw9XDSapVQK+HYZTUjy5ImfE8L2hjGfk1s1+mmqGZ62iaba8iCgtgElcz
         U+DRBk3exDcE8Z3wUgeNg0zPyKbQ3UxmbMwg7UDl4D1jIfIO3I3cKvRIELGYVl9kAa2s
         Emj+DjQZwxbQLzpafP/QM3LWTsy7ek4N8Zz+x/BEUYdHUdGNAyzTX9da858/d3Yhyme3
         rQPg==
X-Gm-Message-State: AOAM5307eEMGJE6R71LiTjqhVpKkkmj0H6JgjqUn7g63hHwOPEK9TpCw
        g82icOrT1OJBSUaR5cY+4b1KTrwYpi1wic6yQBdSJw==
X-Google-Smtp-Source: ABdhPJy7NCj6xQhFYdNxrNVAiKtFdkmV7VaRSAZZf6HeIgPM8n2Xemo4OZDTfhbHBNsu0GMGMFSIzDR835UkqQZqgmE=
X-Received: by 2002:a17:907:76b0:: with SMTP id jw16mr12118337ejc.169.1635764998419;
 Mon, 01 Nov 2021 04:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082500.203657870@linuxfoundation.org>
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Nov 2021 16:39:46 +0530
Message-ID: <CA+G9fYs6FbiP=o=4ACyQ6Lp9YgUpOr9Xtn+ZhHdZm2Z+rhBJZw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Nov 2021 at 14:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.157 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regression found on arm and arm64 builds
Following build warnings / errors reported on stable-rc 5.4.

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
