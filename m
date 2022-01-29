Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7E4A2AD6
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351961AbiA2BFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351944AbiA2BFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:05:21 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D873C061714;
        Fri, 28 Jan 2022 17:05:21 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id s127so15666933oig.2;
        Fri, 28 Jan 2022 17:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CJTkXsQJXHw9IuwdTW4BxRDFB/WpwRVPTEJmea24Aug=;
        b=IyljmdwT8JzuwrGbR2ObFNGsfZhLEMLTfEPy1SO6boaNm84mGsOfmlk5rl1OKdM88i
         YsL9/z0nuFuI9IHvXdnQ2v1BGrtd4JVXZmh9qVIkCnoWFlgrexjoTlUo71jL8T53Kpod
         RC8MNq/Y4G6l+quJ3Y9EAbNBaoUYPZOIaDfYD6v5VZjz21X9S46Ls+dOEfrRccoVyG72
         8J9PdJVv3/1wG5LypEwW3udfs2QU7Ak9xohOfDn0OLdLZ3XvdvtPBsCN2e37O+iDcgmL
         Kya69FJN5Nzi5vJGslVUcSYvf7a2s7ikWM8g2y8IMpL2hwsgE8R5pUTjAi0QqOg1z4H1
         YW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CJTkXsQJXHw9IuwdTW4BxRDFB/WpwRVPTEJmea24Aug=;
        b=LQImFoJqDGbk3O1wYBqM2YCovKYwSDpNtwQAmFlmOz52xoMr3MbPDBgV1avgNysf3V
         xjm/Qzcy+8iKvfXiae+voRM//bxJKJuvvkRACoQUuY8Yk2A3c4hNcetvXQ0vfbsftym7
         oY5rPduyaPLlP2y4sATOLjy9eNAlswyRLqKaCPIHBK9O5Fmhs7UFHkh3a2n6CntaaqeM
         N/6jrcbeFXfUDLpC0yB2HlBC06MDsO6JJntTJqre0k+JP5C0OZIn6mIN3hkkHAjIMDQ0
         c7MzqHhc9plmblpr1FM2W2kFhT0ODZY94xOMMp0mOVer3xbQDHVwqbSXSMzyFDND8gmi
         e+yA==
X-Gm-Message-State: AOAM530jAZzfbmKDaENxdhLjyqDifq3nvT+s/TrlSoMFMA+aciAtZ73/
        VoAgT6QWVd7NTnna7/KkrnU=
X-Google-Smtp-Source: ABdhPJwn12lqqMOy+Ch8KnARCSL0sbNdd/svDpzoyaVPBcY5NyGtCBS1A7tnxW37Qw60a6hW5h0fVA==
X-Received: by 2002:a05:6808:1690:: with SMTP id bb16mr7870078oib.88.1643418321046;
        Fri, 28 Jan 2022 17:05:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d21sm554657otq.68.2022.01.28.17.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:05:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:05:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 4.19 0/3] 4.19.227-rc1 review
Message-ID: <20220129010519.GC732042@roeck-us.net>
References: <20220127180256.837257619@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180256.837257619@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:09:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.227 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
