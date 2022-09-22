Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF025E6008
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiIVKkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiIVKkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:40:14 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32DA4BA60;
        Thu, 22 Sep 2022 03:40:10 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t14so14799231wrx.8;
        Thu, 22 Sep 2022 03:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2g6oawi7LFkWBztbej0ETp8mqK8LEx1FGs0CZ7ZtbZU=;
        b=e4RYnZoEJe8mIDwxflErsiSoagXYzT4Bq++H4ATRWefhwyQrqFEB2j15O4FIX0iiyn
         GFNk7rg0t+BG7HJA8M99Y/fljRqxkeTNDfdJqqQe2xCvZS3oKiqtfPrDMNG1IamG+7yM
         GXMdGntEsuMwfuZBtq814IFQORBU8wlSOSMtFvMbVoXubFQ6MrItqLbqEj6k25Dlp5QB
         Fffx7qBYRkbD6/ka9k0uhIlKFvSxWs9O+EOPCAfnnRYyuMcpAxw4nWm/jMlslxSHBNeE
         TrocONfiu+byHe8gLr3tJHqNyPWbHdbYuBqg4dJIE62noU2hJlm0D94hHF9/bWraBWtg
         HUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2g6oawi7LFkWBztbej0ETp8mqK8LEx1FGs0CZ7ZtbZU=;
        b=5j0EbJo6TNDQaON4Tu6CIaW0qOrK2aEYo4ChS+SIyFFwUKAdnl8RvRUHy98PtyCtm/
         uClqlwhi2dvvDyg944bDtlo54/s9XESEgbt5vLdvdNeLcXUqUj0duRb6pr0AGgqLphUm
         1lxmV7SjImVnms7L/4H6VnI5oac3fjRIPqnClOeAV8ZEQ6DsY7BfuUKZqBXXt6vL70Eg
         e0ArW/gQKeLWC8g8nbyAbvlyNYrZ1vR5d9fEu8AUpI55BFNLuJKVXInQBBSy2YcLjXMo
         6S2qz8FVXP/WFXa0mTfE69Fpemme9KXc+SeKJn/K6oE5ftm9Jm7HYn1xAFGDZGzLgyPD
         BxVw==
X-Gm-Message-State: ACrzQf30QogluJrkrZ1q1Zy3jbS58EvQcwn5+uvwZBo3Er6C6QwOidNo
        9f6X2mYmmaTvefMP/Uu+XFY=
X-Google-Smtp-Source: AMsMyM6GmnZvRcriGAKGHnkFGMyXho8LzOoJ5RQ1NfKmDikOfdKcCFPwLBNtLEFQSuPTqj9zzbzsww==
X-Received: by 2002:a05:6000:1886:b0:22a:2944:a09 with SMTP id a6-20020a056000188600b0022a29440a09mr1599333wri.391.1663843208677;
        Thu, 22 Sep 2022 03:40:08 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b003b340f00f10sm6742198wmq.31.2022.09.22.03.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 03:40:07 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:40:05 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
Message-ID: <Yyw7hZYsTGfTCnUE@debian>
References: <20220921164741.757857192@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
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

On Wed, Sep 21, 2022 at 06:47:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220919):
mips: 59 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1876
[2]. https://openqa.qa.codethink.co.uk/tests/1880
[3]. https://openqa.qa.codethink.co.uk/tests/1882

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
