Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B85FBC13
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJKUdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 16:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJKUdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 16:33:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02A97754F;
        Tue, 11 Oct 2022 13:33:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n12so23312261wrp.10;
        Tue, 11 Oct 2022 13:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TEfDO7QSA1VFUb1GFHQrZIKppKlP130P/LfPX2c1848=;
        b=Fv9vlBHbLmlL7TVnbRR+Ibtab+81I978qi0S0OxNcTZoPX1NadHyd5UZ+ZSgCzh86F
         RYPdPghZ9cxOCpru66PLoZ2d2jlSNYVgwl1Qc3MRJaAmy3FQ3ZtCF2esiA/YqMHsdzzn
         Zd+BEbF3oOESG3C7tlo3dj8B/hmnGg4YJNZUFnC6BT/IGAbCy6Bc/nCE0VgeBrat5FLh
         6rbWzO+pGSEh7nRi0w2Fq4dB/ZJpYqO99+Sg0zRE+LQt5GglCiZpjOBq8TIIYS/FvN9m
         dqvmPuOxfhObIbB+LWN1ySNgqFJUNvkbUpPwH5Q8fgQuHysg9RIkX/ySkQ5LvjsXZqDZ
         mkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEfDO7QSA1VFUb1GFHQrZIKppKlP130P/LfPX2c1848=;
        b=DZtwAGGhg60cbrI8bUg37JC7o3HKcKh1Cml0knZYQOd6MNa3NwYd/FApSxkwLcZ3hG
         MyFQ+Wm3S0+hqxlmbx2hWDbvI8g/rCz9Yin2kar8J/DwJDK2rpaMjl7a940aq5hyDJdt
         5ialFOpFDg3Dsm0gFkgB/PPCXPmcDblKAdvpOgX3qdov1+vEd4fkH6H0B9jFNBxkMV/p
         XIe1qWhahdTcQdErGsxCtpGky5obpJS2sT31QXqobypLN1SmOkxPONqNjr76bXOz9x9W
         GU1Qg8cAskEU5Of+0OBAV6tsV3bNsa74yimfAOJQa7zrCk5I43YtiVdXujXLVEUJOktb
         k8ug==
X-Gm-Message-State: ACrzQf1AiJAhUnBI+w0jbP/LPwdEkabPzQ1lfA1HKTnB5nabIWUBBEdF
        /zY77Gqewqfkvrd8Vw4YgtoTLTIrBcA=
X-Google-Smtp-Source: AMsMyM5GUmB1SbiRoxh3oe/nd/8xd6XNVsEy0/YPik7LBUumeMkmp6gTsUiIW4KqeGUUyP+U2bcbHA==
X-Received: by 2002:a5d:6741:0:b0:22e:2c5c:d611 with SMTP id l1-20020a5d6741000000b0022e2c5cd611mr16383458wrw.210.1665520379305;
        Tue, 11 Oct 2022 13:32:59 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c0a0a00b003a2f2bb72d5sm28872537wmp.45.2022.10.11.13.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 13:32:58 -0700 (PDT)
Date:   Tue, 11 Oct 2022 21:32:57 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
Message-ID: <Y0XS+caa/JtjuyP7@debian>
References: <20221010191226.167997210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 10, 2022 at 09:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1971
[2]. https://openqa.qa.codethink.co.uk/tests/1973
[3]. https://openqa.qa.codethink.co.uk/tests/1979

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
