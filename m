Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1518A44639F
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 13:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhKEMvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 08:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhKEMvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 08:51:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2E0C061714;
        Fri,  5 Nov 2021 05:48:43 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso9480510wmc.1;
        Fri, 05 Nov 2021 05:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sPQgY4PoByGP8+/5h5wN31oSOJ+MLpUH407O9yKqdiQ=;
        b=P7dXTgBWDjBUGkx4opWCpyUc5aM51YmS9bS62NqVgyVJcNr2CWg+1qPeTZr+PwkHlM
         J3d8ymo6pzcbyvCwtgqLxqfudsaS8A4eWavfi/HYtdHfjCEDC/wnAmxNqzjrm0D8fK94
         aaYAvjsWOxI5uBZPzBqc3U1EC40/tefEolDSVjLbAUUtPgiEIDtS0OX8b41dHa/Ne63G
         hwGf9p0G49bHkY7kamKx6kzs9qDvAZVuFrkZbZXS8664k47Xhs2vkYUIknPGpE3mC/3M
         HmMxycW+xtYOOKsLZ+j4LB5A3FiCi6Dr8Wy1slf/eiYsFfJaUZRahqPfWFgKuj5ACz93
         FJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sPQgY4PoByGP8+/5h5wN31oSOJ+MLpUH407O9yKqdiQ=;
        b=1XOIQPfn+OkS3Kf+wqSGSrtXm1cg/VBM8WH8X5p0YU0nSIRA4hLoThwuVSrZKfczG1
         t+NZ3r2J37pg9+jMKm4OaLCNRN4Ctzt6YQNklJ+1t7+iz6uXW2HRTOJ4kxHBfaPYeqeQ
         BaYwhWB3lwFHeJIRAv80l13NwignHfWUQ+ii4ZJFUW2DcfGCcaH0omgVchySoOTW2XcZ
         swhAzHgKyYAr+QcR6E0dfSnpc2xmbDCR7yN5/CuphRh9XRrQT6sxnhPNSDlk531Rk/ie
         GLxQ8i3/gHwCKf3JDx/hH/pmpno+EnQAwatoBAP891V40ZaNcQ1v3NfW50wfRPLnMCcf
         mk1A==
X-Gm-Message-State: AOAM531wkSq8iX5Hhh1q+6gQBs80sRHFEoFDdnb+hh1W3FsJdUU0yKpb
        86crhYHLVSCXSObLVyu9edDcEh+npdc=
X-Google-Smtp-Source: ABdhPJwxrOTmaNFEeAsiN217jmeOI3vbuGaWV0LCWhwwvxjijRa8nTF2ssmbW7YM0GGfWHpTVO369Q==
X-Received: by 2002:a05:600c:1d06:: with SMTP id l6mr29168604wms.97.1636116521934;
        Fri, 05 Nov 2021 05:48:41 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id 10sm12752261wme.27.2021.11.05.05.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:48:41 -0700 (PDT)
Date:   Fri, 5 Nov 2021 12:48:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/9] 5.4.158-rc1 review
Message-ID: <YYUoJ7h4BgKilaiN@debian>
References: <20211104141158.384397574@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 04, 2021 at 03:12:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.158 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211104): 65 configs -> no new failure
arm (gcc version 11.2.1 20211104): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211104): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/343


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
