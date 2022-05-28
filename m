Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D4B536D23
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiE1NkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 09:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235958AbiE1NkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 09:40:14 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA81B7B3
        for <stable@vger.kernel.org>; Sat, 28 May 2022 06:40:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y199so6645801pfb.9
        for <stable@vger.kernel.org>; Sat, 28 May 2022 06:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z2I36pyp++iUoQJD2HpewB2s7uOVl72Sx1DqRb0ncTk=;
        b=OfseZkluPcyA+BVHqm0h4MzykAffJQ4o7ZPKfc/Vvo9CKo3b/3WnL72fHpFYRR+zPW
         DT5h9w3RQ3AFY1t0svQuat9CGpTEjt1W+lKMUzv2gqcaJ9sieibyDf16f/+cjSiFAehF
         gLarLObBGvfCqscA/MmaljiKS3Ebo1ApaHxBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z2I36pyp++iUoQJD2HpewB2s7uOVl72Sx1DqRb0ncTk=;
        b=bvJKUeUZVeF6hBQJBofALNJsAHXxU78Jv/dhdJVMbcanrjHAp2/dpmwMpiTx1lP83g
         /mG2mj90Pm5VZYs22pQinNsjurLA1HYT4oIYnY6c7RWRNWmqH0SoxECvimEn3ev06mG8
         WeVmPpYqBLOag4SnGBTLng+E7Vmn2EnDTfDvLXC9TjWOAqQ10rHJNJn/dIEtCOEXmKSB
         EkJ2EnKMT93Jdnt0hY9h1ZF9kAwx1q+PFaHmAYc4ow3pqORbc/vd3UHyqNTQHQA2FL8I
         ilmdy3rKE5pjW56+6HOdXnZIflmW/btva5nT/u96MuIbDf7IckMyHg56q7nkMRtIvr7K
         VAOw==
X-Gm-Message-State: AOAM531mDI73hPmNyUFq3ooyDiCwX+2GYo1tLERqMTJCqgOxiN9vOG/C
        oHi1qti36BcwADTvAg8+Rcx3lr7pmu8dXQX8+m0=
X-Google-Smtp-Source: ABdhPJxT71J2Zq5JEU7xtqhuQgLhJHZr6ylalmDn9SoR75LV5hcc4qNsuxWYHyRRggdyH/HM37FP1Q==
X-Received: by 2002:a62:8184:0:b0:519:b75:acfc with SMTP id t126-20020a628184000000b005190b75acfcmr14727422pfd.37.1653745211059;
        Sat, 28 May 2022 06:40:11 -0700 (PDT)
Received: from 6441609f1b18 (194-193-162-175.tpgi.com.au. [194.193.162.175])
        by smtp.gmail.com with ESMTPSA id z1-20020aa79481000000b0051812f8faa3sm5381351pfk.184.2022.05.28.06.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 06:40:10 -0700 (PDT)
Date:   Sat, 28 May 2022 13:39:59 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/47] 5.18.1-rc1 review
Message-ID: <20220528133958.GA8@6441609f1b18>
References: <20220527084801.223648383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:49:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.1 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

5.18.1-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

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
