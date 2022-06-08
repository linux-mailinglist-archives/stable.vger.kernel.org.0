Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52C542D16
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 12:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiFHKU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 06:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiFHKTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 06:19:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90755277F86;
        Wed,  8 Jun 2022 03:08:24 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso4985195wml.1;
        Wed, 08 Jun 2022 03:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S0u+T00ZJLZouFf9jMMiC4iqk7xEAxpj8F5R925qEZk=;
        b=WGAYnC+G3XjeAtXnOuVprRfxkIJ5h4wLKmzul9CaeF86DRHDfuwPj3snFEn0sUW2NR
         YHZWAwIm99YS14U4Pr2D6qoE375q2IBiutzr/4O5FrhS+H70O8vLn8ces3nk405JoK7b
         xo0URaPHo2FecAJrDHD0iI3lC781ZItVDRBVJpNFdwYA6u1RfTw2RZAVJxQxE3hduSmh
         zAcuPLiTWUrtH5+Tc4qziUDi49s+9fe1gprdGyLiOKbyiZ1xfsMnNZOBfKW41jGQzykM
         24PI9+t6vWeYf0mvig75Gq/7Q/z8zLLyBYxeJi1QCBuqzrmnybiL+oss6sfI1khbCXCd
         fO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S0u+T00ZJLZouFf9jMMiC4iqk7xEAxpj8F5R925qEZk=;
        b=qp0y8gdf66vN+76WGdavfuDIDhxn5No+Hc6vHNBr//GoKNYIDCSB7BRCx7z90I7L9J
         0R8t3BaH7tzXAwfbyQJR6U7TGMGckHjPGNJt+9zixk7ApMUWxh1t2Ro2tYrswp3PbW9R
         /qcnETLUKu86iSK0sUVJ7PnkPbVV+eZmlhNqf2i2HD5bNYasAzKPs2fS9gulJNIii421
         zTzVANT81RWfayBy+CJeKUKAWDlXzQ1zmiIkK/q5V48Ncapy4AYWtVJPYMvZLLjrkwMf
         mutSMOYpiK3nXxD99aG/C54pRtg7wEjA4FxezSbVStivKExVKE6rtVZK7eXuKVdhyoXV
         k4yQ==
X-Gm-Message-State: AOAM530CkRphED4qACethrIBWfrDkL2RNvic3UKUT8QRTaebxiAFqfA1
        9DPCQ7XCtMb82bKhCqN97kY=
X-Google-Smtp-Source: ABdhPJwWU4FRDA+XK3tRnpgAznD+pbTzHdRl02gErdtojZBAe9s89cL4y5jgASIZLY7R6/rwDa9SyQ==
X-Received: by 2002:a05:600c:4fcb:b0:39c:64cd:cc89 with SMTP id o11-20020a05600c4fcb00b0039c64cdcc89mr1460557wmq.197.1654682903012;
        Wed, 08 Jun 2022 03:08:23 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id k7-20020a7bc407000000b00397402ae674sm5303322wmi.11.2022.06.08.03.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 03:08:22 -0700 (PDT)
Date:   Wed, 8 Jun 2022 11:08:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
Message-ID: <YqB1FIjP0Tbdg+Om@debian>
References: <20220607164948.980838585@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 07, 2022 at 06:53:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.14 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220606):
mips: 60 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1290
[2]. https://openqa.qa.codethink.co.uk/tests/1294
[3]. https://openqa.qa.codethink.co.uk/tests/1296

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
