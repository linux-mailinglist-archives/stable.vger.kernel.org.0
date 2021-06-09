Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A173A1D19
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFISva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:51:30 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:33727 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFISv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:51:29 -0400
Received: by mail-oi1-f175.google.com with SMTP id t140so20876263oih.0;
        Wed, 09 Jun 2021 11:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jEIRvrt5KHpUE4uotbCaTj0ZIdwrvD7fZcLTAURbycM=;
        b=LKgbyu2/lcpelhkw4Kczf/mEJAnW7FEHPjGpdYpOKe17etsOdy02GVpuOCN9B6o07N
         b3vZilDcXrISH/viNGyo3QTAaRbx3VOEuO22dly+FY7zzBy/y45vWEpFo2paonfuMaqb
         sNEeK/7vNGBkn4qjEQdhc1eGIJIQfOBVgNZEM0K88rBjB8rp0y0Cm2wsaj1887UjxEXV
         R/Quicn4peNv7GGIp/9xYZY944O6WjmMXKSMzzcqZxUUlQvxthvBTova7HDhGCeTcoo1
         Y9Adhd3saUsSdkNSMK35f8H5H296Ar0xMFVevhO/ZNt4WYWyd31BAqmf/NQvMScsw8m/
         fDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jEIRvrt5KHpUE4uotbCaTj0ZIdwrvD7fZcLTAURbycM=;
        b=XIRIlzSiScTcGxloBqIQEAfsmeQTaoJWgIS1UJhd4lMI0pqJtk55E+WcnuoFWTuSzW
         Z2kxL2As7dEFNXs+Qjf2W/w+nBV8vn0kNG5HvtVdjQ6ac2ZmSt/LMx6hFCWg+5YXU1Xg
         Vq0JREgxwiVejvwW3rDu7TTVvt+b1bCvqBwT1Y7LuHGAPylbQPkG9wy1vSxY3CBxVs3K
         ZbHDQ2/YSzT+m2W6B++qysggTm3gNoUJj0r3E6fLE0G9G0P9W6JGVxIURn9/YVrkrUs3
         K56liM+CxH5ltZn9Nv41IZQ+f7zUUTGf3VQ4uvcXD+C76nOe94/QOVGWC0nkrftvkTne
         VsRQ==
X-Gm-Message-State: AOAM531z02c9ZgCFRb6vZoTe2TmbChKwbEON0gKL0Z/QJannBA/q1VoE
        IC48nsZrVr1HGpWpUKnP0uE=
X-Google-Smtp-Source: ABdhPJwuLigUhOwuTcFZJoWzmTaL0zddK7nLoQNMppRUUO6EGdSKyhwYrmmJrS+LHst8fSbMMy2jGg==
X-Received: by 2002:aca:cfc9:: with SMTP id f192mr691439oig.127.1623264498853;
        Wed, 09 Jun 2021 11:48:18 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q6sm100387oot.40.2021.06.09.11.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:48:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:48:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/47] 4.14.236-rc1 review
Message-ID: <20210609184817.GC2531680@roeck-us.net>
References: <20210608175930.477274100@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:26:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.236 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
