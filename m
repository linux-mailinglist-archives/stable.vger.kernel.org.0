Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548D2695399
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBMWIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBMWIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:08:42 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D644A273;
        Mon, 13 Feb 2023 14:08:41 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id o8so12682068pls.11;
        Mon, 13 Feb 2023 14:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W+gcSvHvU6UymGoZz45RAwy5Vsnkl1I3eLa4JIYkdC4=;
        b=lEikct9bSEZRL11bxmcmWgyEywCcGKveo64ho6fIWJG8NSTP5wcH7GvgHp1wAEmMUy
         vSrLKxvxE4kKk7FEs8gSeRag25/sE0MACEQV7j0ZPCRO0QiP2SDeKM1xtGHMqa025zNX
         A++qjmrJyeCPNnrP4RXT/0oowwJSXKKkhqk+PVL+GNjCZ51iOWpvfpOLUGM/iHboHqbE
         h8c+r14XS7eNR9LJZpTfJVREzt3XqEVA5kFw5/2d3oJxfFKD0N0e9ondMjCDBpag7bg6
         oNOQZIEzDRTA1oeRoud8pc7mSs4VTCoU3mVBi6iYIbLc+BW1V0kOv6fZBjdQQuzLMIcq
         MDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+gcSvHvU6UymGoZz45RAwy5Vsnkl1I3eLa4JIYkdC4=;
        b=2+XCCYFAnanYehG5ynjhYbqanOHyPxAWT6DhGLMCUO+2K+6hqgjxvDrjP34/jSk626
         WhcmULk6i5tYnXLLmOnc3dKT4pH80NbhmwhDCYsUpZ1t4R1/EGbSsKQqbd57Qdnu2Eb2
         qmXlhLGQgOSEHp5Qelq2sKLX1Vtw0/b0PDRA6vq0CXrC+apafW1/6mApun3tCAFWHD+P
         nu7CILOQ29V6l2BNCCZE2jin32ymRitjnZNJO6PASuhCaabpLtlySd9X1K8f6X/dSkuA
         Uwe6EqOqanqOU6y12c54k2E/ge75iNXnx2zolMnS85usyVpVYT8dSx4z2Fud1pOdiTcQ
         kMxA==
X-Gm-Message-State: AO0yUKUC290ayDYKUPMd+OxjuPJJfISXdCbPhaZzh77MLAHuwdd9KiLX
        CUWd6tC2CzqIu5uPBkqHBM2fc8W2JF/T5jWpqxk=
X-Google-Smtp-Source: AK7set9Z2gYHrqDUdqHRUENE74lt4pZiEBYUjRjGkGBfT6LexXDlA2xYO1tTf2N2OJbM4tRXoeN26UVw5Z3iwSWTaUo=
X-Received: by 2002:a17:90a:656:b0:230:8c47:fbd7 with SMTP id
 q22-20020a17090a065600b002308c47fbd7mr4487345pje.102.1676326121038; Mon, 13
 Feb 2023 14:08:41 -0800 (PST)
MIME-Version: 1.0
References: <20230213144732.336342050@linuxfoundation.org>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 13 Feb 2023 14:08:30 -0800
Message-ID: <CAJq+SaCcXmFn-qRPgVUgLc_omG0EgZctOQ9e6DxkWAm4Uz7OkA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
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

> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
