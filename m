Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23C25FED9E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJNLut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJNLu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:50:28 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C1156269;
        Fri, 14 Oct 2022 04:49:28 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so4741791wms.0;
        Fri, 14 Oct 2022 04:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AaQQNmDhTQ63O8gvYPwPmPKLG9hxIOmFr07BGT5pPL4=;
        b=ENeKv8TfJrjBUFIbIxSUwY7AgglGNbf3FG3xxvxdTaa2EXconSUXEcGOJbHIvOIvor
         CPC0GR7SV61M57LOOvsxgZ2pG3ypYpTIe4qYdzMqlbrDFLZr14BkHHjoX59uOTsYM7r4
         1wfbj7cBo9grfoPjKexAZO2Dp2Vf8UymgCU0asxqipowHxX2p5A64BwO58MG7XPbvWWf
         oaKKLIwFr4ZKa5kIWo0UDIhv7TBaZN8hf2bU2c9yl8mJCzkrSQLCQFP4vhVowBVSCMwQ
         NyiNB/1LQ+xaWAHYmSnoZ+teRsi760XKQ+TKX2qlOcffrdxOI0ywKfPqmeELJzBop5mt
         DX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AaQQNmDhTQ63O8gvYPwPmPKLG9hxIOmFr07BGT5pPL4=;
        b=TOFT1hYaHyUvprmWJ0t9YQ+H/pisDfYzqoLrFB5kV7bAIrjfBuXzWqCE89OJyI/SPI
         wUrs9b1bgP8+qLC1TFj69yNry0aRmpnQd0YwNAi2UqJ84YsQxi9vQVzbWKImNEMTALC3
         IDFBGWxLdPXgf9qp8z3LnCeEAE74y6WJCAntT08kyRTnv6TlMTVM9hUeHdDSaKpVj64J
         XTefHkhlUw4wB6zyRB+Oh2hm/mEdPkK+1c/iymUQ3y7RtwKHGTC7h60eifCgcjSQSLU6
         lfmeVxdwZnrRxRqex1ClIhG/a6LaCpd0BnirKAATuEsAsREZqkf9fnJD+9p45W1Nsbne
         IAFw==
X-Gm-Message-State: ACrzQf3ElFF0+eM6Kqa7akPqjLfPLbgP8y43EeAwRlB6ioJwpo+rAqbm
        2+a0VVaUMxKUdCOIgXbE4/k=
X-Google-Smtp-Source: AMsMyM6KeoUbEpigP1xvclK8PBuDH85xyMpSGio6ypild2fDTRbK9NHX4HIgK4a3MDj0aEFlda/ctw==
X-Received: by 2002:a05:600c:1547:b0:3b4:c56b:a3a6 with SMTP id f7-20020a05600c154700b003b4c56ba3a6mr3307932wmg.29.1665748158303;
        Fri, 14 Oct 2022 04:49:18 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id r3-20020a05600c158300b003c21ba7d7d6sm1788432wmf.44.2022.10.14.04.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 04:49:18 -0700 (PDT)
Date:   Fri, 14 Oct 2022 12:49:16 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
Message-ID: <Y0lMvET5i4FFQkxL@debian>
References: <20221013175147.337501757@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:51:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
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
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1988
[2]. https://openqa.qa.codethink.co.uk/tests/1993


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
