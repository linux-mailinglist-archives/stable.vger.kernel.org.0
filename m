Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26836407986
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 18:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhIKQWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhIKQWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 12:22:00 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06C4C061574
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 09:20:47 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id p2so7781111oif.1
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 09:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qWhmD424iTI+VKh1oKjSSQA8JxWsQIPJXiM//dl78vs=;
        b=YkYHIYyMrEOK1tn8kKwMsDoo9TEPcnMvUv2o/l2dJgete4PLlVCSzcAVqjWuv+wn27
         WO5HZnDM3NAg8u+XfQP3HHOvBVh8NutGFaPP8U4yaTtT8GK36s4I3LWQDfeI0THRw8GG
         b00rlNXxCt+sS6f8g57S56sqTGf3ZQZfs+MHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qWhmD424iTI+VKh1oKjSSQA8JxWsQIPJXiM//dl78vs=;
        b=i54xWY5o4R+O1xFycyR8R0+qBfqvzW8ONJtFVSLkp+F2EsdSFdNmx2a2qQW1Wrqiat
         JY64jtmUNnAqTKope2ml/d3GoqZ/K8g+TPcTweiToZfgCG6JWDqcDHicIW20ImhfNLjU
         yxceFG+/3Hz8Cjn/Rk82onkKmPhi8VvXQMN92mcSnlExMfGR9i6JzrpWDZkuKWBl6udY
         CeCUUbYEun7ymSMq/2NcDYci5GM0vVHAgCJq2BkIjT9+DGfxH2dULVIdGObgjJffwlNx
         4ZquBWuvqSg9MWKYKSIk8+tSgF4B02Chjn9UL45lbg7obuTgPiIFXHUJonXF2oeAmtld
         pmnw==
X-Gm-Message-State: AOAM5306wcQ733DURs6cNB266e0M3RMUxdgXLFyarOBtZrV1ZmzCfA+9
        6DGHLFGCAlPWg1oIMp2zAAIl4Q==
X-Google-Smtp-Source: ABdhPJwTX6mKitabG/JImHVGG0SgAeeDjwnDg931pv2VIexrM0W3JNKejxyBPs3/TxD1nPP7gUoFCw==
X-Received: by 2002:aca:2206:: with SMTP id b6mr2176401oic.88.1631377245887;
        Sat, 11 Sep 2021 09:20:45 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id v19sm490764oic.31.2021.09.11.09.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 09:20:45 -0700 (PDT)
Date:   Sat, 11 Sep 2021 11:20:43 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/22] 5.13.16-rc1 review
Message-ID: <YTzXW4k57AsWDI9r@fedora64.linuxtx.org>
References: <20210910122915.942645251@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 02:29:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.16 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
