Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA2857B8E8
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbiGTOwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240484AbiGTOvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:51:55 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1BD60C4;
        Wed, 20 Jul 2022 07:51:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n185so11013454wmn.4;
        Wed, 20 Jul 2022 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hWJt0D8WlzLNWeXn7K6HL06gvW3ykTtIkLO6wHOQlb0=;
        b=S20B037YO9AhCgpJuVS2t2WXqdydhI/RY6R9dekFJkYMZyMxBUZ57z+ePvegl4Enk+
         9CmhgqU6KUnhXbpMaOhILToRvS2IkKgn+SsKHKuooUnqQMl73U2iaZNpQ0qpHI9xsN0o
         wMbMj2bIpXkurujmIsyjZ2Y9e/ShVmviYgzN283mN/BYGPaM7r+iH/4zkGkLraMGlZEf
         YrlhXFPJzhZpXvseIorZC/+F2MjjGip/n4N8CW+ytQLDc5mHLcxGPitQHOt+PYmW1Gef
         4mZoSv7YzPT3A466UUGWmQsy26CjVLutc6OIS2wmmXmviu8pZYkD0gCLSdWy7Ram0tv2
         B3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hWJt0D8WlzLNWeXn7K6HL06gvW3ykTtIkLO6wHOQlb0=;
        b=JqZ/2aIuNlB+BKmE/c2EFNibmo2RNJquOsF8Zvdj6rrzr9oDpRCaqqws0g1VyZvZcz
         BZrS0OiIUvWQHvmFP0Q/O+VC5wfmg5FQerZbrCAxuUzhb88AGKP8rhlsqdMTETg3d5qE
         28OAGmdfpdvcO6mY0IXELPcyoabRcYq/IpSEHU1XrSC1v8tG1NDZp6Vb4uBZLRYljhcc
         n55kBt/G3mXBUUR4C3DktAol+PYEhUxA0/SLo08CgmWZKW53ge1I8KxAKoVHjFLk54op
         pKxHY+vH35W+z5DeuA+vx4a9yr7VLiFAQgXlr0keilLPTiWo5O4OL3pCBlJCCEd39Y5Q
         QEVw==
X-Gm-Message-State: AJIora/rVDKFRhXqe9g9O0DDbriWMTQcRR1IGxMIYInN6opOq9M0EGgL
        T9XchYcWPNWAyhzNk00mWak=
X-Google-Smtp-Source: AGRyM1uT6RjXmE2Uj4GUddtTNyffWDKagxZ/Tp8i7NXk36rji3Qo8u5ka1qLQxuTQ5wojgS6AAqV5Q==
X-Received: by 2002:a05:600c:4ed0:b0:3a0:5263:cf09 with SMTP id g16-20020a05600c4ed000b003a05263cf09mr4220022wmq.6.1658328713275;
        Wed, 20 Jul 2022 07:51:53 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id bi9-20020a05600c3d8900b003a3270735besm2625218wmb.28.2022.07.20.07.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:51:52 -0700 (PDT)
Date:   Wed, 20 Jul 2022 15:51:51 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/48] 4.19.253-rc1 review
Message-ID: <YtgWhz7TqzBBSdB9@debian>
References: <20220719114518.915546280@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
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

On Tue, Jul 19, 2022 at 01:53:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.253 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1519


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
