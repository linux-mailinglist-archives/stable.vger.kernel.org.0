Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2133C542D24
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 12:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbiFHKV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 06:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbiFHKVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 06:21:13 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B849A1AB615;
        Wed,  8 Jun 2022 03:10:07 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p10so27664662wrg.12;
        Wed, 08 Jun 2022 03:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lu5Gi1s9y1G6cPLSOeif4KWeiGMlFNbcoY25oYpZWgs=;
        b=bkY/TdTjcvlb/68hMO+WTnXjf+B7TdnRL3WJ0sjffKwpcKpFKhO1f8jpbf2R7Mns1o
         JZ7qm+X7CfBHRCzCo/JoNgsiC08GizdBroJYGj8pptouOSyBr7DOtnWl36Wxgn9QH2dJ
         uAcpOfMo9JpG3BcaLrtn4J8bL26IickWp8jXsEySHAgkc9XqeVZX0fR3cooTRxBcsPOQ
         VA3mBxosXodZ//N2kMeFhaI+3tBAfAZqq+txtvFhWqg69q5UBjJu3JcuDn9Uvv5PriIf
         OdoTu8qkDdMG8quWip2+j/IZjA2nbFKVHT5Vyriti0FguAKT2h1lJ5jnxl1F48CZGejE
         kjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lu5Gi1s9y1G6cPLSOeif4KWeiGMlFNbcoY25oYpZWgs=;
        b=WkeSyg92WD8OCpOCLzClsO6C0jOW3kbRxplKdQdStJi6bT37Ha6olH2Yk+SBpEFRGm
         2P42FOum12Cbalvn5u9Pkdh7pKQEylvYB3vDvCeFHQpZOXnlMR4Wxkq/Mn9GUczIcqJ8
         ioBhCsYoiPFHArE4CQob9dS/qj7+1qsjyzpdRHw6F5GLS4QfFI66OqhrUXTa2TdGLjUk
         S2FGbgnSmotak2efMeVhsxN+ru89haYBfr09BquMaDxPuGjHkSv7hh/YT0DQXn1vijvf
         7zZ4FaYyOWtdwHjJpdFo/HZHsdJFyEr2ai21vtou+15LOKXJRI5ewksbZf6Oq8ljxaSt
         UFVw==
X-Gm-Message-State: AOAM530Pms4LKvDTqwmd/YcT0W7M6Kz1IGoaEkkM1XYscPpC52fUw1CF
        gWiIQfyByIg5H8uq3ByT/d2m6FKERfI=
X-Google-Smtp-Source: ABdhPJyPymCRkiCcVxvCXsc+Jpg4tDJYENC73Q9WNKisoJkqzJH/ABUvISSvZUKZ3iFBp4XJJDVCUQ==
X-Received: by 2002:a5d:6e85:0:b0:210:3ded:60ac with SMTP id k5-20020a5d6e85000000b002103ded60acmr32057370wrz.143.1654683006083;
        Wed, 08 Jun 2022 03:10:06 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id g19-20020a05600c4ed300b0039c4506bd25sm18484596wmq.14.2022.06.08.03.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 03:10:05 -0700 (PDT)
Date:   Wed, 8 Jun 2022 11:10:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/667] 5.15.46-rc1 review
Message-ID: <YqB1e83SqynwHqQZ@debian>
References: <20220607164934.766888869@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 07, 2022 at 06:54:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.46 release.
> There are 667 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220606):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1289
[2]. https://openqa.qa.codethink.co.uk/tests/1293
[3]. https://openqa.qa.codethink.co.uk/tests/1295

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

