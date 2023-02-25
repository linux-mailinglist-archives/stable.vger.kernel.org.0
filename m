Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0356A2756
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 06:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjBYFOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 00:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBYFOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 00:14:46 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ACE2F7A6
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 21:14:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 132so741651pgh.13
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 21:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7+3E0JQU0FxnGZ5BiSmvm8Hsg7HD/6qbOk5w5ZRHjM=;
        b=bp8w2aAldxm/p/OyqulRx8jUytLCNBv+0zrDx+48+YYCEIEgvcekPK+EOvzaMhXmdm
         K2tIHohT8IF4hLdjyQ+6otPmdFxt/27jK3erFllZEVRwRrVX+F1NosY9FFIS8MLx4JtI
         km+YcszsNlpD2cG9tCM8K3x6oreYS0/P/qUz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7+3E0JQU0FxnGZ5BiSmvm8Hsg7HD/6qbOk5w5ZRHjM=;
        b=SqOT4OvjwzNxW59FbJ1djSeXe0uimAW5JDa2d2raTkWC2ZlusoYSp0XuV4PUAmJd54
         quXzyvFLuUHvWn8ZhSPZU84aLxETR7yORpvYA/HVAhfITu1PlkFi/aolzF+sRAYDAyRA
         K1x5AxD0AeS9o2Qsl3o6Jn9nUp29zR8/xYUY5jQOb9G/ktfsJFARGLnoBxnzul2PdrGR
         UTcdB9+lcFBrF2u5EDBb2U0sgeIvm8EPmED4iqXkBx6GMHHhaV2Ru88HSVjCQeD556Ad
         4ohT1luFy6JdCq5O7oBAxn3VrDm1QwQRZTTXtwyTzIb8WaLqD2pgGp5mKIBkVt2dNPjO
         yfSQ==
X-Gm-Message-State: AO0yUKXPnpcD2XjuLU16darcBNyuDL9BrbzEu6mui8XMXxTRtUgtih02
        /gu9cJrc4WFcuCsklBirs2GqW/NlJlzMSRYKEWI=
X-Google-Smtp-Source: AK7set8C3FnBa3BGaJvZ19hytTcjHR88q+nZp1elea7y2fP70VuzavEATg6qUnTZ4FAD1YUGwalOCw==
X-Received: by 2002:a62:184f:0:b0:5a8:b705:4dd3 with SMTP id 76-20020a62184f000000b005a8b7054dd3mr16642468pfy.13.1677302081607;
        Fri, 24 Feb 2023 21:14:41 -0800 (PST)
Received: from 5d49c37e6aa9 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id c1-20020aa78801000000b005d866d184b5sm404294pfo.46.2023.02.24.21.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 21:14:40 -0800 (PST)
Date:   Sat, 25 Feb 2023 05:14:32 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <20230225051432.GA704396@5d49c37e6aa9>
References: <20230223141545.280864003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.14-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
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
