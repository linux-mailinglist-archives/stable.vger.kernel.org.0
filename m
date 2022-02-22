Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7604BF76F
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 12:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiBVLqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 06:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBVLqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 06:46:22 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A32913D901
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 03:45:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f8so16796788pgc.8
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 03:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xom4nC8pW1AcFzySdJHXdQiMs2JCuJfm0CowvEiJlNg=;
        b=UGQ2VRGOn90iAqIS+431vunzUtIrFIaXxEs3pFCQGXMRj1v+/RrxMV1gwODvaoUwBE
         Kn3DgZ3hQv3/PdmWUwm5/o6V+7priyaG5vmcSo1DFcr853Inc7OqICzv+UQdWkUVh/Kz
         5rci6+LQb6Zfi4jKPxYbpyk7RQDURlxD7cN6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xom4nC8pW1AcFzySdJHXdQiMs2JCuJfm0CowvEiJlNg=;
        b=1Mg17WWQvh8yeDBOS95U3AaeAYj0qHzT0bsaVAhHTehXiJZXeZglTyIlDwdRl/UWUO
         CwAFI7s+0ACJPNbWx9DXdiNH+PF5/NQZF0zqy0ds9mvWyWLFb4XxnyuFi6SA/JlqRyx/
         KL/WAKdDWVhyzXXZnsospoXxfQe7dXx2LCYhdhWsCt21StDGnM11ukayGvSmlF8cnwEU
         Y23A8LrguhJFu2z50AG7ZK+4NQWd59rhn1JKoyb+6OYwhqZDJQQWYtnskEgpFJ+XJKs9
         HNG6H1loVO2tRxgf3Jj9bOT3is474Mg9AgIyRMIDw2xpTXrbOZnwJ+1kb2Q+wrzAo+0B
         1Ltw==
X-Gm-Message-State: AOAM530X5bmWvluBa1AwKEIF/s2AirBbGh5xmadUOQ7ln6k6rkClP7rd
        N7z2GiV2XqYv2NR+VZewazgHag==
X-Google-Smtp-Source: ABdhPJxEmqwscdjRuK80gk8z2oss5gUS/AigcjXn78Wi+8h4nCrhNArljQFu3ZlP+ckFHrPsdMyt4w==
X-Received: by 2002:a63:2142:0:b0:35d:a95f:d1e9 with SMTP id s2-20020a632142000000b0035da95fd1e9mr19283903pgm.237.1645530354956;
        Tue, 22 Feb 2022 03:45:54 -0800 (PST)
Received: from 7956e3143303 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id t3sm17534132pfg.28.2022.02.22.03.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 03:45:54 -0800 (PST)
Date:   Tue, 22 Feb 2022 11:45:45 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Message-ID: <20220222114545.GA690805@7956e3143303>
References: <20220221084934.836145070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:46:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.11-rc1 tested.

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
