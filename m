Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900448A3F0
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243147AbiAJXuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242706AbiAJXuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:50:03 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF93DC06173F;
        Mon, 10 Jan 2022 15:50:02 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so16814558otu.10;
        Mon, 10 Jan 2022 15:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a1RKDcxVFi7AKjv0dSRp/Vk4fsscwCCZdf6NpxHzBeo=;
        b=eifnMTdO81SawDC2FHoBRG6uYOEwicAa1IR3mUjzB06K/XO9yt32qFqWIR7omeM9Bc
         3hCOMGI99yAUIIQXQpNHnUwdHwZ8USk+pfX+VwHMOIMFAw9hzUm15IBA2SeBvl+D812R
         UFOgYSySXmXCwRlvP5ScZ1Nf6dH5yEOK4RkA4nVLzdm5n9TDmicqZohj2bxRyPx7z3Zc
         Bydbv/3vxx4P9AQBeX6Y9KZBrer0hkUeS24pMXeqLGiDt9U9tsR0n5QVKgU1l+fRNQfy
         2gyET6od1F6RfuqTVj0bDAPjwqu3O1xUw4isMpIYxoxQRiWHL9WLg1AGscTjmXc7/NWZ
         4Tow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=a1RKDcxVFi7AKjv0dSRp/Vk4fsscwCCZdf6NpxHzBeo=;
        b=sEHrIdBz3lD91azLyCCL8csmkFqOlV3SmkVjVXSxhBQZhXTj8ZERRKD2rLwRf7ymwH
         D3VLy55sLVRPOY2pech3vEtlf4EvnF/4Bzz7e2IQ9rFRkyDAg1bCUgdwBRa0+HHURF8A
         1hYXSTuKy6nYyrPLjjh138nzmkSVydk68kG9ggWTrhZko1C7UW2xdiqDc7zHYzPS4h0R
         fjsm8APF5Fpg46Sb3SADfbFh3FLBR1eaaBjSsXDHyzADPPiO14s3hrKDtZkC/wmQYwZz
         ENCKnNPNykInJ1kR3YKqbywihS9iBzElCsjNU71tuU7ewqflklKnylwqFa61GURBUhBE
         5WNw==
X-Gm-Message-State: AOAM5317ibTs+bsiX+iIHCwP3OgqmyVOr8gYYXnSrBPSN3Ti84GY4A8p
        63TI3nYH0wzuj8BIeXXhMfc=
X-Google-Smtp-Source: ABdhPJzTv80deDCMKG421zOoGQmMqqwfXaJOVtrOEzOYhIDjfi1oCSN4+LvYPp65ieHhNiCzOMbwpg==
X-Received: by 2002:a9d:4b0b:: with SMTP id q11mr1677642otf.74.1641858602385;
        Mon, 10 Jan 2022 15:50:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y21sm1399808oix.56.2022.01.10.15.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:50:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:50:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/34] 5.4.171-rc1 review
Message-ID: <20220110235000.GE1633615@roeck-us.net>
References: <20220110071815.647309738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:22:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.171 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
