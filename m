Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90B748ADAA
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiAKMfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 07:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238836AbiAKMf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 07:35:29 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950FC06173F;
        Tue, 11 Jan 2022 04:35:29 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id h10so22536985wrb.1;
        Tue, 11 Jan 2022 04:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=enAGouNRr4bikjAZlU4a9bVkpUXhqTGaaqOH4ivhDfQ=;
        b=bkE3KfkcimcJg73VBiVXDBduhaN7ZNLBHRlL3sFzmiyzwPVxFb+1MsFv4O1ni569Nc
         fvDkTp4+kVJK9De34qTVU6AxvePsH6woUXKPnFiXq29Dw/CHKVcQpHDozK+IwTpJQTZ5
         MnGV+AYN9E2KQiElRq4lyv4YNCA8FyizDT1niQhkgeLfGZ9/u57rFc2uhhPIwofsiTkm
         k9J7YmQ6/7eL0jpbek2ALo+olZqCMNKrWdhDST5Js89rIMOaK1DPJ2wbf91cVmF5c3Kp
         OEyAgwWzwgEjJO3/LXHHvqm8/Wz1r6eoZ13JiJE2LFln73yrQevYVU9C4wGRnQnbWFcs
         adgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=enAGouNRr4bikjAZlU4a9bVkpUXhqTGaaqOH4ivhDfQ=;
        b=nF3z683s7OCiqVOgUdwXSb67AYNur0mBb1ZcBZFa+IqJneiYy/UbHI0ko/K+z1u71T
         rMS4jaNeLGcBYc1t/roxzdxHSkCj0WLu0EGCCPixVU2pDQfYvdqjRtKlq8OQ/h4dpUvj
         gbVYUcWZtddJKjeWs6M7DwVjFJ7Dmk1x/MhQcLOmjnwMrv6zUwmXmLfcSUg764dm91gT
         gGmNWv10rwS/UAppHGMqbP4lruLikQroGsMqGM3IszXBYxRIOWXjQxkPXQeZeM2NQAVU
         2okJpwtXNAR5mCyDdzaeF3EWDWzP2eChgEXWpL++bjjj5YjVEsl/cYhTOlcRKbniD1k4
         dwsw==
X-Gm-Message-State: AOAM5331X4hNaUgln/uoeZLa/2kEgpSuiGK6KAFxle6RBFrbrRzNEJvz
        uaUR4E+Uw0ZIipiFuMmVP7k=
X-Google-Smtp-Source: ABdhPJzwJu4ksEj3n5hlphta5S6IY9c/AUrY1LB/TNcIQB7Z+z4I/uuXQSSYiwFRVltik5xF+rX/7g==
X-Received: by 2002:a5d:6d0a:: with SMTP id e10mr3643247wrq.327.1641904528081;
        Tue, 11 Jan 2022 04:35:28 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id m3sm9057851wrv.95.2022.01.11.04.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:35:27 -0800 (PST)
Date:   Tue, 11 Jan 2022 12:35:25 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.225-rc1 review
Message-ID: <Yd15jZKgUPWlFqB3@debian>
References: <20220110071813.967414697@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 10, 2022 at 08:23:01AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.225 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220106): 63 configs -> no failure
arm (gcc version 11.2.1 20220106): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220106): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220106): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/609


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

