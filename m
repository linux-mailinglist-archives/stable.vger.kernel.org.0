Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672BF5A665E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 16:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiH3Odo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 10:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiH3Odh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 10:33:37 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0ABB6D2C
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 07:33:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y127so11536222pfy.5
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 07:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=GUYgovoxwFssEe5BGbUlJPBWA2o+QO1KVaImYyXVu24=;
        b=CzLG8FCoj4AsXFUl3AnvsNoUlHTNUM2lMsQVuMKfxsZeYSb81mGoUd7VO+sG1Ddlvw
         uzKqMyXORxqPw/bBLkB/H8Pm+lTtfFvMroUNtjvvj73IS8GpQOAFXIwsw6GqNyQK/dgB
         sIByymieZn0Mfz8xVpVAV8iwCBw3vzb7USayo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GUYgovoxwFssEe5BGbUlJPBWA2o+QO1KVaImYyXVu24=;
        b=guC6aZrEFBkJM8OJj1/ZFiKGJkkaf6KdiUz+IziWFSG+yj4O/FgjKwSfsOqQMM+nw5
         VBRCXmRFwlS52fjR1VkWMId5ruP6UHruUtLAVC8PWD6Wepyke31T2yoF5i2HrLGqKsk5
         2gs7GKd3KM3Ib8qCtTuq9RwsM2eXp4aStQ8D8JwmRpspAt2AAEDnYveVEln4xl0sCcg3
         zZux8DOYRn/td/VQe9OvMCGtOCWxGEyrr4ktUTcaKEH9CNxRkrm+28gD4BGjPCn0ZhW0
         Gu/squoYiVd6hUO3ajrKubFkwQ27GfRrQKwJBPtEIZlzlJnV22bKmkQqzkt42US4sGIn
         W2DQ==
X-Gm-Message-State: ACgBeo3Frb3OTVu0xjy789queT02NKmT2XFxjIsi1zFJG9WuS6dQ7FL0
        TwMUFjwiLsPQEGji8mdxeS/qsBNfMFRfrinA
X-Google-Smtp-Source: AA6agR5Rpm8R6PchJRMrnmNiYa9yfX3THHmmFIgMt9I3LK38qaD/L6X9y1Lin6cigI28qZIjwSQgBg==
X-Received: by 2002:aa7:8a0b:0:b0:537:f5f1:fd91 with SMTP id m11-20020aa78a0b000000b00537f5f1fd91mr15881451pfa.41.1661870013539;
        Tue, 30 Aug 2022 07:33:33 -0700 (PDT)
Received: from a1173f985c48 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b00172cb8b97a8sm10099795plh.5.2022.08.30.07.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:33:32 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:33:24 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Message-ID: <20220830143324.GA2972764@a1173f985c48>
References: <20220829105808.828227973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 12:57:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.19.6-rc1 tested.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

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
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
