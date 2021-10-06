Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2035424898
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 23:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbhJFVPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 17:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239533AbhJFVPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 17:15:43 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6E8C061753
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 14:13:51 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso1258386ooq.8
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 14:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aTiLHQvN2/RB825CLKLyg0WrQPgmCRAg70VnJF4FMIU=;
        b=fn20euU7mPei/hbt5L1WCCoWECAFFWSfshU4dUA1uZBnlG7mZPn300AVWL65Z95fOL
         pUYvNN/Dft/fHTwJVC/+J08NPI/u1K1W1wIaP5IbAfs/UW3vyheEK6gH4hw0JGZWWaqo
         4neCcRyvUBRKwkQwnuI5sRxbt7aRvCE1r8lYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aTiLHQvN2/RB825CLKLyg0WrQPgmCRAg70VnJF4FMIU=;
        b=NQX6xjC8tUM5ZmyYsWa5YvLE8LG+qe0m/a6CzVeJ4IAyMRtGYvtehqKx3TXesK5fGa
         w/tyjvqxp8h5bZcUWp33RJJPXccUkx2MJZLpjAYVMAEYUaGYBu94Ug4vCHn77p+jNXm5
         2bKVTcHk8HHUXNwqxXwAGH34rTiDqdHlOVrpMr1lAwDzaVTk8UmSe4soRrmqNKEswhE8
         UsYmJqYrvzSPnQwoBW+uvLKcKda+6OIC00lSdIk360WUy5k2skRxH8geCPVaXGuB53hf
         x6WDxTmpVtLIL/PCJXnno0NUDFaGNN8/W6O1fFCgYy6IAqHzckgUrRiiUXa+mTBEDorE
         JW2A==
X-Gm-Message-State: AOAM532h4GEvqdyU3xjtNUum74yR6ZPHFpFcFnTwonaBeqbqM5Bjl+f6
        vy6LujWGDMlNEDf5zgQKSTnsWA==
X-Google-Smtp-Source: ABdhPJyp+2MuF24Dkonz2SJbog0oRgLhzkfHKwgC9he1Q9Y46/tmMWv7z966Mf7FHiAZp+LzGTYPoA==
X-Received: by 2002:a4a:9510:: with SMTP id m16mr501367ooi.14.1633554829373;
        Wed, 06 Oct 2021 14:13:49 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id bn38sm1648951oib.21.2021.10.06.14.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 14:13:49 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:13:47 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc3 review
Message-ID: <YV4Ri6k4S9VlaS04@fedora64.linuxtx.org>
References: <20211006073100.650368172@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006073100.650368172@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 10:19:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc3 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
