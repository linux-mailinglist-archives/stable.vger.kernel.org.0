Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41DC69E46E
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 17:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbjBUQVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 11:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbjBUQVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 11:21:45 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74281206B9;
        Tue, 21 Feb 2023 08:21:40 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id u6so1866129ilk.12;
        Tue, 21 Feb 2023 08:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nGfhTI+tFR4TsTGx5t43C5hwI9q8bNkRRPtQzmExCro=;
        b=lCd4S1J7YBv3me8sqi0gL1LRHFAtn+6jKH2Es6PCN9D/zE6rdl2v7ORyUUhJkD2myI
         2Afp7wwBzOI6P3OK/ztozGZBoN7In1UBeEWhpMkmMIHHiCqtpOWNbed017VHGlYPlRsm
         DSb51wZVYEmkReLuMQWjKpLavziyXS7fKLyGd2hs2xrHhFd3WF1SRAS/S+j+vg+sgvhq
         huhcLN0Q7qRMvfrMR2lIeJgbmDYTtSAYTh6HlZIAqpA+o/0Ii8pLxoP9//ShjcTRa5ta
         xlWJ7bODh3TEXM+GM/R6WE2Tequj7fmHj0epmqkBaZCp/QUnOW+gle6Jfa/+DhsLM0Wx
         nTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGfhTI+tFR4TsTGx5t43C5hwI9q8bNkRRPtQzmExCro=;
        b=HOAMD3WE2Uy40sQqFrsRFQpJTDZqf5usUNLvrntn+Ujqkcox22A7Xj0qHLo/QkrO3E
         fx6IM1Za3iksKSOKPjSkrOIV2eBTPM/tEz7BnpEg+Yp9NKmG9CzuM1Ww4M6rZtKID9EB
         04ejXppSFyL++eCy2qYbXM0xH27mfYVnHFInJ5jttiE4R6D9joZv2KZITaHqd+lTSt8r
         FIjHVKNy7ghiaoiVDuw3FSoD8YmRGwt7F5OrFy3ZCpJRYTSUeQEU8/1W4oX0rfoCIwD6
         bfx41h02zS/rpzR0Agzb/b8dqEAlmi3odZdoh7cP1TPcBtOj0ConHqJ1C8hBKDuK4jLU
         17YQ==
X-Gm-Message-State: AO0yUKX/9i5VGmaM+bIxvwXU10FMwA56B2AWk5gLu9OEzctdXJGMJtRs
        Dqy9k2JBHrYuUEEg9b+ZXtw=
X-Google-Smtp-Source: AK7set8cYzP2KSyPOiPexjRBTfqKs8wnu8uRIJaBHpzYQ8F7MDO610Lq+xMoZQqmrrbVAd9U/bSorg==
X-Received: by 2002:a05:6e02:1ca2:b0:315:9bc8:ac51 with SMTP id x2-20020a056e021ca200b003159bc8ac51mr3151237ill.28.1676996499567;
        Tue, 21 Feb 2023 08:21:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g8-20020a02cd08000000b003a47dd62351sm4171409jaq.144.2023.02.21.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:21:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Feb 2023 08:21:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Message-ID: <20230221162138.GE1588041@roeck-us.net>
References: <20230220133553.669025851@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:35:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
