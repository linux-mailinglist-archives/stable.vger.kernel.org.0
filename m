Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E823D41F7
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 23:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhGWU1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 16:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWU1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 16:27:33 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801B1C061575;
        Fri, 23 Jul 2021 14:08:05 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id a5-20020a05683012c5b029036edcf8f9a6so3384578otq.3;
        Fri, 23 Jul 2021 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mpkMW40hvBdIGCVmztjVtapOhnNGKTPo3pLORm844Ts=;
        b=lKRNU72mL3FJPKttGLZz0piPYruDncZw39muBwud1RfGx1iN5zEpkYsFKVCI11E2NQ
         ZDE69AITVW6GyTg7p+8uaJlJxuubxoY3i5vFVAOucvOAIUGjGHiTT1hRobzP6nWcCdSE
         jCn+cR3Zl70c9lIb3jZCM6EDktw6jMrfS0I7mLtubm21SiSbA6mF0zQwGbJMkDfmPbtQ
         ussAsOERXYwzzmk5tGFnGKwyQ+i9pAk0NhP1RlrCixPbLSmQtGDmef5SKkVrEZbHbMr1
         1K3nNeExz/uf9Au7ht7QECF1pXokRsTfwqdS+hAZWAW2QUt+zVOHtn6kZvgNeLkg9NZK
         bA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mpkMW40hvBdIGCVmztjVtapOhnNGKTPo3pLORm844Ts=;
        b=dd0kdeEsSCmHgOwGFL4ST43zeY55mxdFXu3wggEpXgJjowbAuN3iZyCI62LT2swSU5
         Q+b7cweVcIc0jZg/zJ43mNXh93LyVi6IOYPj13caTTMT6nYxs1lTFFznsvF5Vi4q/5CH
         n6Ype8x0vw/HrWmCociQE1+Tol7rh4dMvLy/hhxaNjbeN6/Fs1L34piEqao/2uKuPqgr
         tr5b9Ref/9+1HGJgOp3hFReRqf8XWL1952crdo+VZxMc7Td0bzL9baZF+0Xt/odV+Ewp
         v88c1TeR29qzBXjo13dEJJtp1H3+ZgCIhHuycSUWgjYzq83mKA2X3D3p5w0+9GoOaVpe
         SmAg==
X-Gm-Message-State: AOAM531r8kOLASGVxdx9wSPkUnXid11jAEWqV9YH8nFXKqwzy9Q2M1Qt
        ILfCoE5pMndFgiD9KfFaBIE=
X-Google-Smtp-Source: ABdhPJygbrdVHPea6YiQi93NIjwcRZD007Hlp0d1F3Cj/o+xuVxCwcNVPd7YTyCUAdHKGUEDKzutsQ==
X-Received: by 2002:a9d:7353:: with SMTP id l19mr4530459otk.76.1627074484914;
        Fri, 23 Jul 2021 14:08:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y6sm6359718oiy.18.2021.07.23.14.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:08:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 23 Jul 2021 14:08:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/123] 5.10.53-rc2 review
Message-ID: <20210723210803.GB3652778@roeck-us.net>
References: <20210722184939.163840701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 08:50:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 18:49:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
