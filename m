Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C76570F4C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGLBNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiGLBNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:13:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D00532EFC;
        Mon, 11 Jul 2022 18:13:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8so4870388pjo.5;
        Mon, 11 Jul 2022 18:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9pb8vi/EgdoQwZNmcDLPeKQRD0JtOlWn3RShifpijWo=;
        b=doL7MGyG9s/wGgwPiJfM0TJ6oHwLnszllo5lD5tR2AMuDPWhdB2pm/mwMiYrIBKpJT
         H02TTkY3UKYtxJQlVYNLb2k920SWDt7MChjp7LKg0q7akVpWze0TGmPbTpikJ8yFHrgV
         wx02Bf5MkSVQnoDGeMnigPdL8XwPC6Gw13RhU1cTR+Q7H8tRuSMiIi7ujaIyO+7N4aIV
         MHfH/bp6OYAlDQcK4jYAIX4DFrJLC0G939XY+byw9NY3TWfIINyOw6NeHzd0LSbMTYQS
         lTNFL3H+bor7YIjog3qZX4k7wlMm4EFLxPYKaesuVNzfgomCdwbsZdJbiCEmzXiaXZ3e
         X7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9pb8vi/EgdoQwZNmcDLPeKQRD0JtOlWn3RShifpijWo=;
        b=EW4OmY3yyV21bdgnW030/c4rWD/km2atYoNNakSVQHTwUICFt4f2XPVjGNSX5j06dd
         1mtzHpgIM5vFVMF2GIicn1ixNAIq2XfuTFx/5ZfQooihuS0UKWgyAJeJFwGvBqNcMh4f
         6QMCeEX9lvyKhnfLBPBhIXh0zL7RyvQSIwL4A5vmgQ/zYEpWeQ9+BbcDkIkWvBMlgXeR
         HqRWfXN1g3JuQkdi6kcKkMhvmRjGPYUw8y+ZppYZVbnKSjnUR2qkXPdC93a1+LtEhiym
         flgvYgRJbiHtluk9ODvJIaaSEbKtRFWja6CRyaMA9OC6xWobDuSQ0fwycqyrJFPWRPDB
         bnMg==
X-Gm-Message-State: AJIora/t0OPhWf6Ir9y9xXd5voZIa3XZBQdXu7XdBWq5sp/GioAkc8RJ
        roNJgTI/Gt/5Pi4ydwn0qZk=
X-Google-Smtp-Source: AGRyM1sQ7PDuuwWPaClMeUjKUuvww0jYmfkPrjMHgqYEoGHS6GdJ/4gbFOGFUbjmrteiuH/7keBa0Q==
X-Received: by 2002:a17:902:ec91:b0:16c:29d7:5e90 with SMTP id x17-20020a170902ec9100b0016c29d75e90mr19188723plg.114.1657588384551;
        Mon, 11 Jul 2022 18:13:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15-20020a17090341cf00b0016a6cd546d6sm406657ple.251.2022.07.11.18.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:13:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:13:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Message-ID: <20220712011303.GF2305683@roeck-us.net>
References: <20220711090549.543317027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
