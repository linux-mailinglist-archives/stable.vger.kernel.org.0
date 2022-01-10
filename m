Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9A48A3F2
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbiAJXuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242706AbiAJXuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:50:23 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2723C06173F;
        Mon, 10 Jan 2022 15:50:23 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u21so20744863oie.10;
        Mon, 10 Jan 2022 15:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TqWMHXyzYXBteWFgxyAsvUsVtH9NFFnAXmy/nbXpjX8=;
        b=kfTUat7pRfAF2myvx0wyp/q9LONyCS+kSS6EvWmuLP5M6V8sXI2lP4A/+jqZvSbzFI
         EiWZxn3BDog/1OzQ60f6gAL03W8kIc2NrwVPEXczAzh5N2n59otivOr1xGAW3Zo5U4Et
         H3Fnrczs3js/1SGDtScKalpw8oCuhkJV3WeLaHiWxtRAbsoYfgi2k8w7w9/c7jQbeV8X
         9mOCBmjM1XSSaNaiRWB1Rijj2DkR41UTonk9TvhqTpLRRx9NTU+p0dUnqZ0RGagKj2w/
         QHLppwRUxolI1wPAHX6b4Q/4ceCLZJAuLIQaEIwf9f8E8khW2y0H7LnxUwdTCtq+nke0
         2hgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TqWMHXyzYXBteWFgxyAsvUsVtH9NFFnAXmy/nbXpjX8=;
        b=tePVHv/PLyGlSd5jHb8wltoq3ApJ49ZQkVQAvuyeTC4mD3KsX6LvNuzVIe2TRaSbUe
         oSm6bEa6pCzufeaVZMFD9gQYpaXeL8utu7BK1iLguqqYh08ONhlVwf9zQZeSes6G3bnE
         2qM5n2iBBjEfBqa54VPhWHhDT3GUCKBkwjycaKYD6/bedVpLspJTcl/0Y//viCLdsqiB
         oBocDQltjskIftJRsuu5IGSdCpLkh5oONrJ01uuhO0TtXyoIPKtRROVWrWFzKy3OZBbp
         c/hqrMCLp3aOeFfhKBDKB1DjyzcQPcahft16KQIIUgLNVZbLTUWwrJB5laOFQNpnRk/M
         Ym/w==
X-Gm-Message-State: AOAM532CMRUSx/Q/EP4UxA4V9+v3v1EiuvcfDhvqqo5sI2+MLFVVDHPa
        3bpRnrDjEb3Yb9Jb66d6j76D9MK4UqU=
X-Google-Smtp-Source: ABdhPJyYMSOZlcJ0s6nGpJGeaFdqxrqwwMhpmaRRMkdckC7Ug3aYwkRAXkAzrBMga2rhSdfXFiJq0A==
X-Received: by 2002:a05:6808:1828:: with SMTP id bh40mr96861oib.105.1641858623152;
        Mon, 10 Jan 2022 15:50:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i9sm1195516oik.48.2022.01.10.15.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:50:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:50:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.91-rc1 review
Message-ID: <20220110235021.GF1633615@roeck-us.net>
References: <20220110071817.337619922@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:22:57AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
