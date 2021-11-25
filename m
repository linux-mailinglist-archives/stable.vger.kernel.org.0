Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7745D2E6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhKYCJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbhKYCHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:07:10 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7FC06175C;
        Wed, 24 Nov 2021 17:45:38 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso7077475otf.12;
        Wed, 24 Nov 2021 17:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tb+A9/uMadvMjU7dngUaH0IFZ8VSOIfHK/WPcTaWir8=;
        b=eqWq1I+1/le224ClB2Ej98r73kZJ6tQnRWFvG5ycaoVuzJ8OLMb30rf9Zoe90zm7NC
         JUawcDAzJDYKoI9mB0cXoYV+RvHA/B9M6sl+OXEfPB24pMAmGnIFAjtEvHXSGyRBo7IL
         6TaClhA6agoNtO9asVRG2/mT2/tJ1QPGTnO0TnvIAGlO068V9a+8kNCsqOKDM1168un4
         sj/qyhzk7iYWvBC4LRzS6s9C1gOhPZBxRDMkoxOlfBaIiKI26oFleDY2UNhyBR7LGCqZ
         cSSI2Hzdv0JdvD+pHWl0rU9xk9D2izqW4nHUitSIhVsBGl2TB/AqrS2iuCGYHqm4UyRa
         gS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Tb+A9/uMadvMjU7dngUaH0IFZ8VSOIfHK/WPcTaWir8=;
        b=rdPU/6IdZsQbAnpY7dTkGPrR1h+pGC12NvxhdvCYI0N+X4v3SMXLzZsqRWXXeuL9gI
         Mt382nHwmznHZd0jAqLv/5XI1Ri5V0Fkl8lp5qxKh7sfnP1gzDoVUIqlYhgvTtrqSMJe
         5w+qD2j1rN4ZFuRAPhKJw15hCps5fkFA50D3hxh5XQEmu9JoUlAT8ZVpcU5z2Qq2So97
         nAwWy1ynqsgiPqv4CBeqiH9v8MYSkNHI4mGsIQC+EazhExfNLa+itAb7duhZuWF7icGo
         XkEwi6GcAPFtlvQfNIKhIdq4po0ql38zRaYP4pr/4nO747efSw4804eHoEL51ZbUUAgb
         wEzQ==
X-Gm-Message-State: AOAM533IFjpTtg/76KnmjfyicIGJjhFJHHO7F0aqtz/FZ63vE17CX23S
        5NG4rkuujx/Kqki7UaF45tc=
X-Google-Smtp-Source: ABdhPJwryhz6FUtRgIkl9kJYenthKGLgti4LhPRR1SRwderHd3MrAMruze+r2HyGaKvEG267+kSj1A==
X-Received: by 2002:a05:6830:90f:: with SMTP id v15mr17399557ott.62.1637804738265;
        Wed, 24 Nov 2021 17:45:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l24sm273272oou.20.2021.11.24.17.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:45:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:45:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/279] 5.15.5-rc1 review
Message-ID: <20211125014536.GF851427@roeck-us.net>
References: <20211124115718.776172708@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:54:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.5 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
