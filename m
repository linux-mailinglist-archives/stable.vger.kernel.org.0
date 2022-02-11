Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258E64B1FFD
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbiBKIRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:17:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiBKIRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:17:23 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402E7B8B
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 00:17:21 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u16so9231001pfg.3
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 00:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BRhdyHPO6pxhmoZenbCd5DFkYFwKSkq+xX2G7rJZdJo=;
        b=VTkf35datGbME5I3ZG/ERx6IBxNf1TBSegS6CtlX7Mc79lYH6FbUzSylxY7iVzFeUm
         WfqKI25lR86njWGpabHfRIvHAlE2lr2i2R3gk3KDhrxkx/m1R/UqBd7Jw1phWBDuUhOD
         R4g1G4PIYf0KHCFbVOeCMYK2zWQJedDrde77Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BRhdyHPO6pxhmoZenbCd5DFkYFwKSkq+xX2G7rJZdJo=;
        b=ebd2iVWan8sA8SkUcDDMTBsW78UefZCBZc8rURI0Qs2q/6AJoKm2ehcUxivXm8hm27
         ixMiaNrggaPgFu33jpb6GKMGYkPLtnGOPIuiC55mEGWDuy5pzz8zjt70axoOB6ZthgT4
         MwYM843bgyHXHoNtXcsJSKYR5MkSKqsk0YqFyJJRPtQ1g6gamXqFJvEHbPbtXEX32No6
         VZ0det1Xc2M2RlKgOzDMh1VJLUPN9K3n3cI9bRHnn83MR7kEoDMHO9lCNgoTeJLmCqEA
         eBfN7KKYbQQmqENCpzDRhCetmMx94VhOU17KHiCT0S4TwaWL1RrMjdKzZB//jgv+U9bD
         q2jg==
X-Gm-Message-State: AOAM532x4nPTj7bZaznAOVkWaECwEGFujbvMq4D0Q/PnlXqcqi4J9NrU
        e6SWwfKbMG2XGaPz2n4KsIv2QQ==
X-Google-Smtp-Source: ABdhPJwpu9qZKsbrkfR+8XnpPW1JuZotWgf3UXc8UyRjii33cHyKXSo0dBFRAfDvg/WTr6D9TKC7dg==
X-Received: by 2002:a63:2322:: with SMTP id j34mr388612pgj.583.1644567440615;
        Fri, 11 Feb 2022 00:17:20 -0800 (PST)
Received: from 02a66449913b ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id k16sm26260605pfu.140.2022.02.11.00.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 00:17:19 -0800 (PST)
Date:   Fri, 11 Feb 2022 08:17:10 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
Message-ID: <20220211081710.GA1189530@02a66449913b>
References: <20220209191249.887150036@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 08:14:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.9-rc1 tested.

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
