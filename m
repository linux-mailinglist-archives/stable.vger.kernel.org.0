Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94320453F43
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 05:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhKQEPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhKQEPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:15:34 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C48C061570;
        Tue, 16 Nov 2021 20:12:36 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so563985ooj.5;
        Tue, 16 Nov 2021 20:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L4v+7URYmoOl4avq9dKyGRHzp/PeNWjGhw8RGsDFlHs=;
        b=oYJr0VXL994ZpPKBj46UbZyuf9GdOtxfnxM9xVYZdjPZh0wgP5hGln+Sz4H3VqZsdS
         So2d1Y1N3X8pStjh8Np/NN0sSOBtDADQmpFkeufM2rcLNbzbKxlBFn+JOHC3eiuwBFdn
         BGg7RcwN0yOdFp5AKtOlJ6N1KdvANO8vDZWh6JHZhhEwd9HdE7z8LhIWgc1/cITYO13X
         30qU9DkIRY+KbnEOOy/V98x6KzRqAqGhuE14c0zs6lN0COxoLS1wlGihcDBWJMkup9mI
         XvL+cgjUeOV/Umbri2XWEJO4pPrMvv8v2psEEOwFlMTCDjfPJE9vU5mP9e/cHhcCPd06
         rXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=L4v+7URYmoOl4avq9dKyGRHzp/PeNWjGhw8RGsDFlHs=;
        b=0ed5xwTYrfkDQoQORnSAwJ6NK/TUFlvxx5J7sPpWxCNpLwsa/YTnZj63N4p6kzch8i
         Oc98aFz+UBOEac7LyDRBR2vEBme7hJgJ2DWQCBKzLbudlIQxo8cU1tLir2X8Z6w52TTg
         M8Y7n8EpvGPRIVAslF5j6zoWNxf9icL1vaX43Go2IRzZ5JfZ43y+YR0/btJ84DHUYVFE
         L7Dh19GieODNZRAwFqAXVZWsRcwf1RtnOltz0wcYh5iSL+z/tqf4RgL5vjhZ3lxIQI7l
         lLoH3AeU8gLNYzkx2OTZTIrKIDqDWpjDtdW4X/bjO9mm5y6UOLPWOkregUMAd/9sxvQy
         P6KQ==
X-Gm-Message-State: AOAM5317N+CcNDz/I8POoxFiZhAfHv6pAZcKQDB01kTz6g6Ix+x2nhMC
        k+2wyBWXnSBU4VEDkMzU5Hw=
X-Google-Smtp-Source: ABdhPJzcmh90Jwmr//EzPx7bWaqQmuXxdlzIHXQTDXKCx5t58RhI72N/lhnh2fexvr2bYu9oVNxQMQ==
X-Received: by 2002:a4a:d9c8:: with SMTP id l8mr6780715oou.81.1637122355952;
        Tue, 16 Nov 2021 20:12:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 64sm3985788otm.37.2021.11.16.20.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 20:12:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Nov 2021 20:12:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
Message-ID: <20211117041233.GD212153@roeck-us.net>
References: <20211116142631.571909964@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 04:01:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	parisc:allmodconfig
Qemu test results:
	total: 482 pass: 438 fail: 44
Failed tests:
	<all arm64>
	<all arm64be>

The parisc build failure as well as the arm64 crashes are all due
to the backported crypto patches, as already reported.

Guenter
