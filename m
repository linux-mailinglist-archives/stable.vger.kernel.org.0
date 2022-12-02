Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42A63FDC7
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 02:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiLBBoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 20:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLBBoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 20:44:23 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18747D3A09;
        Thu,  1 Dec 2022 17:44:23 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id r21so3927927oie.13;
        Thu, 01 Dec 2022 17:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfTGdOyFxxtKxP4IJHAgefyV3/ZRJed6p6fGcue4gAU=;
        b=S+rMlVZ7aRhISeC29aQ4ZPHoxkzetxYUYnJYj5+nsWQdy4iCrlJYezHWtgdYympbc/
         GwuEKQltOQ0U+0aAzWvQ2fvnSjVf6Am7scGf7d5hFYRTWVBPmlNh6zWa08v1XIpu7iZp
         ZMtFL2HuYhayh9PE594Jo+iii2tXmddvt0Bsic5UZ6TJ+TURZ+iZ4kpYMdchmz/pgH8P
         g+/G7FZrh5VORcoob46rhRHw3WzroT4T50f+1A3orf87vS/qmpNpH9dkGKdM8S+dSfh5
         zlhaos/z6f/UbHeNF5uDSkvhICJKrkf4s3vEFBh0F9pzTqvBlZLy3r8haOZAJv4zWniR
         if8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfTGdOyFxxtKxP4IJHAgefyV3/ZRJed6p6fGcue4gAU=;
        b=RgRcu7WTkqJGePizKhnVLqY0sbhFo8tZg9NY9fZIV2r1Unfju/LWV8f1le5nRpP3g3
         0I5C8Be47/MXb5+VPTZ4HvNeo3pxF+d7IzRtaH1tT9CGCD4xt/uIFL4aT5sN7DEO9yd1
         NVav+Ywr4Mk+n6JWHCnCm3SBN/kzCPsienqwSBguQujPuxtl+UvAMnsce2AHccFTMS+s
         DVy4SfuWWWddYVfBF3ElhUwMz4EQYWWizqAqnq1H9Q3nqTG5p98Z/Z8SbyBy/8Ky0he6
         7tFimJjT0/BY8pgPNbsMGtdY+E1/L0qMKjhZEP0RNKD1fHaYqWLkFr9+4MhjOwjhGAhH
         +ZTQ==
X-Gm-Message-State: ANoB5pl0ncu5tcY7mHG/UtID4jJMc33F53qybtOwHTnIp5X1i7dF0cQ3
        Vo8Hkxz/BP5n9XRY6Cqq0UXonmQuLRw=
X-Google-Smtp-Source: AA0mqf5fhPHewdrT/xVJmYHWkseyER1kcGCYnobbR0wJnl0A7yB/CRgglnClR/1diVOLDZy1sS4f8A==
X-Received: by 2002:aca:2306:0:b0:35a:2bac:13dd with SMTP id e6-20020aca2306000000b0035a2bac13ddmr32458068oie.272.1669945462290;
        Thu, 01 Dec 2022 17:44:22 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y12-20020a9d634c000000b00661948e6119sm2859394otk.47.2022.12.01.17.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 17:44:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 1 Dec 2022 17:44:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Message-ID: <20221202014421.GB2255418@roeck-us.net>
References: <20221130180532.974348590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
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

On Wed, Nov 30, 2022 at 07:20:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
