Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01705563154
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiGAKZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235872AbiGAKZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:25:48 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B2A735B8;
        Fri,  1 Jul 2022 03:25:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 205-20020a1c02d6000000b003a03567d5e9so3018737wmc.1;
        Fri, 01 Jul 2022 03:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O+4yQmIDTIJfG/hk0Ok6i5+ULCTUgBaORuS3L7oY5Ks=;
        b=mJYj4pVOBrRmV5WHZcmbptjYd0ipA2pOlzF65ZRKuSNV2sYZeRtyzwjcUtYmyE6A+f
         wje8kGn5fGUowdKPaZw4lWFIJpGg2CU+P3srqFXTQybpjvayWsKQ5TvMfrrft7tunIDe
         qQ1eCLP9/UNfGyM22Kuz+BiqZxzpLQhwHQMBTW2r4bHyumdQDh+f6dhmTrf9WkW7fChQ
         6OES4cH57/Asuh6CnLMcP/qrppG/FKRRmNz72M2iX15VpdsIsof4l7Edi899pgufi9Pd
         1x3nzhNFLoQg1pinq/3eUtSyAWQDXAKS5vmc7J3AeLZlufzC6Zw29iKRZ90tIVGjO0iT
         F1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O+4yQmIDTIJfG/hk0Ok6i5+ULCTUgBaORuS3L7oY5Ks=;
        b=VtpcdRmxneKEAFXZL6a972LXTeDdW/o+VATYRBXQPkGkEYAwyR1Gd4PjFdiHF3QyMn
         vJYBLwFD2TKJhHm0QgB9NK7WsNtYDTmtrIawc16lm9PsI/BjlMkV4nf6yTnL3jtcXivI
         9WORgOtNfFpeYWchArxNUoaaCTDFCSrdYrj/wm1wJi2SMJRWOSu18O5WUlkjmMcfpK8Q
         eDeTLGSnGRez4D57htqwEdLpcDWmRFESBA6CHKvaxdMVaVpdpgKfAmjeAtxVTvgTWDGp
         QzIcDzf1AXX4xBTRaWVySuTBf31IHu7hhfZWBpml0jiN2IvG2d7+EStROnZoiM4srpL6
         vnXQ==
X-Gm-Message-State: AJIora+GEMo7t3bzx9vHw0He5ZZo9yMCArXezZjywpyYqKsVNxpyMCx7
        D+5loBSPMQzcAi1mNKdAUTDbe4vtvAw=
X-Google-Smtp-Source: AGRyM1v5bf0sLXgEJavec4vaovfbgFQ8euNoIwwueVUCfZQe7UeiJAZZn5Z8BOJoyGo3dI8NcrEMhg==
X-Received: by 2002:a05:600c:154c:b0:3a1:884e:72ac with SMTP id f12-20020a05600c154c00b003a1884e72acmr5879138wmg.23.1656671145680;
        Fri, 01 Jul 2022 03:25:45 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id ay26-20020a5d6f1a000000b0021baf5e590dsm22011115wrb.71.2022.07.01.03.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:25:45 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:25:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <Yr7LpbixRYreo11p@debian>
References: <20220630133230.239507521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1431
[2]. https://openqa.qa.codethink.co.uk/tests/1438
[3]. https://openqa.qa.codethink.co.uk/tests/1440

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
