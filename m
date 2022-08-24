Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF6D59F850
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 13:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbiHXLED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 07:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbiHXLEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 07:04:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F4782858;
        Wed, 24 Aug 2022 04:03:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b5so16024875wrr.5;
        Wed, 24 Aug 2022 04:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=QlysCdZ0nnc8OpXZmVRMdMedN4tb//dl+QlHlB0mm3w=;
        b=WXIpxMo9knIpO63m1ubUPSMi9PuC2gj75sq6u+zIQYSREckK6uJa5CjZQ5y/I5VocW
         RNvBMuhWS+Wf/4om7AUksCwXfsrOq8IiIh8KUYtS6Qj9szsO33HKNto2zj5INe6L0+Ai
         3RWvwmbon2f4ZsOluRgMuScgOGjgDFifYqs7BiYRpmAkwv3j7Z8USmiANREO9x88IOQ1
         2ANv/rQ3vxNYlii6xEafTOJwTs5XmXbKuvA3w3D7fVANdYE3Ap7o5vEiUhdxGRJ1hEBW
         d02QT+AgrW2vEDsVN7HdQIGo2YBn279COrzl3Im9LSg9obZKWLrmNSWTb/TcOwQqAy6C
         J38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=QlysCdZ0nnc8OpXZmVRMdMedN4tb//dl+QlHlB0mm3w=;
        b=NAl8lqY2D6WiNwTuOQNENq17L2vu+PaKQG5m457RQDHOaZ6DfNeFjKugDQdpW/XzRq
         tyGVI8s/UG9fWfcWIacI2D2rScMlmdwyvpJdKKHCkWCrLQvddXsZ0OnxS5TAJWYq0O3b
         wBtjIO18Z93/I9J6+Wkpu8oLUmT93b2LsDTIAreQ/VKmFdl3LmsvOJdDIxevi5D5CyrT
         N0F5nnmvjRd8toe3QXopGteIYdi6SUKwWPK+7kDpNlDHd9dbYyDBzUBrLGKkPu47gjnX
         rAg2q2FJ/EVOTum3yygNbm7xoLoaW7SSE6kAGyzY+9xXQwiPyr4MlngjkUrWLIrXMG2S
         9Z3A==
X-Gm-Message-State: ACgBeo1zh151DJaIqPXTP6KmURr9njHU+++wFzLpPfJTJTky39kpE7/K
        GhZXYuHxlXRWRoElXfEbFAdrkzRCCxewcA==
X-Google-Smtp-Source: AA6agR7DiOGbfcJaa3Sk1nmAQAj+OL7dEGkd5k6kK83OMFBcxtt8AYDQUiXh42pzjJUxd+ZLqO3T3Q==
X-Received: by 2002:adf:f643:0:b0:225:2cb3:4b05 with SMTP id x3-20020adff643000000b002252cb34b05mr16365915wrp.12.1661339037914;
        Wed, 24 Aug 2022 04:03:57 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r18-20020adfda52000000b0021badf3cb26sm20286099wrl.63.2022.08.24.04.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 04:03:57 -0700 (PDT)
Date:   Wed, 24 Aug 2022 12:03:52 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/287] 4.19.256-rc1 review
Message-ID: <YwYFmFcX4x9qrggm@debian>
References: <20220823080100.268827165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
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

On Tue, Aug 23, 2022 at 10:22:49AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.256 release.
> There are 287 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1684


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
