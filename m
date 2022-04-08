Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AC84F9106
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiDHInh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiDHIng (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:43:36 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AF1B715B;
        Fri,  8 Apr 2022 01:41:33 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r7so5011354wmq.2;
        Fri, 08 Apr 2022 01:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dfCYQu7CmgLB8rKRFQns8TyV6QP+zitRskspt0+l0JQ=;
        b=K1pMekFGOdimMyVtTVXkgYfIn/zbtSOmAhhCrI2ZdRFZkQv1b2l4yFv4IjZiJ1lajb
         JhTKkaIV3wlZ4wNKs4NnvFXyh098OG93vSUfehFZK8VLy4l47odNNVJyBzOzFi7fuKlr
         cijUjkNhMZPWTKshzj1e5TVT7E+unUJuU6JdkqJntVaKkuGem46++5oT4lOocn4LQAaH
         1msFblO9vada5GH9iXExyT9+vlgdi6+vq8sLjhuqsWro1N70okbWYvNw5gGZWfKsVzA7
         IBsT1T7OajaC82fCn0/45o5eklA1L1BDWOVnUCY4qS/b6iL+8qc4kWKD4YVPrNEb8wmS
         qYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dfCYQu7CmgLB8rKRFQns8TyV6QP+zitRskspt0+l0JQ=;
        b=A0/EUuoBV1NcNLhW/+5a0mAFcuzHr3YGLmN0GhdDg4rZbRjxB/j2SgkHzGLsZ6zjUx
         a4ocsqYAdnB+TYLMjkuXwOAaJC/pJesC1omCN1iZKfHebv+QlenTp/k3RAF1qobaHxj1
         ii61/X5QgTil0OG57qGgeI22YNqvGzLaWDt8XcEJNqphmHrAvziaLoFmlLNeqH6ONbGU
         ZD9RTUghcn4Uz5dryA5C+F8GrAkptbC092fXxaHlBl+PSFCZaQokDHJ6UjCuGMhVwSc/
         9ifqXgMWSN3zSGvfg3w6FgT18de235KBnPgSWu3iw/TuNNbxZmEyezAqfVUkHGTrocX0
         wK+g==
X-Gm-Message-State: AOAM5337EuUlvCqUttGPYtfmoLyqy+pwrJDHRV9z3PdtctmUMVQ2nMLm
        LIblirlWpbntKQmoUFKCb2d9Xgryyv8=
X-Google-Smtp-Source: ABdhPJzsEYgKwxGMQ5s24HyZ9x1MKdVXy3O3wp1KwFkyPF4e5ephcjVDIKBJRZ4j22AvwnPKTiQLdA==
X-Received: by 2002:a05:600c:500a:b0:38c:991b:a4b with SMTP id n10-20020a05600c500a00b0038c991b0a4bmr15668273wmr.50.1649407292248;
        Fri, 08 Apr 2022 01:41:32 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id v14-20020a7bcb4e000000b0034492fa24c6sm9705284wmj.34.2022.04.08.01.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:41:31 -0700 (PDT)
Date:   Fri, 8 Apr 2022 09:41:30 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc3 review
Message-ID: <Yk/1OihlpKRp/lO7@debian>
References: <20220407183749.142181327@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407183749.142181327@linuxfoundation.org>
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

On Thu, Apr 07, 2022 at 08:45:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Apr 2022 18:35:00 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no failure
arm (gcc version 11.2.1 20220314): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/997
[2]. https://openqa.qa.codethink.co.uk/tests/998


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

