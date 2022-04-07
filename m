Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361C04F8B6B
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 02:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiDGXFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 19:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiDGXE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 19:04:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C83EA340
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 16:02:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a42so324975pfx.7
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 16:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KPjsNugsFufNfp5KAkkFhkAYOUJWtTDQBFNdi9gJR8Q=;
        b=Sy8mNZl1IAA1KYzYQtg+pjFwuw2TZRFnjiS/k6x0fGJaq+B4qeAdYM5HK9wOEgaSYw
         7dcVKYMG3iOXVKfkoNipUJaoAtaqy2BhkTVnT9jzB/IVqb5PYIbG6bMfKqfMgmRx0L2D
         ekGCFtkFeG/B2t4NBOMHh6UQHfNTIvsB/8tp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KPjsNugsFufNfp5KAkkFhkAYOUJWtTDQBFNdi9gJR8Q=;
        b=KoAkiGsxKuV0r8DZueuBOwPXCdecU/moUiBuIQ5xMcjQqZ0+4pisKR9VZQunQpYY3H
         qkbFqdvzUT7S2IWLQgUPZj/Le6R9hq+2Y8rNfZnsN/e8he7CSTg+V+5svkLHJodXaPiO
         qbbCl/VP0RGy1hHPtzUVLu6/0CYJHLeotde6+FTRAZ6JPNcg8QqMaeN7w3Z64+C38nNh
         LJnoy8kIV3KASnHiIvbEX2fzqYZwyN9v+KX8DIVZGiRapHwakQ9VuWwAW0wbxRfRQWIM
         PLq+LsXbXGBIuiMVA25wjupt8y29eYs/Y06uOJj+tNY+0Jr556Y2kmsq92z6DhaM/tZ7
         OcCA==
X-Gm-Message-State: AOAM532J2avQJP/rgjrTmXWQJ/dqxRyNNlLVmdZhnUuRN1aUDZxQi50k
        C0vmfLyK5gLTHhfhd+4fTFSypQ==
X-Google-Smtp-Source: ABdhPJwr8mF3dmoRNPbebb5+exDk9+QDeBNVnq9gxMrkwjMEuLrHDbD1lazo0isTvScqcYZk4fH63Q==
X-Received: by 2002:a65:6cc8:0:b0:382:1b18:56a9 with SMTP id g8-20020a656cc8000000b003821b1856a9mr13110885pgw.347.1649372576683;
        Thu, 07 Apr 2022 16:02:56 -0700 (PDT)
Received: from 8885333193d9 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a890a00b001cb14240c4csm2714723pjn.1.2022.04.07.16.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 16:02:56 -0700 (PDT)
Date:   Thu, 7 Apr 2022 23:02:45 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Message-ID: <20220407230245.GA1588355@8885333193d9>
References: <20220406133122.897434068@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 03:44:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.17.2-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested on:
- Allwinner A64
- Allwinner H3
- Allwinner H5
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
