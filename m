Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8E05FAE0C
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 10:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiJKIKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 04:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJKIKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 04:10:35 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F9E4F64A
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 01:10:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id i3so12831267pfk.9
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 01:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ecfMTMX3cggnJjs0i7b3vIQTWJN5axEUeV9MxSksoNU=;
        b=EH2H5wCX576KTCQ1WY/QaTtuBEORb5HxC+aIAZmUbHrNd2l0skvThk1IzFnBxPdUS8
         8zAHmLeNehZVgP04xVck2VC+1TbqeturOvV0FQBiPZ2FiPLjhfAXfWmzPmWyN2VJt/mK
         +lw44dv+10y46heMLyf37pW6cBrncuf8+/9vs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecfMTMX3cggnJjs0i7b3vIQTWJN5axEUeV9MxSksoNU=;
        b=uzb2hudV8Sp+w3wwDO/eV4UlZ8JtVDXt1MnnDYq1JvpLH1aidk675Si5wMlhS4rTNf
         eTnA89trfOgsAPNN3SScfEkKp9fdMVoSDLaKFOfVMIzLdKfwRWe+Y7kFzjST7jHMPBeR
         vYrhIf985y09cv11JiMClIm20HbaXJctCJiMBvQw6jvrsoPvBCzGgUHs1eecWGLUEh2G
         VS62YKeP4luultpE+dHapN7p95vGLMtAuP26hQhmklGfvmVTW1ihk7RmLQ6WdaOirKaX
         UnIsQ2Gi/S+gj+ZBcjyqLQLz034DToJ22ucC2CEUDzoya5tyjGSYoU+AJuY3DRCRi/K8
         Os8g==
X-Gm-Message-State: ACrzQf3mahTmtjIs3eBjXDNXIRDUCHpBjf68a6eiTZMFtKoOcnDeb7iY
        NjcfVHbDj+Fre3lsuRWTbvhnIQ==
X-Google-Smtp-Source: AMsMyM6kThmxU4GI/66VPrbo6PGo0fShLgov4ldsUJM40Ov4uJ4odeCDuNrMB4etZ1ohoUV/xdUSHQ==
X-Received: by 2002:a63:106:0:b0:460:64ce:51c4 with SMTP id 6-20020a630106000000b0046064ce51c4mr13157187pgb.17.1665475830277;
        Tue, 11 Oct 2022 01:10:30 -0700 (PDT)
Received: from c6366ce5e367 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id x188-20020a6263c5000000b0056268979639sm8244615pfb.123.2022.10.11.01.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 01:10:29 -0700 (PDT)
Date:   Tue, 11 Oct 2022 08:10:22 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Message-ID: <20221011081022.GA75@c6366ce5e367>
References: <20221010070330.159911806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 09:04:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.1-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
