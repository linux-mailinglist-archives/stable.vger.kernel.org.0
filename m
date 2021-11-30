Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319A9463D03
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 18:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhK3Ros (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 12:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbhK3Ros (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 12:44:48 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1267C061574;
        Tue, 30 Nov 2021 09:41:28 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id bf8so42757945oib.6;
        Tue, 30 Nov 2021 09:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h7WLI1zuzj8sMT9F+BhGBIz3cLvQ+ELWe3alIeFoHY4=;
        b=ochaIvbl403fApD/RRKJcNZRpK7LI1wgSgGVIr5CCSQSxpmS1Eneu0wivD/u/8Znq8
         qj93wo89LTSW9yOJReER/iJD7DkRBrCbcDdZ6hufN77UwEtl/3RwDjjxUs9n65lz7utl
         LUn/ZwuhvNhO9teVrIQYsdSiYoQO/8V7Nl6WErPYm7FY+60XjijnGnH8t7QupJDMWLF6
         yiaAjQDCoRkmKXYA7D0pgseZPb7dYB2r62jmsTumE3aFbdqgsSQT4ZomgOmE5CmvYbaL
         2gd4f5FTg7VtsM8k+PUaHUicJbk6/fPPP8zmG1fbEV4aYRZ46ztMk5Z19Rt/3WMFq2sI
         AizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=h7WLI1zuzj8sMT9F+BhGBIz3cLvQ+ELWe3alIeFoHY4=;
        b=MSUeIf9oleUhP3e3Q1Q6knFhSo4AhyfvWDhhbQUwACVbFT7I0apjAqm6nouoMO9Yi6
         aF254dB/Q5RcCAK2d85pEngUpLVnWdWcYgeU90VDdkcD2cwAXy0vLLpM3nR1CuFlWXnv
         uMpaB0Sb6Clku6jNh+sh8SY+C8u824hMLaUZa3n7WOYfrYsJ8ommciKxOQzxboM0q5Dj
         VO7uagHXf7QyQTobuvk8WwTipF22YaqPDK29TZCoyugmn8aUNqFpK7Xr62ImEpY//pwo
         vXWd8r25/LFCgYcBcSogiGu/w2lX6HWV13SCSIJ1xKcOs6mwhjak72b34DJMakgU9hcK
         zS1Q==
X-Gm-Message-State: AOAM530/0+93t7uGANn5Gn1UajQboxjAZJ44cHuDigj+W4ag9iHIO49b
        6AKLRPCep6hWCHAlEtUGsTs=
X-Google-Smtp-Source: ABdhPJz4G8STjY2aHToAEiPKaSO7I+LAkq1PDHRpLYUku3DZGpAbWnf97orNBBn3XBXf42qbjIs9fQ==
X-Received: by 2002:a05:6808:ec9:: with SMTP id q9mr350590oiv.160.1638294088394;
        Tue, 30 Nov 2021 09:41:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3sm3216413otc.0.2021.11.30.09.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:41:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 30 Nov 2021 09:41:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
Message-ID: <20211130174126.GB3226251@roeck-us.net>
References: <20211129181711.642046348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:17:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
