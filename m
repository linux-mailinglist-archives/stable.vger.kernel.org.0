Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D156A8137
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCBLgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCBLf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:35:58 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8193215546;
        Thu,  2 Mar 2023 03:35:35 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1528740wmb.0;
        Thu, 02 Mar 2023 03:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pFP4w9yXQRwkuHy+AS0IYRfVLFJDnB9DWr4aqzGFuFI=;
        b=nLUd9e7sjiOgddgiUGeMV90O35ulPhUfP/V/F9D9WRpEQHZWa6c/AhCLzvvzDW0GDE
         1FGsX4k59/SHzk3B1Y2wb++Pljn5Iakar2uHRhGkLyb78J2AyzwesLmFz985o254RnIF
         Uc0CX12kdKFr76dZse38HzPoch+O24rffJJ84evSaO2IkLo3xWqlxigq1YXrNuj5mNYi
         BlQZBaZJgH9ojaO898T9XcdnNYcb6zFX6aCnPD/UmRr7yqUkmbN3ga4js1j4qjqR31qP
         3qHMe6uUo4do72aiumAEmiSfSiIb14iM69s5ice3i3ACH0GlufHAyyymVKNT59z1LUSA
         KOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFP4w9yXQRwkuHy+AS0IYRfVLFJDnB9DWr4aqzGFuFI=;
        b=iIVWbHK0QPslsJcAp0KIX/44QXtEmPNbP24+lSkvC1zSSfS3xATLDEQk0Ll/5L/gXx
         xVwYUor4tr4X2I1c6wsSV39Z5vjMIFt68qr/P9D6iRp9fvXmCw9E3yIzHjthH6oYOiPQ
         XRg58myRsNFAg5TQF5Densul7IJWq/QwuiyQE9AEl2gSU4eaXpXf1yLqW4kipVBtPbyR
         8uVVeSGYcaRkV7/CnfmvqJf15pm8eMJx4CU4fGTgtISEI2zCIugFS7l7OKcjcCk1Zbbx
         3NZYWl0SFtlQmyBFuYNzOTJog4dzbCNAmncUr78+zKPI1pb4AIj0NYOMNjt1Af7sz/PI
         RSJw==
X-Gm-Message-State: AO0yUKWiod/Fw+Mzyy01Jg8iOqYApNQyEQxOaFwh140ld9H4TtQBxZoq
        dRRufvn4ZWM16FyA4TWebo8=
X-Google-Smtp-Source: AK7set/00cHFsu+tJ6BN+vsST01MHRYZnj94o5Qp9+xbBG33vZtqB8skwAWVnzxCjE2KEUBF5NEONw==
X-Received: by 2002:a05:600c:90a:b0:3eb:2b88:5af1 with SMTP id m10-20020a05600c090a00b003eb2b885af1mr7464514wmp.18.1677756933651;
        Thu, 02 Mar 2023 03:35:33 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id f12-20020adfe90c000000b002c3f9404c45sm15007009wrm.7.2023.03.02.03.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:35:33 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:35:31 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Message-ID: <ZACKAw4rA6CzXg/e@debian>
References: <20230301180652.658125575@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Mar 01, 2023 at 07:08:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2974
[2]. https://openqa.qa.codethink.co.uk/tests/2980
[3]. https://openqa.qa.codethink.co.uk/tests/2982

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
