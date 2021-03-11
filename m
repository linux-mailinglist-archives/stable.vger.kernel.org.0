Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0312F336AFC
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 05:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhCKEKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 23:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhCKEJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 23:09:58 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D039C061574;
        Wed, 10 Mar 2021 20:09:58 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id 81so20440868iou.11;
        Wed, 10 Mar 2021 20:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iYzmJMnFIsemW6ucnp9c5dsNvmxj52t2F/yWsoAB8hA=;
        b=meTchEb0pDU9HKZFPNL9tr5OuW0ZARTcEcofAYSY+lAwU7N1XK9PmszA7en7EanGZw
         +5MEdDJ3GbSUrJn3QOSZCVQBMNWmPyllzFUIHG6Aqm2nuNl1aOVTjLZrIsigFBOnJjlj
         tSPxRkia268/E5IAGU/P5Nly6ywBhaBpcti/T3z9r7J77tRxVIWEjumaViPkOG1TyXaf
         lP8rUt90lq+dIjS2PJoqT2QFIhtInzKMRRQx/hJZYqahcEnwV0KoRt+HwDul96875KTq
         BrIBC5WDW1DJb70Rv2kUBsX37en+pZAo9CEh0KoaJuyLgfZtlKMrAs3Qk6cMj3ymLw2N
         ZB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iYzmJMnFIsemW6ucnp9c5dsNvmxj52t2F/yWsoAB8hA=;
        b=LC+oDTCH/wFQLxvEJ8ZVLCusNdfecMHbHBg4tyMvSOlZf37yW8oF3hLzc4+rf6BQhp
         HXe0fAmgLFOKUqR1BO6OXf3z3AB8fQ6STaH5Uo+zdT2t7KoOkAxqO/PoJ24eiLcWfAbv
         iBx/1X85gKjLiokIQgXFrXDfT21PNT3eUiAOyi+V+9JTn8ppAMrdzdJM3BjO6BpXb6v3
         t/xW4FW0LvZg/ZID3S+LWYrVU3vK2EsbrzgM1i6JraTvJpkdhFzUsQMO+5wITFT720xn
         OLdJwOBwCUHxKgBToQNhC7N7kVDnmmtkIvXYeWTKHciipF02qkVqqha6oPSjnrhTBeYv
         dHOQ==
X-Gm-Message-State: AOAM531DN57Z7OjZzgJrUOF3B2sJsD486O1zm8a5/cfeRXVNq145QiBD
        g2eFWUL8sCgPAapyeWVilQU=
X-Google-Smtp-Source: ABdhPJwrQzo1Jc4d+D4CaLUuHN8WugaRL0GozwHQDcyggUokefSvymCP80x0W+1VIRHoPdUHVFqOEg==
X-Received: by 2002:a5e:dc01:: with SMTP id b1mr2739762iok.64.1615435797843;
        Wed, 10 Mar 2021 20:09:57 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id 23sm839615iog.45.2021.03.10.20.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:09:57 -0800 (PST)
Date:   Wed, 10 Mar 2021 22:09:55 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <20210311040955.GD7061@book>
References: <20210310132320.510840709@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:23:13PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.6 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
