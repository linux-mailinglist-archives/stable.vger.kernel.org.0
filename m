Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5348A6295E8
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 11:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiKOKc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 05:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKOKc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 05:32:57 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3640D24F16
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 02:32:56 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o13so12883580pgu.7
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 02:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n6bwOxePFh46NaBMZODMDlWticrcCSmbJ4eG9oo6U4I=;
        b=aJLqEIUnLoEcqEpLJVeyLDSI4JWya9I6xfkg+ypjcC6c5uFWQRGrJXG/h8qnz/fzn5
         Jzs2FgEgorPHrC3aZgS5jQ78pKZ1cCLRrDS5D0SUUN26zOBpLJTMEGUPECoFgywkAJAU
         /pMcFh4gMmi34RnkLgcBsknOLsLXoU+L3BqTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6bwOxePFh46NaBMZODMDlWticrcCSmbJ4eG9oo6U4I=;
        b=7xHumWjK2zK1vQ+vtYOezMzs3a+GjE06viTtER0qAeXb8T99nmWVOt7dQL4pcOvWjn
         Mf9J2xkBzG/SKjMOpYuXx03Xh6OPdZqiAgSc9/zHe2T88iLyuh/DOQvlj/D6L55uj5Jf
         gZkyPKWBr/I2+9z74h8uPCGl2PDzrzzYihHqgmwMlW8ATIRN+V+oIVc/94V/LGDfjvVD
         fXLWRRTbbXaA65uLQX609EHNIC17aUNnbwRz2lxsN5LPyQiWS332iteGKJ4Uw68Qj8TU
         FwnrYgynkOILuV6n71uEpg1Ca64Y+NqkFqs5OxQRXFtjPkMrbe7541ZxW/PshCoKzomY
         q2nA==
X-Gm-Message-State: ANoB5pn6eBrRxopQFaNgXtszWshnpzUOpyYinvwIh5Z+7effjXK8/PNG
        wdjoDI9EGmtjSYu19XiKHtetHA==
X-Google-Smtp-Source: AA0mqf6c7cKl4JNJ3YsXWMTQrXcVKdJmUcemuX343NMnE30n7czJ0JHIaY+k8DYxqkh+sEjUJkf/4Q==
X-Received: by 2002:a05:6a00:e14:b0:56c:db44:7b1f with SMTP id bq20-20020a056a000e1400b0056cdb447b1fmr17938099pfb.54.1668508375545;
        Tue, 15 Nov 2022 02:32:55 -0800 (PST)
Received: from d5d3ab63aed3 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b0016cf3f124e1sm9429839plg.234.2022.11.15.02.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:32:54 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:32:47 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <20221115103247.GA258@d5d3ab63aed3>
References: <20221114124458.806324402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.9-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
