Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4457D5689DE
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 15:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiGFNnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiGFNnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 09:43:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DC5FF1;
        Wed,  6 Jul 2022 06:43:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so15820309pji.4;
        Wed, 06 Jul 2022 06:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MELrVMQYedZaLKXbv1d6NyTb5r5/3CnAcUiPjP/Zv1U=;
        b=RVEiZUPa6ZtqN/JVxwMxOZKPFAVGc7b/opeYDHCmzQ7WU4SiUqd3WN0ofQnBMUMHte
         RtOadCg8xQQD5/bRmtPJsdp8Kizi817UgKdWpyhFJo3BJ3r2A7YCaIcWTrXXUlZ/k2AO
         evu03DdOrhxdoQcwtqRpTUeot58MlhyNLJTcMr0QzbMRukXdB671LjlGbjXxFS7uZ/Pq
         LZCeZcttPxZgGnU29mRRfgs82zXmf+MrGL5b43vBbBPdTMO/NlYxg6NgPKL26+VxBP2O
         2gOwCG/0Iynrpxr2EjvXQFU8mA/AHUKufuEFrQvo+eATlE4ja/oMsyHrgt/drxYmVc1a
         k1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MELrVMQYedZaLKXbv1d6NyTb5r5/3CnAcUiPjP/Zv1U=;
        b=TPaYROeLUFqiIN1ju0CeGOJv3y9zu2Ju15gdiziD5IUiShYfhl+8AfsIJp8xvAeITh
         7/o2PG5c/NHGsndzpTZ9Icg75TiTH+1oFxxrRbYC7hWr7KWWpbX6qqJyOhPaBoB5g9nj
         DP5l4bRR6JWnvOqpMKlbx+P6zulmArxr2AXkOvJ2Rjq9Gyb4CNovUrpiu2nfhQyJLaah
         DydAQyQwQWLaV0bdAYtw7EroPYHKo1FxCj4uic+gjPG4BklAxxpUTcDvd7hGote02kD2
         TRhBoNmX2FsjZabiYwUA/M1g9FXmHjWjhuydAkEUHjEqu1ORb6MkdLjuvt4nFD5i1KdO
         PYsg==
X-Gm-Message-State: AJIora/v/YHsrKl5kw8jv/IEZh7EZzj//LcKGlUniOXorNWasHqRvUVb
        zgydQ+DkJiSJaESvHJ6KiZg=
X-Google-Smtp-Source: AGRyM1uRMDNRKJmLhPxk7Ym2oOw2j1PasNPRMuKMUa9lCXiQicU9+hdVopJVEg7xRJZGCwJUDiL0dQ==
X-Received: by 2002:a17:90a:eb01:b0:1ef:79e9:41b4 with SMTP id j1-20020a17090aeb0100b001ef79e941b4mr28001809pjz.8.1657115014999;
        Wed, 06 Jul 2022 06:43:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l4-20020a170903244400b0016a33177d3csm8654234pls.160.2022.07.06.06.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:43:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Jul 2022 06:43:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/58] 5.4.204-rc1 review
Message-ID: <20220706134333.GD769692@roeck-us.net>
References: <20220705115610.236040773@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 01:57:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.204 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
