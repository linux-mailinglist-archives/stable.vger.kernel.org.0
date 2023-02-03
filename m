Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49F6689777
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 12:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjBCLEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 06:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCLEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 06:04:54 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6126D6D070
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 03:04:52 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id g12so897941uae.6
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 03:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wnrwfiCPx7vL+qz/J1ZaOtVtgqhukwB1qeXvDIQyZGo=;
        b=oxTdMXY9RjdoTFpjfLHxRYwBYx2BDlYAdVzmsIWSIppFdAgcmhtjbRvQ3oOxN7i7t1
         zL7pc46FSr5hcUBefjrWpSGoUaUIDoMdgQGlJsRsJ76ZYt+LOnY3rP34yhAa+93TtOVV
         LP9k88clQFViMdEILQJskXeHjynXHNd6iq/RbpJyZGusBlntR2SfxmcDm5z7V71vRxYW
         E5xDX68zdZKhglajGdbuQAbih6jwrY9DECDOL/ODcMbQZ6aVqm52zzkXkQ6pHUIWrV3N
         eV/V/6tEw9XAn1Nbcq2jJ/Rt2EsOZMk1Jvcwq92FpI1I8C0etXaqITKCDT79j6UB7gTY
         MvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wnrwfiCPx7vL+qz/J1ZaOtVtgqhukwB1qeXvDIQyZGo=;
        b=nbY0fK8p81bmzBtf/peD0AYgwgOM43T40ufRCjHO6edPrAxYTekplF0Am03QTgqZHi
         IfI0w1flcPiCTuCcUQwi1HTPmJWGC/gQ2kWuZDwshxt27gGlPNTb9o89OEQEYu3965kA
         CEL9YdAi+c0VpaIj6ep5fxaSo2V+yO9dZrdrWnoaE6FYqnhMx1R2y2jQG4wxLdrANcAq
         qnOVkNueNWYM0O1ha1ML3Z3n8gT5/09vh2DmiuxfhCwJCP00OBDKKdBHqHzrZJtCfeM4
         IiXkoBC7fKQpt/bB9bMcq5WC/Kq2G3nMEu8DFlQPx6GFxYLW1ImfEHyb846lFm87VdfY
         Xtzg==
X-Gm-Message-State: AO0yUKXRxKfrxVeUnwqp7rPUzKJdB/KFcgyhNYB5x6bcXZmvJxSFhN3l
        ru8mbujBPAXUCMkOwikwx64oZmR/lCxujEL0Uy0fPQ==
X-Google-Smtp-Source: AK7set92aeZ/0wrMCHop1qBlba0EQ1xdx/6wHYhZYAkDlHH+pESAFsHybxatTahoAeHp/QIkKSBkQhCILu7YGoc5iDk=
X-Received: by 2002:ab0:2059:0:b0:5e3:bece:86a3 with SMTP id
 g25-20020ab02059000000b005e3bece86a3mr1478802ual.48.1675422291331; Fri, 03
 Feb 2023 03:04:51 -0800 (PST)
MIME-Version: 1.0
References: <20230203101015.263854890@linuxfoundation.org>
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 Feb 2023 16:34:40 +0530
Message-ID: <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Following patch caused build error on arm,

> Gaosheng Cui <cuigaosheng1@huawei.com>
>     memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
function 'devm_clk_get_enabled'
[-Werror=implicit-function-declaration]
  297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
      |        ^~~~~~~~~~~~~~~~~~~~
drivers/memory/mvebu-devbus.c:297:6: warning: assignment to 'struct
clk *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
      |      ^
cc1: some warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build link, https://storage.tuxsuite.com/public/linaro/lkft/builds/2LDxPVbsGpzKKtYLew33pC6wCSc/

--
Linaro LKFT
https://lkft.linaro.org
