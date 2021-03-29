Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC80B34D993
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhC2Vdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhC2VdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:33:09 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15BAC061574;
        Mon, 29 Mar 2021 14:33:08 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id s11-20020a056830124bb029021bb3524ebeso13720197otp.0;
        Mon, 29 Mar 2021 14:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d6vLv2LPFsGN/4KJJtNYseuN6c9+x12957QidNHn6WA=;
        b=FqWS7oqm9rg29FLP7YpmqL3k6QKiiei0de2pEYwer+RERLfYCVHnAPz2B+ToXk4zRe
         qR/QAMQfJuU8VaDwif8GxUTGLalg2CaWWI8rIIjQhVsA2P5BWKkEJttDtj6Dl8/omEv3
         wIUjdXMcYg2YEMZtCkGoyllolqDG0ks1I1zFCaBzPd/lRQL3FT2k2cRg4FItRoXrG33V
         qztbtdB1F5jt4m0d2pDm6fkMhWLGl/QFJ4VN81AoCy+xJlsWdFfST38/5dV9SULgwe9U
         O2/F9GyohGaM8l9/UNlRyl4UsvFUXpUB3oyPEczFUTLlUh+OhT4VbRMvXoiud7F+Mj/L
         0GGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=d6vLv2LPFsGN/4KJJtNYseuN6c9+x12957QidNHn6WA=;
        b=nlqs7PZMwmDJEdYmRFgV+TKdFG4ghQHYOHApaVIkcXsVpRdqMiF/J9UZ2jtxqa6v1x
         QEorqqM2z6M2xkvfWcDikkZocklTDU5M1O4YJzBnvE8VHVQNCH0+wkx/KZJDa9e36yfS
         cWhZnhKI518c6i7+sXmP00iy42wpewvQ9kfQAHTOcMgmBpL8VkpRJrE2oQfgmTM4ndAx
         jlCiDDFu2rAs8bwylgoD+vEKqTekwZaYogQp/BJv7tG/RwsqWvtsqOUmmvSNczN+wH4J
         +GJ2C4Whe/49LxMNJSNd9lPF89fwXK9azj2T8JLuSTlOx5lrghFoaU+gcuw45PkKdX5G
         MUaA==
X-Gm-Message-State: AOAM533A0tsSDYzHBK/Fy7PpALuQN78l2ZuVIgmnyGOOHpmNmAUlPGQ6
        /SBLUz6RbnVvPcAZ8RrPKlY=
X-Google-Smtp-Source: ABdhPJwcHqxS50tf15OM8Dtpeo8beuYeDhpQg91vpM2x6OD72Wt9muS8UHf8n+UKJ8Op3IujtDNA+A==
X-Received: by 2002:a9d:469:: with SMTP id 96mr24139005otc.302.1617053588381;
        Mon, 29 Mar 2021 14:33:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x135sm3699262oix.36.2021.03.29.14.33.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:33:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:33:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/59] 4.14.228-rc1 review
Message-ID: <20210329213306.GC220164@roeck-us.net>
References: <20210329075608.898173317@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:57:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.228 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
