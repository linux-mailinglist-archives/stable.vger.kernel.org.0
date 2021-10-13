Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCED642BCCB
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbhJMKae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbhJMKae (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 06:30:34 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E99C061570;
        Wed, 13 Oct 2021 03:28:31 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e3so6527327wrc.11;
        Wed, 13 Oct 2021 03:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ral6h1tS/Y8AxHiORz1PAlmTJNbW+hQ0rnEVxgtggSE=;
        b=Cxh8yC29q8ACGrL0gQi5ebe/LnFIGaJ19BAYDMYlKjbFMp5JSipBgZGGpPaeevLd5m
         psznOgusJWblZupax9JiYRX5bo4NNuJ3AMVPzQ2SkYh9zJZ8i2SVO8Ia5LGoGSHuMON6
         A/3P4b2DHtakxpY4ifZICTrsIaeOc0CBq2odNkNGXHP2CVGzrsHUslGjQQMEGs42OUSN
         UVgmr2np4ExxfMoSd/+5zjNQeO2EolwlzYA2ztkUyp+TMPiqHLJvL3ni66wEfyDni3Pz
         zbCltodVxmHE4Oo6PgAMZeS72VGG+gLdFJ10yp98Q52wDrK0CDDFqxLtuZ0ATQ7bvTJH
         e1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ral6h1tS/Y8AxHiORz1PAlmTJNbW+hQ0rnEVxgtggSE=;
        b=pT3ehrC1mPPVK4CryrCtVtq+kHfx2hWLm3uER0ZlKa+IbYiBuPGgfmgHfNYHWKcq6x
         XB7trruwbgEEDJZ55RL+wIWmhrY0djuK7UqXDHeVDvaw6HtixGTmsnXvaEW+xR9QQ6So
         GiFhHguFdHFKLJJprJRokTRr54uos/eqeNOsp5kMtNa5OX8DVTaHsKugHnBEPk8IuBvr
         Dvf7a9QEgFquETCV8l49Wm3Z6hX2m1BHqz5HeYcfXmMH2RilWIaCm2c8kgUoVhdHFK/r
         X9dU5fi7feM6dLF5AlYL3HXCxksJc8OilbQbn3D/dOB9yxOTAlHFGVMo7iGtxMWPa6d1
         NWWg==
X-Gm-Message-State: AOAM531tV6wwFBqg9nrTTqgXq+S7dh54hJqVpGW5YcdSCC0bDBYct8BD
        bwOUx5Gf1+kBTWfAjP58ig4=
X-Google-Smtp-Source: ABdhPJw7MAD02Z/Rb0vYMyNnitDBMJ1MIj6655WTlv6SRBKKf3UAgSOoHJRDAXRL/xb1BPMrNSkc1A==
X-Received: by 2002:adf:a15c:: with SMTP id r28mr39145755wrr.287.1634120909699;
        Wed, 13 Oct 2021 03:28:29 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 143sm5072186wma.37.2021.10.13.03.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:28:29 -0700 (PDT)
Date:   Wed, 13 Oct 2021 11:28:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/81] 5.10.73-rc3 review
Message-ID: <YWa0yz9CmmVEbGIS@debian>
References: <20211012093348.134236881@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093348.134236881@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 12, 2021 at 11:37:11AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no new failure
arm (gcc version 11.2.1 20211012): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/254
[2]. https://openqa.qa.codethink.co.uk/tests/257


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

