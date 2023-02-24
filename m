Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99576A1FDC
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 17:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBXQne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 11:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjBXQnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 11:43:33 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C1728D1B;
        Fri, 24 Feb 2023 08:43:31 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id b5so2776744iow.0;
        Fri, 24 Feb 2023 08:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HY2UtiVyvy/vKybfSDlvC0TTjuRRDl4x5K9/kfOfLH4=;
        b=RVS29WlY5AX8PUbJxXE9JjyjaWIGBBA283l8jXEPdRnaEfcyBQepFOvjsxT27r7G+o
         +5coBIYlgsmLlwlWPu8y41KffhrRA6YyIdtAmmE9qp2LNgw8RL5gI+BlG8vWAsvz/c4m
         qhcw2KiBJEvzMxsv+1mKHUxADQaozy3ngXp31K4y9qSiW6uwrlWyl3WUSN6nuNF8qXDN
         MGJ4W/5VOXJlbiX9brLirW3FbdxKL2fjZTyC75M++biKjqmiOzVmRtxAMx3z6jeAN5hO
         p5ZNkxwsfJZfbF0wTuJhGFfgWkFxBlBSTVVhJBJix3BfTheC3SN7PPEMN4RGdfvtgN09
         8ghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HY2UtiVyvy/vKybfSDlvC0TTjuRRDl4x5K9/kfOfLH4=;
        b=SG97qEg5xUatfSqGKF9P96z5N/XUCL+DvKfgfWfIXjYhgCejm0ODS1k3+ZCkw19xti
         SS1NTmVbP51bu3lT6bMMRm386L6jyXVsKqgX2sXIt0+VS6eKjAQW1vSDIj24b9VZ8y0N
         BLcY2TdHzsSGSDvf3dhrViAs7nQ8IEAcgwjkf7QeNCiEcE7n6m463KSp5u/lNTBaqHq9
         yU0ptLumPJzVKWJkklAC8IbWqVtto8/O1jicXcKuq8FBLZ6LAKAg0xkSF8CIratB9rKV
         EoZqKoA+Mg5GPUzhodUsD1YtT/mk5Nx3iA/YmOpKNl1oHk6X9p/amXfkc60/djo81BJ6
         LgRw==
X-Gm-Message-State: AO0yUKXyWwdp6HCXzvGMJY5Pmnd1k7gTKulficH/M1XuLpLlkMfv8cNR
        eAorvPiPl26bEGxWlUy4QLQ=
X-Google-Smtp-Source: AK7set8RKsZYElYJA+05Y+fgThPxM20kuQhIHsExgSM/L/sVlZR3XgK5v7nltYzSY0iS+kCMFLnk/g==
X-Received: by 2002:a6b:f712:0:b0:704:b286:64c3 with SMTP id k18-20020a6bf712000000b00704b28664c3mr10222682iog.16.1677257011050;
        Fri, 24 Feb 2023 08:43:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o4-20020a6bcf04000000b0073a312aaae5sm3333108ioa.36.2023.02.24.08.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 08:43:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Feb 2023 08:43:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
Message-ID: <20230224164328.GA1223038@roeck-us.net>
References: <20230224102235.663354088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
