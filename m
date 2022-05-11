Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6108523011
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiEKJ7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239236AbiEKJ7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:59:18 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FC01C83CB;
        Wed, 11 May 2022 02:59:17 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so2883800wmj.1;
        Wed, 11 May 2022 02:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MAbg5yk+b/oK3VOSaGAHWACO3qSGTgNVxL8KcEWQXbg=;
        b=bjmI+22UfZIVTrgoWzZPc39+P2uwhHU7xp0hj67O+EJhgj4Vuo6EGZbVFEEARoGWL+
         1OeB7MRpRZR8XnbD4tvrwykHHmnjC9WOV2Axuiyl43tsVF0f5YzCUSd1a7gtt8Smhhx2
         bGf1KyKgIk152d612/xnDs4iX7kygxQKzaKANHqgwF6dG4rbHl4rB3EgAkY1ralsNhzX
         exSr4UglHYa8gQcZFvTsulrlG0J4njGFRUOoVVf1eZftXzWnOoJ7B9LUQRZHXjls71xR
         CZEy5BKAVkd4boYiVZGI3U8g1jphKsuEZSKFDTKkioYxQKAzM+NZb4u3mY1zPHQEBULz
         FtZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MAbg5yk+b/oK3VOSaGAHWACO3qSGTgNVxL8KcEWQXbg=;
        b=PhYu43BznBugP6okm3pzCTOWskdUEoqxylSWTONPe+r7J9rsK1c+CzuRO1c0ducmMU
         bjRF6Urawz8KQetj4JmCEVBxOY7AarbvMi32pk9YGu2ZyOPMQ805Hstd7BFI1Zh/Br3G
         s9lrgozMNFnCJeSGSmGmA+dWMTxQuQGYmc73X15Y5urd6SGiM9Mv5BeM++7e/3iF3BYL
         GmXAZFvlmn0Q24HMiTgte+rJRAvD3Wnq+QOV7A7uTkqUPo4NQChH0K28GvTYXkvvi1Qf
         ZnCaFYBDqEOF/2LYvMtCmdLVDoShFuX2n+5q4FSr2sqDswhDvsfENqmpqOkXgYQ3S2u0
         WN0A==
X-Gm-Message-State: AOAM532R8uT8NMRAnSt5cIO+noQXxYV1XRoRxgb3uRsfgRnffdZkFvWX
        wFhmj7Rzes1FRuV5kmLHe8A=
X-Google-Smtp-Source: ABdhPJyAVBOSQldAg0ryMlGLdG3PC0kRmeIrSjJ30GKqENnCjcxjZvmPW7Hi1opqRIRzvD/xxz4y7Q==
X-Received: by 2002:a05:600c:264e:b0:394:2c56:eeb5 with SMTP id 14-20020a05600c264e00b003942c56eeb5mr4049889wmy.6.1652263155934;
        Wed, 11 May 2022 02:59:15 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id b15-20020a05600c4e0f00b003942a244f39sm5550371wmq.18.2022.05.11.02.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 02:59:15 -0700 (PDT)
Date:   Wed, 11 May 2022 10:59:13 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/52] 5.4.193-rc1 review
Message-ID: <YnuI8Qomvql5Ecoq@debian>
References: <20220510130729.852544477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, May 10, 2022 at 03:07:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.193 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

Build test (gcc-11):
mips (gcc version 11.2.1 20220408): 65 configs -> no failure
arm (gcc version 11.2.1 20220408): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Build test (gcc-12):
Mips builds are failing. Needs d422c6c0644b ("MIPS: Use address-of operator on section
symbols")

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1120


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
