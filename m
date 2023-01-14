Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9695566A953
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 06:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjANFBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 00:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjANFBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 00:01:10 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2F182
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 21:01:06 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so28938606pjj.2
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 21:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2OSXYnC3zftc6tOPQXjqTUoejZtZCYM5c1c4T9f3yA=;
        b=VXWrIfXUEs/qTjTjKnS8WGQxNqNX/fkxw7Th7cEOIgFOx/oZoT+PCWc6AfS2YnRyGw
         tmbhS1Mv6WY64p/uL77TAG27IWndr+SIFmG/oqPbPsf1kYajSw3wCE51LNnZdRKk5oH2
         dSiYDFfgbbVIrtL+pVMBZlqst+YnsOfO7kw9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2OSXYnC3zftc6tOPQXjqTUoejZtZCYM5c1c4T9f3yA=;
        b=nxIXOWphOQnt/JQDoweZ31o8msh4vkNQKXMox9z6dRqgRKPguN/yU2CINgoCum85tr
         gi6GJ/AQU7MY9yqEAHDzVfyXaA8aLAW+RSW0E93JUfWfNnYkQKrljkby94kIc+ms7NFx
         OF5o9kIuG0P0OUYGSo8yMGWk7lbtMtDCONztyT6chAqccHsUScAYK+AEUNOaMYjv/Ku0
         XelpMy+byNZsbGPgX38mH4XXXylEmrp681wsw3ifoglXWvWOQLbhwrWyr6RyCV6cqbFB
         72EJVnqFIAX2Dx70Xlf61V15hjIR7Oguxmi641sxpgsMS6gnYsafY3JDRanQ8GFq/O3i
         fUZg==
X-Gm-Message-State: AFqh2kpZZUhv04qs93O5sAVs4IHwQIVWuJYMWkGhr12+jYShM1zV/edP
        nrow+WHILtpAjUhfL9NPXt9kLg==
X-Google-Smtp-Source: AMrXdXtWJqgtoq448Tog8QHKKjiKBE4fBFzXtC6778zE2gWCq/RuwVX377z/tNfEcL6XpAu4auwZIw==
X-Received: by 2002:a17:903:3245:b0:186:95c9:ddc9 with SMTP id ji5-20020a170903324500b0018695c9ddc9mr12378008plb.55.1673672466092;
        Fri, 13 Jan 2023 21:01:06 -0800 (PST)
Received: from 7ef5778799b4 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id z15-20020a170903018f00b00189f2fdc178sm15039833plg.177.2023.01.13.21.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 21:01:04 -0800 (PST)
Date:   Sat, 14 Jan 2023 05:00:56 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <20230114050056.GA9347@7ef5778799b4>
References: <20230112135326.981869724@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.6-rc1 tested.

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
