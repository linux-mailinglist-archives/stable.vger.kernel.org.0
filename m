Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C898848F757
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 15:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiAOOsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 09:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiAOOsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 09:48:03 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D7EC061574;
        Sat, 15 Jan 2022 06:48:03 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p18so11429854wmg.4;
        Sat, 15 Jan 2022 06:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GC51F22P9hmDRGNgZ9UO38S7UXU4rgWrovN9MJFLkEU=;
        b=pboxVeQ8Zfmv3VTJzskHkHqXetRECuLUtjcPJ7D+fN0OohUP+Uef0vjCHv4JWt5OKK
         s1jcAHou9+tMWt/rsOtNmmxTTAZqw6XtWZT+TJhYrHU1ShyKXuk2LKavW63dCEXY6uJN
         jQcCuEvzl3qJXSf3JtucXGA14twxywdJci7UQgVCsptnRrmkd5aPfWM0BoZZHQGSrnPL
         IqyxzDd9rHIB8Ahwahjv+xpAZnppxJVBYRxtKgnqPid6Gm+bFGj1YBl/r3i0MAKsgXDm
         6oE7c3O7v8CEfWZ/pVaVng+jFVr8yJHjeAA0mZEVZmld7NyHcbckH0HCDl+UWbQdnCGY
         estw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GC51F22P9hmDRGNgZ9UO38S7UXU4rgWrovN9MJFLkEU=;
        b=Q914/02BQ3/gDMSBNWRtiTuAaLaLO8WMQv9HpuARCvfQ286WiYxZ1UEBqY/Wj5KHPi
         vFGGobIhnWEfCO0XUWGRuV5kzW+ezlMM9jN8LBnvqOS4GjjMY2O0rN6aKw1Iu/PeBkIL
         3zqjyALTKrM5ofViyOpHuMP/Cjjdpz4a9vhwQ8XVDyQ/AbmgXCilrmoZM0rzczY55gVQ
         LCeaRAuxNM2gOAodPrdOOgxZkN1/bz2h/ByO3A+lY3ZCHAkOcCIIwsCTdzdWRUG6tgCq
         Y2fMcuhxtNLtFkg12HHgg/onQDjHOuGkz6s+CStuyGCWwrnuLqjnjsuAp9BwLg0LtsvF
         4Ymw==
X-Gm-Message-State: AOAM533+uIyJPwv5ijxHwM8XzWpzqSjKo6NL586IC17oCMR3eipEr0oa
        +x6LBOGCdm2vgMjeTxCWu04=
X-Google-Smtp-Source: ABdhPJyOpKKWHLm2fY3wpHhQBRslIeg+GYRRESPqQ7yOF5iutGDwKHfOs2iU6nimDiLgN7VbmbzOYQ==
X-Received: by 2002:a05:6000:1842:: with SMTP id c2mr12607186wri.482.1642258081570;
        Sat, 15 Jan 2022 06:48:01 -0800 (PST)
Received: from r2-d2.localdomain (dynamic-077-002-020-096.77.2.pool.telefonica.de. [77.2.20.96])
        by smtp.gmail.com with ESMTPSA id 14sm10058940wry.23.2022.01.15.06.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 06:48:00 -0800 (PST)
Date:   Sat, 15 Jan 2022 15:47:08 +0100
From:   Andrei Rabusov <arabusov@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
Message-ID: <YeLebG4dKq6X5P4A@r2-d2.localdomain>
References: <20220114081545.158363487@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 09:16:00AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.

Builds and runs on ThinkPad X220 (nitro mod).

Tested-by: Andrei Rabusov
