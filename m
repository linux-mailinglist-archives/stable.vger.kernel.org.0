Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2664F32D
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 22:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiLPVbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 16:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiLPVbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 16:31:01 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4891639459;
        Fri, 16 Dec 2022 13:31:00 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id e205so3040133oif.11;
        Fri, 16 Dec 2022 13:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=becLM1VwH5z0CNZX94TYWkxV4SssS0v5+RD3px/6fNY=;
        b=WCOotyPLbeUPmiZLBjD9mfoq1zTocAD5kd4iCgh8d8QivIMwzLPbtRJqZQz/Ol6oyp
         EA70nQoqO7yML2HPiOkMR14L+zU5eHdNJISwa2EwvwIuZcu/ckHCnLqYpsqlamjCgY1Z
         xUydGVybLhnr4TTzWmwBTBH//j8TJ7+pEK3SCoJb6H2sUueigOtgQeMv66A64HSgwRQ5
         HMNQFmfpdGD2J3/dYzsShzqqGxYgjAbaFTKEwkBKIGAFNczLbEZdbg4ebB1unJ832+FU
         0rcufNBmq/tkTR4zURw+70i4TVcEYLHQ95CtsJZrftlFCozI9vC77Ym8Gw4Zuzq6M5RJ
         fYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=becLM1VwH5z0CNZX94TYWkxV4SssS0v5+RD3px/6fNY=;
        b=jOHE4IpCG5Odwkqqn3nLDTAX54KchKzqBkw2L79ZlM3LfdyZM/808IEXXQSeQq78so
         Toe/8bwk6HUBUm6NFdd/XOSGcX7yFCBrtn8v5NkQ05mBZCr06ckwGQH7riRlERbnuRaZ
         oWbprSB54A372Onn6g0ENvF8AJBWNKo3Res2kqGPRDzA1cEbpKfTrVcJ+9u4mPLdhmFh
         /90sz+mFU96gG7twFgtDfj2pYoGwvTzp4+QfadHcNKkCYbFuwJqFmb801xjoiIGyVbNP
         pYJF+3M1QlQoOOV4mJ0RIROHPtkUGUsl4CKpe2RfOwduW2BjnYrT1I25pU2G6dyivk8O
         RlXw==
X-Gm-Message-State: ANoB5pl8JyZDF/UKyIcZfk7KPDdGb0P4+mvJxBKoc3QwLBGDO6u5wBMR
        OyaOA6F0fRpgtjdbTUlo1TI=
X-Google-Smtp-Source: AA0mqf7An314fgilxpsLdgTLmcvipSCdSAYqlDaZJHiM/gQFWYzewJSRz2gvuh5H736YhqzF2eJc7Q==
X-Received: by 2002:a05:6808:2101:b0:35e:80f2:65cd with SMTP id r1-20020a056808210100b0035e80f265cdmr13560619oiw.35.1671226259677;
        Fri, 16 Dec 2022 13:30:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8-20020a05680801c800b0035e7c48d08esm1234034oic.15.2022.12.16.13.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:30:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Dec 2022 13:30:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Message-ID: <20221216213058.GC4067594@roeck-us.net>
References: <20221215172906.338769943@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 07:10:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
