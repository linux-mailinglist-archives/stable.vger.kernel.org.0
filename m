Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70415370756
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 15:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhEANOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 09:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhEANOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 09:14:20 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E984C06174A;
        Sat,  1 May 2021 06:13:29 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso1024312otn.3;
        Sat, 01 May 2021 06:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uv30u4QP7fn/WJseYHTC7TPttG6wM3uoqVpbvXg8y50=;
        b=G0yS0mDJpvV1iKxYwQN2vcBq/klzljnwWXCVXiNp+tu3zzH6zw8Qfa66vtvRqLYNO5
         xX9CSBFLuQjfAQxZJq6RGP4YHNvxkdtGNCG58KX3oh6wNFXTtvHN3pqq2piMAcH8NGex
         jGFPPR0A6MlUChUfW9delpcTlDRmvsjgL2IZs++PzkuruDcLzQlMh0JRqpgX1DcQ89x3
         RD526PeL+QBLVCf1uEXstpAEID28QenY4xwr+BDTD6ktVzv1UzLwrPqBY62HhqJjXn+q
         lvkILtWCqgaZJS8xpLGSOS7yrsmPBaqO+Gpu95ZAA8l5MNJdJ/+KqAr5DNMHtr/MADHp
         g2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Uv30u4QP7fn/WJseYHTC7TPttG6wM3uoqVpbvXg8y50=;
        b=PCX4E49d20r9IbKWgdQv1sEEU4CxN3P+rVzTcglPAxE0+3a/q534Fo48I+DUrAmoN2
         DT1g2+4tROxDhko3yTEd6v1nunyrc77WaSN5Z/nzKe+jhYxAMh3Xhf5z3llwc8eOsAx3
         i3YjUS09hmU5xCaFTUIVzbEtvCnqpzlrg3AVtCYf+cjF+pD4GxMwFOvqcjqZ7042Wbay
         wrey2TxDU6PSrlugYcs0asKHNmxkuSsEesz74bAdNg3lG5L8OFJZk1UNcMmV6sAXSM0p
         c7rTWwRFVvkeaAxI1ZPOjIDAA3s9FMEyu5NYmB79asz+86XtGHUs0LJgvH/H0OBdsMcw
         0aAg==
X-Gm-Message-State: AOAM531bynXIHFCStqGBgKbOVNIoX0AwkAbmapvl05NihKtlszLQg3ws
        lUcmtK6/nwWWgroKq1OMu7Q=
X-Google-Smtp-Source: ABdhPJy+0BQr+CzcldtpZWS3miPLjIei4k96UNgp+qkgk5S/8xFvsDJm6R08KYxMOrIgJIs9QwVqTQ==
X-Received: by 2002:a05:6830:2369:: with SMTP id r9mr7587300oth.75.1619874809000;
        Sat, 01 May 2021 06:13:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z2sm1501216oto.24.2021.05.01.06.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 06:13:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 1 May 2021 06:13:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/8] 5.4.116-rc1 review
Message-ID: <20210501131327.GA1774517@roeck-us.net>
References: <20210430141911.137473863@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 04:20:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.116 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
