Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45855E46B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346370AbiF1NZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346165AbiF1NZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:25:08 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501B136169;
        Tue, 28 Jun 2022 06:22:01 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so3585748wmb.3;
        Tue, 28 Jun 2022 06:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iTZvvk1al4f8MFvuuqH+B1HAhloIRCmb7wQTsX51Edw=;
        b=K3rqmmlWkEre/JQOe2rlZPVaVxhM1IB3jbjSxR0Bf/gvqiI9SigzIHeMMHp1eBQ5o3
         FKS90ToZkEo4+vdMUKpIsnPv4OdlSkat65ewe3/qLpwiQHsP9rH8ijDNac5iShAcXJMf
         DfVtIscRVvzCSK0TsZrAw9V9tkX14vOQsoz95u/F1znaglVjv6MSlRh7THgoBTeisKIe
         qGAaIzxKnlWKVDxEzzY/Emq/BYzuFmA4K7wbVW+Q5yfZ4kpygUzXIeMENkq+2Cy4VH8G
         u50oPJOts3fLi4/GQLuTDW4g9qgx2HVIvSt+knz7M+60SWB/u7tpxeFasLmbmqmVIPRf
         zC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iTZvvk1al4f8MFvuuqH+B1HAhloIRCmb7wQTsX51Edw=;
        b=URLCgNVe+C43ctrh4djsGYs/4e/Si0MgNIj6hMuVWb5Dvt4Q/dnhXVN843POpT3vSF
         sZOQqTOlcUxCjNTApJOXqHxgJgEuPFpI2/FsyPNzFN/Er58O+sjEVNCwa1DYBsg+93bl
         Zl5v3l6koVU3bvfKd+1hDtDdHRPFV13GgBzEsDTyDHNtAcn/J7Wq/0cVDjQSVSd09KzL
         rr2hGLz16t4ffOrAxljLkLIxGPAd3P9DpAMm7UXJb0SdSfixHzV3Je9wpuode03tkoXZ
         LY5jg+0qe5C24M0eQH9ueZ2a4hEV6rQJ0DG+bcMgEhCQwpqCnDxJUMX/fhhlYLrZ0jr0
         /R8A==
X-Gm-Message-State: AJIora8t9ZnpvTqdT02wtAHItNMoGbLKPMUHbLNrjZdwNNSz4gVcHjJA
        xw8i2y9CpEJQyVF2leTIfg0=
X-Google-Smtp-Source: AGRyM1vODun3+bu6OOoZJox5uxnKvsud/SrJ+rW9IU1RUjdate4BFBKUKN0zkk8O3+ATES74Zwr88A==
X-Received: by 2002:a1c:2b05:0:b0:3a0:2ae2:5277 with SMTP id r5-20020a1c2b05000000b003a02ae25277mr22159293wmr.30.1656422519594;
        Tue, 28 Jun 2022 06:21:59 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c350800b003a0502c620dsm3854121wmq.44.2022.06.28.06.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:21:58 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:21:56 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Message-ID: <YrsAdA6dL1qx4pjh@debian>
References: <20220627111938.151743692@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
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

On Mon, Jun 27, 2022 at 01:20:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1403
[2]. https://openqa.qa.codethink.co.uk/tests/1408
[3]. https://openqa.qa.codethink.co.uk/tests/1410

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
