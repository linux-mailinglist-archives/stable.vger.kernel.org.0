Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7B063EF58
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 12:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiLALWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 06:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLALWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 06:22:33 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F1CA1C31;
        Thu,  1 Dec 2022 03:19:45 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id f18so2164789wrj.5;
        Thu, 01 Dec 2022 03:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i66hpYzpd8grtubkOrknYnz1Y3ETSD1rR4jLwv+APCs=;
        b=LA4RlQTjdUhRFiTwf3YIGXZnSxA8C3Mcp0aKJMHfsviDYCr0XNK5E/W5/LCdZcRdX5
         ggFBVCJVIb/7WYePpVsIQdWEIGK+0kzvCcyNd0HtFqNXaUQf+CMCNc7FE+gxpS0iLj2o
         Veet64rh3Pz/cPcG5oB7RXNKbIjtpB1xLc/D+7wErOFBqi3SVwOIdmd318/am3bmZZdX
         oWIa/HhmGGsahSgUTf3GEoi9TGuMbV2BsDg/xlxGezwhloIzSnZUPwhXpO1YcTqP4oC2
         pwFFdjeazAn1e+YviO2tji9L67xGJj0y9Fo2ndT4xvWYkyR8ahyQQi6wcxVkyVRlkt6X
         NVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i66hpYzpd8grtubkOrknYnz1Y3ETSD1rR4jLwv+APCs=;
        b=52MCXuLUWOy1+v3Ga2ajKDahWB4Qmwze5XovKy+aAa/kzerojBMxrpvVhYqHK/MrxG
         rMPpao98JxEOZmBoqoyBfIgBXTgZXhC1BgU6QN2C6aCNo/mslcUzvK1ZD9HDj0ctIcVL
         46qEPhYTiB9wD3kvmGKUWy9Kjx633Dt0xsl2EY7qvnSH0HD+chIyvIPJolHkhevngbHx
         Qc3A0MmWwKnN4O5/0Y8btGZdEnGSnv0lnTuAXToOkF0X+4mmATJxvKO+LfoZzWbP3srP
         X3j49AMdEtztKukP4xkmTKi3PRzLL9d82boFbXjLy37xmo40CojjHEpLoux4VtjkJIKW
         drkg==
X-Gm-Message-State: ANoB5pnb7SkIyFb9ZOezMbnjj4L6EMHP9qpjFchpLa0gPXs6EGAhjCaw
        pyy+GUJxpdUxhRhN2BCBNR8=
X-Google-Smtp-Source: AA0mqf4dl/pPDOQM5xaL3GUWHByF0Celz1bpsSl1wzbvK2NKtXqgDRnYOZx19SL6fgVPWeE+o3NXWw==
X-Received: by 2002:adf:eb0c:0:b0:236:6deb:4498 with SMTP id s12-20020adfeb0c000000b002366deb4498mr41467708wrn.52.1669893583918;
        Thu, 01 Dec 2022 03:19:43 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003b4fe03c881sm9687169wmq.48.2022.12.01.03.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:19:43 -0800 (PST)
Date:   Thu, 1 Dec 2022 11:19:41 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <Y4iNzY5UmvkKBP1p@debian>
References: <20221130180528.466039523@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
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

On Wed, Nov 30, 2022 at 07:21:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2254


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
