Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4142F2EF69C
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbhAHRj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbhAHRjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:39:25 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A56C061380;
        Fri,  8 Jan 2021 09:38:45 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id d203so12233832oia.0;
        Fri, 08 Jan 2021 09:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eUUO9/Xew658appDZXj8rljvd30ky+f2xH3Qn4RJihU=;
        b=nPaEldwOMJfeB91HwjSZBS+5r19M08PERkTE6ubP3LqTKRKGrYCYVVJTU0+OlapxAZ
         O5QoAgzODhhaYoVfGx0RYV3mn/857wO8B1OWneANOXoBnok086G7RpKjcF/3XOlT+6Sn
         UEnZi6oA+TlI6vGr3lwTcAD8vlvIgCd9MLkZThiaAsUZ1f8oVJm3tyKaj4pgMohdAIQk
         3nVvA1ytAUDbd6EuNITp/Q6HqYtiSZsAEbjd89DkqfJo8EggpTxYV32AYQoTiaCpVe9J
         QyYyEzPln71SgVlU9UCGvgIaOgrWzRI0u13aLP4ENotM93xii9qTGI2kwbjOVsu/6ed7
         7WgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eUUO9/Xew658appDZXj8rljvd30ky+f2xH3Qn4RJihU=;
        b=kWHMuZHMDh+SsGxPz4C5rZc3Ftq925AsGc6ny4JOmnJBKHxam2oJhnwtt2LgyW6929
         PYU52xh7TMzpVS/u6ajqBk1YbOCkqkR9ufVv46WGtJEq4VUHBxDCFzRRFvZga7da/nxh
         ajCw5NhXXYxGklloqKXRS9Hc0WTlq8Q8BKgGtBemBiMtqnT5GWH4NKU7RSuJSVwX2UYl
         xAwgjLbYIlwklVR2sAahXv2V+Vce4/EzJDupiOxoLVy1cru7RVQpNv7Xv7g3ZYnDjsAW
         0QCwSoc0dKxdhnY5UxsU/6++15tYHOQfBZwUlhcKdV7RxZLS5NfDFj3700Bvsgt2V/ps
         lk8Q==
X-Gm-Message-State: AOAM5316JEk/hAfIxF4wzA+dLvRBRMdFU+JMeSomzBd+WGuu0vG5bx2c
        v4N1KhULe6oEIQPiIyYcm6ho6H89c2U=
X-Google-Smtp-Source: ABdhPJy2Vz61y0tU5rAfIylmBwfV7w9dcz6kfRfJm4D1F2bTF1P/6xoV5x5k3Hv0+oSG4gDwt7zv8g==
X-Received: by 2002:a05:6808:9b2:: with SMTP id e18mr3027618oig.100.1610127524821;
        Fri, 08 Jan 2021 09:38:44 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f14sm2063770oib.40.2021.01.08.09.38.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 09:38:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 09:38:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/29] 4.14.214-rc1 review
Message-ID: <20210108173842.GC4528@roeck-us.net>
References: <20210107143052.973437064@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:31:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.214 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
