Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3641311E90
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhBFQCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 11:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBFQCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 11:02:43 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE0CC06174A;
        Sat,  6 Feb 2021 08:02:03 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id e17so889920oow.4;
        Sat, 06 Feb 2021 08:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8tVxgPxpv1U7JF0RP/2FpL8C+e1Q2Z+ZD9LCC7gbrh8=;
        b=ljOKatxC2rMZ+motq9ZmIyxbXgGl48k+ogrsUjNBnhojM39f4fNxSa+ABGCrkiPoWj
         iCEz6v001uVFrjqRqhAeB+l5EzpxdBiS5TNs9oke7rLvZ20OL3d67kzRux3LjsB+mKII
         gPSPS0q4xr279qbpjNyR6qxgz8n52EGX3WeLAsbOVz8tZuhcd0DSLSi+VJIb+yULfZEp
         1HJNjRPh01tAwkY4GzLUerhTQ7A5OXSJcCM9mpdI3SFjvIP3lVuKV6u1jW9aqCn9OR5h
         Z9Um3q4dgu9xs9bWLVYjJQDGsgbJe69sE/4Z0p1lQjzEnELMo1Uk7eowK2Pwv6DTB4ex
         fXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8tVxgPxpv1U7JF0RP/2FpL8C+e1Q2Z+ZD9LCC7gbrh8=;
        b=tH3UGKCtcUxvpQ53vjBDvwrr1253r7MXreR7ppecIQMD2Yr8yfVGi2XgxgRTuq9aMX
         wnSQ+ZCP64MuhM0HbZzrGKE4kiE35up3bg8NDjILs862CBIChFnV/Qwjw0bRuz8uwTdb
         zIZcw5JnGQFL1LmJq1rbM6Zt4sGa5u0B06ChKKIyQ+wPJRGAd9SL+dhPuu/yu5DoSLZt
         fWxN9JYSQKf8qUg8NIynk9RRxKu5Oxl1YYg9LFTmBF53Urw4Etp4HzdhqhI4t7ubi6lZ
         wTQAaobKpJCQ8P50jCZTEADD2dCd4lTlfx85a8JNBhxhSqsyxB+ubf3zNhqVqsnnbeT3
         Fc2Q==
X-Gm-Message-State: AOAM5338kihuIB5fxZ0vX2qUQ7sKkPXilGVjv2GXotZZxqOkH4K3Me84
        DDdApb0WwT6/X5w1pRtpzw6db5HqPMQ=
X-Google-Smtp-Source: ABdhPJyIV2shxDGselTXvhIUtMm6sWfxFDLy4wHXdCbAx+YZcUlidt/WUKWBcd96+6XGQB/QGQ/5zw==
X-Received: by 2002:a4a:4c17:: with SMTP id a23mr175233oob.16.1612627322820;
        Sat, 06 Feb 2021 08:02:02 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v124sm2530432ooa.22.2021.02.06.08.02.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 08:02:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Feb 2021 08:02:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/32] 5.4.96-rc1 review
Message-ID: <20210206160200.GC175716@roeck-us.net>
References: <20210205140652.348864025@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:07:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.96 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
