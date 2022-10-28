Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C58C610E3F
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJ1KSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiJ1KSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:18:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A47C1C20AB
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 03:18:11 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id io19so4460268plb.8
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 03:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DSKJv1f/uVlp0hff+snMR0wsnevB65aMFxEQQizFBpA=;
        b=Qv3qfdxLvWItvoVyHt2AVoKll3nKREI/ZG2asPBKUQPv2SRMcjQtGtUTs3+WFQo0O8
         9HcNkQymRFA1X5r6hdlNRK725D4tZ8a3Wge4W3747Ck/ZlUPgtCd7PmnkzjXqZexAEFv
         Hn4aajmyzXT0xc5THfW/EVLed5s3VzMW2xz80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSKJv1f/uVlp0hff+snMR0wsnevB65aMFxEQQizFBpA=;
        b=XPIel4ecnPgUXCNrkUo9efOqyXODN3i7sJk6WsEVHm7nMx+/Z/0iwAP48/EUgLVQiQ
         mAWvMOtRObvKS5OWBwxYXgDT3lSEbzxLmSgS8cIOVIsqww8RgLbsthFd5FUUnPNA61I9
         Vepofb74+paWcpVnUyvbdJjVf4C5CKO7jrqyRkXasqBh5nXX7SLqxbQivPOEHCfwogb+
         eiKLndN/xbHLgkpvJhASpnT8wlN1LbCPYgjQ+4leLxZ2FLKmTzrIKPOeSoahPGJ3phIC
         NfKwZWKmoxuF707SAPhZieWVpsnPfnmJhd9aZNb3CRlssNhc1iexcPuI6n5mGeeFnKjZ
         A7cA==
X-Gm-Message-State: ACrzQf0hylF9q7JiyITLH+zduCo6p9SJne6lmk6tWcm5pwcocrzaHSTV
        18v1DnpGEWPCg6W5UcsVush28w==
X-Google-Smtp-Source: AMsMyM42VLGabApraSGNSPouVxxKriSgE7M0ZYJbOsPjhq0ZT8JFO8iTPEyhcjI2rjlhMo2Ky+1lGg==
X-Received: by 2002:a17:902:8685:b0:186:cb66:d77b with SMTP id g5-20020a170902868500b00186cb66d77bmr17207873plo.39.1666952290879;
        Fri, 28 Oct 2022 03:18:10 -0700 (PDT)
Received: from 377995ad3d24 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id bt20-20020a17090af01400b001fb1de10a4dsm251163pjb.33.2022.10.28.03.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:18:10 -0700 (PDT)
Date:   Fri, 28 Oct 2022 10:18:02 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <20221028101802.GA2440677@377995ad3d24>
References: <20221027165057.208202132@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.6-rc1 tested.

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
