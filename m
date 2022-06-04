Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57D353D6C0
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 14:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiFDMYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 08:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFDMYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 08:24:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C434BBE15;
        Sat,  4 Jun 2022 05:24:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gl15so6711490ejb.4;
        Sat, 04 Jun 2022 05:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mEXSkUhEMm56P4ZFNvq8XO+/T30/w+hzr9rUqfNQ2yI=;
        b=fsfRFGnnYW9a4pCT6ufx5vyrNPwQgcbjgbWekkHVNYmFOljNZsXdgMLPl9I2qNYJV2
         2MTRSx7/BwfqkAPt5ToKv2yp+72/F6+FbQ/vQ2KxL5gtK0wikQT2p2lNDOcnABKdibT0
         mst0qLIIYPEwE/KQrT1koqtiTcJyweiSZIxle6kAnRkbyNPN7L2i+1z71XDZf6MmnZ3y
         6Df0Ylv3ltpcTEC6rud15d8GN727fb64HxQhVv4YiNFBWnTRQfAUjFDzqf6bgKRZ+mw3
         OEIjL/z8T3i5C2M2tT1feowxpBM7mWvB0HWj7Lx3iYsKhNqdDQjbI/OjCRG2knCoaGV7
         4XWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mEXSkUhEMm56P4ZFNvq8XO+/T30/w+hzr9rUqfNQ2yI=;
        b=4Z4L1qX6E74JiG0H7PLRJDNtipQ6THIZTbiCuxRFO2XR2OAzgjpkywtt8rY+8e0352
         XYgvL6xLrrZXC9NUMTdlJFudmAq24zQFUhRcXSRmPmAt8X1iOcRSpLSIWmGUPnEJMPpq
         +lYLqxMLhUD5VA5NbbhNywrYG8q8Mnjffe7tXYBrggI3yKnTa1eo9OtA6q4fIpO4YfpP
         Ovh6y5kwbm4NHR4UHQK5PSqoTBkaByPZ1QGhrqAemmdynWhiEOGTQiZviIcixqGj6wyr
         s9wPvCSzCTuO2O8ZXm0AZvKcCciezkjZeoF3cs/IAUJmLFmXutKq2J+kh2ayO+5DSEm6
         Cdjw==
X-Gm-Message-State: AOAM531jl27YV47TGm2jDSYaLXCGNrUulewdlHxdCV+7zvWiAwpUHOkp
        XpyIkP+zmVHjA9yXkakHcEE=
X-Google-Smtp-Source: ABdhPJw5XtnSuq6h2ifk3ttEZgdm/6nFke+5VwaU5meXqcZV8JmLnVqA75rvHA6KqBT1l6wJ2JkC/A==
X-Received: by 2002:a17:906:ece3:b0:6f3:da10:138a with SMTP id qt3-20020a170906ece300b006f3da10138amr13106230ejb.438.1654345448406;
        Sat, 04 Jun 2022 05:24:08 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906488a00b006fecef65fc4sm3956896ejq.179.2022.06.04.05.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 05:24:07 -0700 (PDT)
Date:   Sat, 4 Jun 2022 13:24:05 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/53] 5.10.120-rc1 review
Message-ID: <YptO5Wmv4qpDds+j@debian>
References: <20220603173818.716010877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:42:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.120 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220531): 63 configs -> no failure
arm (gcc version 11.3.1 20220531): 104 configs -> no failure
arm64 (gcc version 11.3.1 20220531): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220531): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1261
[2]. https://openqa.qa.codethink.co.uk/tests/1267


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
