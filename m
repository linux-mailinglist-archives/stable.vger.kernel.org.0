Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C439C5716DF
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiGLKMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 06:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiGLKMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 06:12:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FF5AB7E9;
        Tue, 12 Jul 2022 03:12:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a15so7224102pjs.0;
        Tue, 12 Jul 2022 03:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GJHAyI+gOAQT06aTy31YV3rQsLoStm19R84REvIUiSA=;
        b=hGm5QhWIfhqSgIu4L/4nG/qe9573VSxcSvCReID5xXhW4Obx0xqfgb+k1Ibbjfdh4r
         A8S7jP1rKIZvbvSt2lDHu3ebYuIbkfQkm778qgwHX8Lb49mTPMAp/HNeV0iG3Q2SEM0r
         J6ePuwwbD2DEXLcKjzMYU9qhHnT6hsGo+p3ml9UZusQ+fRf/pBZwbLBnJT8/BG1FtaFV
         IsNc3B0uErQJER4jBWy08+OHApNBiqrDIkJvy3OEOhXqvmAW7sCYys77sT0vwG7HIjlW
         QvGZVnlCILu1bYG1xQ9iIFYgv/HESW8eODrBYSoVBrZ5XGJyZQWkZcmZoLr3DpdWLJXy
         fnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GJHAyI+gOAQT06aTy31YV3rQsLoStm19R84REvIUiSA=;
        b=SswMZvM2xW5t4EZxui+HewmcupJcUyKnPUH14t4/hDkgODp66T8Ru/ncwNE4Z2yp1Y
         LDHbCzpV9S0BbO0dSphxz8fQAJXmJY4uPvZlnfE/tGV1cyzYoLA1F5uMmbIAX2eW67kH
         qMak1UjHV0JbKzP0E5mzbS4IPARjZamt9K87dgm2IoPdZQfpcYgCAoXEqV6v9tzpc7VH
         ar0sXzJ4HUTTILr2Jrxs0fQPhcHzWPv6kFai6empOxuWxUi8DWNEtrbgVFrZiVVfcnzy
         BzBCJ6H9gJiT7LAV7aB5u101PragNdKLSHvUBJU/kvHn1x2BjnIJ48uM/IPPbrdvmbbJ
         djgw==
X-Gm-Message-State: AJIora+uqNMvG5cczuT0uoZsBhYXdUfA7RpDBgJz3PqsLU2oPmjQ8Jo1
        XzztnrZFej/b3DGkO1XRie4=
X-Google-Smtp-Source: AGRyM1vh6jaX3SVXXaQiNPM2pKUXZq8Pl3gen4M8EErg6Z1PcTQFVpmVsEqzlMkUvKjQM1qarKHgIg==
X-Received: by 2002:a17:902:b093:b0:16b:f20f:ee1c with SMTP id p19-20020a170902b09300b0016bf20fee1cmr22615952plr.37.1657620729905;
        Tue, 12 Jul 2022 03:12:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id e16-20020aa798d0000000b005289bfcee91sm6438896pfm.59.2022.07.12.03.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:12:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 0C6FC1038FF; Tue, 12 Jul 2022 17:12:05 +0700 (WIB)
Date:   Tue, 12 Jul 2022 17:12:05 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/226] 5.15.54-rc3 review
Message-ID: <Ys1I9dL88ocqoluR@debian.me>
References: <20220712071513.420542604@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712071513.420542604@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 09:16:20AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
