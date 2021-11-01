Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EA2442419
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhKAXhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:37:37 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0116AC061767;
        Mon,  1 Nov 2021 16:35:04 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id s23-20020a056830125700b00553e2ca2dccso22681456otp.3;
        Mon, 01 Nov 2021 16:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nuuOsGBgb7bR9inMKm9Gx1YLkfJrm0F/VqyRlTV4UHg=;
        b=WXUAftZJ93u3JpEldDcq2vy5rQ9I4ocC1cWOnZoiTECIv9JKG2iZ3gh9k01tLWDDJn
         qbKD9cb5IMkjm2MP7iR9kSHD2jWwbLMUxy9GvPF2z7w4ZjaYP/gEHGIRWTbk5yj0prx0
         mf7KnpkHbFE9mWusym4hjqBLPZyzAZYZh5GRttJ3+H4/oQKdWwY8/qO7+sCBBZrNtP0b
         /C5DFac7dnurdpqZv938uZ5G0kHb7hRupsjjJ9KlGq162jByUPGAHNV52OTOZs0tPwjA
         t4b6Q/ndP9OX0hvM2gpruw5g7J5w73eDvuNbcNtxtYdY5rpasMx1qf1tdCp8z8Cr2OW/
         6NHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nuuOsGBgb7bR9inMKm9Gx1YLkfJrm0F/VqyRlTV4UHg=;
        b=SeVEYclSKtkPASa9/ruNvT0pzrzxSRHhqlIH6GGk/FUVHKsPCRZrXaznVzw1G/5yMC
         Z4ks7ljyeIY6Py48qhNdqYgd5y9kzS2yv9xjlEr4DgwLbfSCV0DZTwSDAQqR6qQe8GEe
         uH5ykjOS3FNHnjWHs0oym62zlsrMJlyaCG6N4NF0MxnI9DnxM3HKkqQEre1aAbKB5r8u
         wtAnOZnsnnT0KPt5J1H+iGeA9AFGbYq/RXJleLvCv8U3zdc+ZRwWlPsv6OlzihZZD5Nv
         1AY4A+0SFW6hhS2qJbsHRXylrTsyTWw0RDbC5zQtHoPSHbbZxyDe0yPbakuITxYvq/W1
         fR4w==
X-Gm-Message-State: AOAM533yJ6zahP0hKn6JWhKJHyt/cvTErM7uH04BF27FMkfC+Ahsd3or
        aI7uYUt8qtph/JaplWoQjaIbBRALH64=
X-Google-Smtp-Source: ABdhPJzOzIdYCWOKEgzp3Q3am8JHHrx71bmZ2w5aMV3OeX/n1o80D/1RllScyjlOBCDmICJ+a/sR3g==
X-Received: by 2002:a05:6830:409a:: with SMTP id x26mr15216595ott.362.1635809703373;
        Mon, 01 Nov 2021 16:35:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r131sm4589027oib.27.2021.11.01.16.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:35:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:35:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/17] 4.4.291-rc1 review
Message-ID: <20211101233500.GA415203@roeck-us.net>
References: <20211101082440.664392327@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 10:17:03AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.291 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 341 pass: 341 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
