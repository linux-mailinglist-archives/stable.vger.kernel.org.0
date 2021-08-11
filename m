Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D79E3E8D68
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhHKJoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 05:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhHKJoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 05:44:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C56C061765;
        Wed, 11 Aug 2021 02:44:08 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso3941961wmg.4;
        Wed, 11 Aug 2021 02:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P8ubGvfndDsBV78YtFGtzfYo7URfxbPQJ6Fp4G7jjCA=;
        b=Vg0p/PCP5MYriIcHnDjzwlq/X/QDlR2Wi3ZP8uf29WqgNdF8k1Aa+iBiGaNNrqaJon
         LoQdQ1PXzLldvyXBWWLHWnp+Efk55vWAGcbMmWiBIRHT0vZcrsq4VYHdGwaInEtDdXUO
         qmRYYdUvwIin78wWe+sGyGaCWg4u2H3vO43WCj8DokYSGnJ49mG2ljWgeLtNLZPpDB+H
         gsuXj6fGUyYlJ2zQiIHonpnUqesxHycO/c97R/iTV4Z1qtG5bBeUkx5sXCTndbrN5gId
         35Xg4x1Op2v4xW1Q+r39Lp4Uk+d+oL2ZeO/dl4uiHd4fNj7YP/F5EDfTaezAfcHgHAoD
         rFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P8ubGvfndDsBV78YtFGtzfYo7URfxbPQJ6Fp4G7jjCA=;
        b=K5Emjtq13ETNMcCvbag6KhtEfiFuvTNLq4ZR1usJ95Nx90xCiyJbTQJ6d4r6MiA2Ui
         wr5gEIsRzjAbrPAYaveR24L31m9ncEXAqeDC/jhu7XH4qHY5txRG5vQ3HiRatd+CgTb4
         w58KlDkAdJ+hQIpkVLpNRC5NHiXsZrdZaFueRHl5vw5KfbyPft8jy9LfWdJE0vo/s2qz
         GSALcu4BnGo6q88QBgkFX6jFPwEGVEjFT/L9hWDqgcl/tOm5fASRc1M+waYYW1iYK9oU
         7AbTdLUtuJmDYnKLJ07cCHetthOKFbYw6/yd3x34dHfAUKUMFLKS+0nuSGCkSX2ktCKH
         RQZg==
X-Gm-Message-State: AOAM531/3Rt+t/A9UqFwpHddW6EtFsuzJB+whg8NEQOdrvjRAS2JuRI8
        hvAOXuOLdDKagJm7TWZ8ktw=
X-Google-Smtp-Source: ABdhPJyyL+XJVPD1y/G2ZaYywIWaBX9oP4NswK+a8EjN19F9UvHo5G1aMfQ6ABK0cb3jOWJ5hKwDGQ==
X-Received: by 2002:a1c:e919:: with SMTP id q25mr22316101wmc.28.1628675047278;
        Wed, 11 Aug 2021 02:44:07 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id x18sm25620629wrw.19.2021.08.11.02.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:44:06 -0700 (PDT)
Date:   Wed, 11 Aug 2021 10:44:05 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/85] 5.4.140-rc1 review
Message-ID: <YROb5ZQTYNfgtsVy@debian>
References: <20210810172948.192298392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Aug 10, 2021 at 07:29:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.140 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 65 configs -> no failure
arm (gcc version 11.1.1 20210723): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/22


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

