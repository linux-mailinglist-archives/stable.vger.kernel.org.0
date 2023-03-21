Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226656C3E57
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 00:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCUXNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 19:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCUXNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 19:13:37 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4607CCC37;
        Tue, 21 Mar 2023 16:13:37 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id k17so7710080iob.1;
        Tue, 21 Mar 2023 16:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zcm9v+PGW/Q19peCi8fchQeimPfAq6vwMy79sQWh09I=;
        b=gutqzjN7URlUUK2yMHhP3MuP0Qd5lyScN3Vk/+i4xlNPPQbd59JuzufB7uYFpNZLzz
         5gL3x1P342AE2H1dGkz+G5P/qK7ynE5KH1XWzxFTAw2Bb86VNFXQc5nFpx1TeTg88x9F
         nEzp7LGyvnMX6zJDgz4oZdL3V+E/HhBAOpImh81q02M3hk89fPuNaIh+UI6Y9nBhqleV
         OrXJC+oiNvB2D0wXouDGXXp8/9RUufwPvIuA5qZ9Up2cMtnL+Q2N9zrbpsdLZr1w+2g1
         Ts107DjWxTxT0qgZ3x0aaKKUhDjjTTQIyzRGxXGX5fpDTAhuILzwZW/+nH2vF4tsyUE9
         8xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zcm9v+PGW/Q19peCi8fchQeimPfAq6vwMy79sQWh09I=;
        b=Bc6fKIxnOutxUMq0OjC5PgLmG7bGvbQEvv5kG0yNU8uCP5Vpc0vKvGk1l+tuPx+sgO
         lQv28D5TbffRFJXn9Q91Ba1DAbvwUd3Ccl0XT6pdTgnyNofnd2r61LgtmukHkIRqiJoE
         B4sLZSaOIbKEr0ShP1/gkdtOtdTSkN+KdUXlIoiRtzJXXihat7QDGwHgnIGBE1Y7Fx97
         3SXhQHB9BX5uFQ+iXiUO40UM9LUaQhVuxhLgB4vqNZQUzvRg5Q0jC+pJ+kuSaVnvz8NX
         TooxbT0R3te1N3VtbzRAuTfO7oDnNwBP0+RMrt8OqbYdM9dTyimoO+7+BLX1jF0uFBoA
         jwuQ==
X-Gm-Message-State: AO0yUKWN853x5yV5zUUmVeCqVfZ6C7baaxTb+M9fmNRtt26c5darl+bH
        DtmK+K/ELm+3LswxX2coO5g=
X-Google-Smtp-Source: AK7set/ylowbRbB8X4g3HZNlIgBfkTkRz70Wyh8zR0IuDT3LlQeV1sKBQH5PLkpuEVeMqYgVnspmSw==
X-Received: by 2002:a6b:7a01:0:b0:74c:8b56:42bb with SMTP id h1-20020a6b7a01000000b0074c8b5642bbmr190425iom.8.1679440416619;
        Tue, 21 Mar 2023 16:13:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m24-20020a6bea18000000b0074e3d8e8e13sm4081145ioc.45.2023.03.21.16.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:13:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Mar 2023 16:13:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/57] 5.4.238-rc2 review
Message-ID: <1d86c213-9948-4fac-b783-d5faa547276b@roeck-us.net>
References: <20230321080647.018123628@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 09:39:06AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
