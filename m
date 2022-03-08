Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C7C4D1830
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 13:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241830AbiCHMsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 07:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346840AbiCHMrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 07:47:55 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34423B00B
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 04:46:57 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z3so8485557plg.8
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 04:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S1Umo8zXhSgTOe4/ro/m9bXgxRDjegKGMAKDhMLsGgY=;
        b=GPgivAezPMdzYeMLPW4SFdZ61i6bDYJXYc6t81vtiWOPgvVTndFV2iSKE90bHotzeE
         h1Q2FNl5rdKZrg3bmJvPPDEE0jXxIUteF29xi9I2vfNcJXqpVQ6BC6C6qntZ4jpxuObb
         ZY4H64XJ+nzIbEhNY308Y/BJF9k3KehnC96E8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1Umo8zXhSgTOe4/ro/m9bXgxRDjegKGMAKDhMLsGgY=;
        b=CvEYGZXDcpw2HOq7Cu3wQLoJxF06Rb4KuRPWOZLX5bXGM9QEpPxOyhJIIi7Ll+fsiT
         yq/+/FtqX1Yf0FJ9uUNzoWRv0z6WptS7WUPNnJzChF+JCjR58eBhWlNTuuj48y3p63/8
         3TsKWb6EgAegRBAfH9pAsbpIoONaBaljyYNaKmLLw1zn8JrECrGpdCYtzqjeU2oC5AUl
         A5NuknHnDYGWpaBc3Ve2b9kQFSX30rvBJzLmbSmGLzyS14p/+2kgps7DWdiblAelwl7E
         VdCT0w0grGQiwI9BEEgTGJ8nOHJdLW7ZiN0OxQqiD90xkPwQJudP+etklNKWnsTF1lWG
         NNSQ==
X-Gm-Message-State: AOAM531vJhQQ46wwfXiD+nD++HxMWZrsI1AlDhmsqDZagLQxDQLlwo3N
        p49CmpaDSs85gWJxXYem4lyzCQ==
X-Google-Smtp-Source: ABdhPJzE2M1LXgLCOTO8cy8WoZxEECIl25eUSFi8q5Jr/bKkYJf/S2scl2oOnADz7p5McWi3282TWw==
X-Received: by 2002:a17:902:ce83:b0:151:9700:cc2c with SMTP id f3-20020a170902ce8300b001519700cc2cmr17211763plg.72.1646743617214;
        Tue, 08 Mar 2022 04:46:57 -0800 (PST)
Received: from 67804d8858c8 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a000cc500b004f6ff0f51f4sm7720561pfv.5.2022.03.08.04.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:46:56 -0800 (PST)
Date:   Tue, 8 Mar 2022 12:46:46 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
Message-ID: <20220308124646.GA7@67804d8858c8>
References: <20220307162147.440035361@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 05:28:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.13-rc2 tested.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested on:
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
