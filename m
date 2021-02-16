Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D627A31D077
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 19:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhBPSvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 13:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhBPSvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 13:51:31 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517E6C06174A;
        Tue, 16 Feb 2021 10:50:51 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id l3so12310130oii.2;
        Tue, 16 Feb 2021 10:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A/XZjZa99+MmxcyMB6DnAcAwnvNRyMUBvKT+XkZpUyo=;
        b=I7pBU/HDVglUXm9S7S6ObjkhIi1uiNvflCILaNkIEYwEfz6CGr1PvXRA1uPWa0NpWZ
         AmKx32z5kiwLCeCHgTAVS2yR5bmhkgNc3wuzfIDSK8rr7JM2LH0FPJ3LVMOKqZmzI0re
         erEr8Tye3G3qE3+xWOAbd658k2QFWLY+Mmsf47mDPZdJhI+mtudKezY4jVefeXUS3cff
         HwFNFrvuUYzL3pSBFd3E/fYwO8GUe3fi5VqUQcThoSOaBOIFX6pUGfTr6IcIU3JhoEql
         A29AISqqlDWHf7UGJF72/7iG4hRUm+F1HSAD8WmoAtZeAFfZSLaz970Yrc6yQlWL4ZBX
         dbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=A/XZjZa99+MmxcyMB6DnAcAwnvNRyMUBvKT+XkZpUyo=;
        b=HWbIILUUd8QWU92qD4L+2rtDO9UXDs10WXt+yjyuaNnWYbGrTvnR3lrb8Bh59hokTw
         dc8dLt33Y+tioNjVPAK7WfN6MhzbuDx7aI/aCR2I07NcIo31M3l0VZNdx0s0wB9s6dQe
         R8ZzqAWabfGiY5/HujotWeydCnSRapmM4d3hbo+9exsnsDaeZKcazlpeOI2LT0bWRelG
         l3QSfpVgA/gWIy6GkI8PynSFcFhaYFkBq2dUkMmYqQ3NBMlSaYgG5AIAVo5QzsO1ThdV
         jwJ4zAooftxMJ8EAuVPzPJ67s5I2TVzLvVHthTiQ7JoFXVp2zMOktKnHTAp/cONUbBGB
         0nMw==
X-Gm-Message-State: AOAM5314MeIx0Z+Uz6Tuujcmo2XUDEikfGMt2HAcchEDNDcIFQiG0POT
        2nq1hy+p8YbjzxcKaGn3IZTZnNZUTQQ=
X-Google-Smtp-Source: ABdhPJw8eqz6fwUeZu7/Eq18v3BvnRcIZnVK9ka5pV/ncxAy6uZH+8klLef0BBoBGyEn9AaEzwMYIA==
X-Received: by 2002:a05:6808:193:: with SMTP id w19mr3486104oic.161.1613501450754;
        Tue, 16 Feb 2021 10:50:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w134sm4675441oia.56.2021.02.16.10.50.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Feb 2021 10:50:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Feb 2021 10:50:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/104] 5.10.17-rc1 review
Message-ID: <20210216185048.GA172578@roeck-us.net>
References: <20210215152719.459796636@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 04:26:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.17 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
