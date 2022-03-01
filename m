Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B564C8AE8
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiCALg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiCALg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:36:56 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1426A92D3B;
        Tue,  1 Mar 2022 03:36:15 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i8so2947920wrr.8;
        Tue, 01 Mar 2022 03:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cY7j81vVJCKOqzb7oZyUm2nyS7klLCQTNKpSA1EA5BE=;
        b=XX4DlY7cD/W9DEoDYErHAJN6xdWkPER190sHEXVYuIKKNCJSHGDCaGSPRuT397F65S
         XBZlipj8/1FXMFi6UQVUS06hKGrUUW8+66hJ6LhWOgc4oADCpKZlMaSS8V5a5hGobjxs
         da3wp5FKdzc/XI02WXVLMAWfDPqm+N7OuthKMpQL6mO1gE9TUtbivnvZCJ2BmswF4vwz
         h9+aNwFEiKSmncs/Aet8WL9eZ3nOi6H5tj0GKGK8/j8700sMjdMgbrTB71IHDctgzdal
         rBRBAvSNU8e4/8Bjpj68GaEENQVHnRt9IgfEJCuNz5DI8zWNlxbnbD2MvLeLShx+cgnY
         2wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cY7j81vVJCKOqzb7oZyUm2nyS7klLCQTNKpSA1EA5BE=;
        b=4mLH2XZR68SXRJGwHEIRCSVXJOldRezxzgCBUAqqhfDdpuvPIpbCGbuIO38coKcW+p
         CxJ8w9SpUnvWs4CBm7oDGeT4+hwml0Sy35emOMCxLH6ag1fgiFmlJhXLy/zZe25zoqh1
         5VWBGU+8s9KxMGry6yjqHpOhVihuXGwxbIRiULeWJmgNY78K6RlKSv84PZ/xEkcCnIV+
         A0QwQyapvDMTwowokBODBzrkaRhNgDfeXPk4FWHwRTRhBaVL7kRW0+LfK4g/f60QarHg
         3ICzQ79HH0DN/RiDeq9mEAdHm7Gee+eYiVOOpWR8JdiGFHuZu6OYJln8fQdtVroD7WAy
         DBkQ==
X-Gm-Message-State: AOAM530q/0cP6j+f7G9zgEr5MlRQgzMLQISXUepRb7PmggPwj3vojvsb
        bIvXT8edH309rHD/tz7MfjFmSMOgFAxxeQ==
X-Google-Smtp-Source: ABdhPJy7tyWSWkX0s0A+31hlwGVmMypbjcxRw95hLMmJZy+aH2CWcsi//xfOdxOvC/TLxjFHRR9iQA==
X-Received: by 2002:a05:6000:18ab:b0:1f0:1581:fdcf with SMTP id b11-20020a05600018ab00b001f01581fdcfmr1827618wri.490.1646134573651;
        Tue, 01 Mar 2022 03:36:13 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id o11-20020adf9d4b000000b001f0077ea337sm2108949wre.22.2022.03.01.03.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:36:13 -0800 (PST)
Date:   Tue, 1 Mar 2022 11:36:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
Message-ID: <Yh4FK2X+35oxevXI@debian>
References: <20220228172311.789892158@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:23:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.103 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 63 configs -> no failure
arm (gcc version 11.2.1 20220213): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/823
[2]. https://openqa.qa.codethink.co.uk/tests/824


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

