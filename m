Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AD765B81A
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjABXOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 18:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjABXOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 18:14:42 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071E65FF7
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 15:14:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jn22so30819848plb.13
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 15:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yY1/fILcvpRKU0bivqO7pZp67LzV2ztHWexSOMGIEMA=;
        b=TCRnubnPXGHQLhXQlKNrDr/X2lJwe0KUUl8A8CkpznfvxckOmJDG5eAUFg48aSiMSJ
         YssUAUVY6FBfgbpCoZqRobxlaOtmnscYOR0FLoLlZgykZzMD7IOWTQjPqXiW13erE6gT
         RD7JB+qoAASDKQb9mA3vDEG4RGwdZA1EHQuTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yY1/fILcvpRKU0bivqO7pZp67LzV2ztHWexSOMGIEMA=;
        b=l8XXvh+zskvO+f5gG59KM0QmcmyWMazyP72fD7h0OJC0Fi5x46RmCqT/5HnczJu2/h
         ZnQdDP7qQmUqqIKkw8gXITsOfv9qHWhRcRPmTPXpt5kw3MklV55gxIA46BCAXz/ji0Zr
         EOd3c4RuIXcqF0lCNY6HwGUx7XCpsikAxWwZ762WVppfs75rRtM/gt6Ckebpe75+UomT
         CMSaGn1RJKONprFdiJBm0Kqn09JQ4AtZyl4RxwIiGy1GowGyP+v5XYxwoNIJtRF/X8vt
         unx+GJrgI14kvs1oFNevq8eGkEOh8EhPrGsuoVE4ipsGh2GNEUsJEj4Xm7nthzWSxGO0
         OWSQ==
X-Gm-Message-State: AFqh2kpm7jYmTZ4yHscWMGacSNmvpRZHyxoY/wfrbOmmNs3t1dr1SQrO
        4b76gURg194ffn7sDzJZmlERMQ==
X-Google-Smtp-Source: AMrXdXtoAYcG8xDuM42hw4tVM/z8D/1RnpRghd3d33P7z8/RaL1+pkP0JK9AATFXvQhQePTOBpj0mg==
X-Received: by 2002:a05:6a20:e61b:b0:af:7ed7:d370 with SMTP id my27-20020a056a20e61b00b000af7ed7d370mr49572017pzb.43.1672701280240;
        Mon, 02 Jan 2023 15:14:40 -0800 (PST)
Received: from 911e562c0830 (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id n25-20020a6563d9000000b00477bfac06b7sm17516769pgv.34.2023.01.02.15.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 15:14:38 -0800 (PST)
Date:   Mon, 2 Jan 2023 23:14:24 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <20230102231424.GA8@911e562c0830>
References: <20230102110551.509937186@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.3-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
