Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5B5617CFA
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 13:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiKCMrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 08:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKCMrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 08:47:23 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BEC10B5C
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 05:47:20 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id v28so1468905pfi.12
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ai1/5dAzhZlS88IHHgtwtwwh76LpHQeFyO2vtqtpFhI=;
        b=icYgRKfbIswfs6glHbUqckB1v3qAjwvkr6ejII+z+SAaK6aTVUIEWTcnrWKr+Xhyw/
         7go231JI+G9UCcBWpjmHofKcf4eBX/Xcu+R8pbWVxgUhSD9so9MNI6Udf7v8DQSOMGY7
         c4Etx9y17vyHKbIJ1aHuU4XBO9pPEEYlD3b0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ai1/5dAzhZlS88IHHgtwtwwh76LpHQeFyO2vtqtpFhI=;
        b=IOLY3j/gWj7OO9AD3t6DdmLrC6aSTyMt1UY6dsEtkOEdclRFpqDujC+Qp+U7ulciCA
         qwboXlbWH0333ya2OgdWBa7NC94hRC00QW9pnJO353mp+DAqEl8894qlLFVfe50JnPjh
         WNhifFRyPpHRS3xMWvJTfVku26K4YULhDrvCtmNFxzIPa+AmljXDwQeb/zMU2M1bJP5O
         3o5WyO7UcqkONgrJHdSIubYl9+poK4TiYlIPoSM287EFGPrYsPqrq2Juh+e3d+QLJ67S
         7l3isK4iZEy59DjAhV2OCa5aVAb6FHoxnluAS948YLU5xg+N7qIDGcgWCD/hSkoOeN4D
         N6iA==
X-Gm-Message-State: ACrzQf1Nyga2eCqbSt0y8tbpdhvGIY9Oe0wImvB5KRmuoJdqcrxVt/iw
        G9PSXD42u9mi5exhcvKiOqr9jw==
X-Google-Smtp-Source: AMsMyM7UNsWm2qcVJhow2AVVmu5cO8//EYQikcoYCSKnbx5YUyXTzHK95pxhrZw+H9G0JwH39w8Tqg==
X-Received: by 2002:a05:6a02:113:b0:43f:3554:ff9c with SMTP id bg19-20020a056a02011300b0043f3554ff9cmr26645532pgb.578.1667479639891;
        Thu, 03 Nov 2022 05:47:19 -0700 (PDT)
Received: from 3532bd7d3047 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id h13-20020a63210d000000b00434760ee36asm722541pgh.16.2022.11.03.05.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:47:18 -0700 (PDT)
Date:   Thu, 3 Nov 2022 12:47:10 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <20221103124710.GA9686@3532bd7d3047>
References: <20221102022111.398283374@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.7-rc1 tested.

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
