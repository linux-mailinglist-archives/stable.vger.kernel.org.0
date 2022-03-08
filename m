Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A64D1C26
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347936AbiCHPox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347932AbiCHPow (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:44:52 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8A9369CE;
        Tue,  8 Mar 2022 07:43:56 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bi14-20020a05600c3d8e00b00386f2897400so1629494wmb.5;
        Tue, 08 Mar 2022 07:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AJRitF/p4zByboh2CpTHKISZJ17qvotPM0CQjMqJsrQ=;
        b=XsIXVB6zBd0smwy78oq9ctkz0X2vSIQBpYWbx0Ln5DI8nPiifgzCULwfPmpR4ih58f
         8OqEhPcMmCCoGeuSlrOMfabTjRt/LozOgD9pnqMk0gZ0r8VIw4N3O04xLLTHbVZNSHgN
         cPcu+mhz/dueYgFBZWXnnlviUl+aYxIoty302+pYByvv1dK7YBkxxtn5zsk79Kz4MFFa
         WOxypNbTAmUCiadDRaFmjqkyiUM5ivatndXA7TXyRAJ+vp1fBM/5wA0y8TeCseVOQ7Kg
         g09E9rYb7ierdp6EfrOLx+98nPrNEPj7OnN3AEuUMrJxNiBWtQ2mpex/HPsy9WOlCbn4
         B2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AJRitF/p4zByboh2CpTHKISZJ17qvotPM0CQjMqJsrQ=;
        b=RMqxtvjMb6rpQhrKDYnxOffitEDfmW4KznrX2kL0rPMwR6vqmEt4W4xeYFNBOCSzZb
         YqOSPPQbDMHRpqavMXCXEnh9jY9HzzduEIdQX85oG6BaZ+BLqk6x0AspR8nPd0yavs9x
         G+KCwUyLMrsCUsL4WFWcB5MSsJFUA2qZ8FBGkPdzpCXsa+8aEBrjSkHmvDd5nzXJpHtU
         4aPNP6uvHYJc37kGQ0WHavlm6fv0rAj027nNA6y+xx6MlC4io1YFihnEbJvjxTcxIgOG
         GESUdZd1I361aFyPERJiTlj6zFXjqF8+Qr3oX8I0y8l0yM4GLhRSvhcN+oXVHc4W9BmG
         9u6A==
X-Gm-Message-State: AOAM530fAdF2A+TMwMgoeOangNe1Ig6aUtCQXAWknVGYdJ7K7Dn/d1KG
        FnPUEwrdgylhHm9r0YoSLIw=
X-Google-Smtp-Source: ABdhPJzneWr9k9p6+HWfv53D+odwclk7e6Q3AyN9edLaZ3VS2BqNgkftWqYe1Mn728qYvMPa7I1yXQ==
X-Received: by 2002:a7b:c11a:0:b0:389:a2be:2a5a with SMTP id w26-20020a7bc11a000000b00389a2be2a5amr4115380wmi.25.1646754234748;
        Tue, 08 Mar 2022 07:43:54 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id f8-20020adfb608000000b0020229d72a4esm2722545wre.38.2022.03.08.07.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:43:54 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:43:52 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/104] 5.10.104-rc2 review
Message-ID: <Yid5uK0TrymfoKLn@debian>
References: <20220307162142.066663718@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307162142.066663718@linuxfoundation.org>
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

On Mon, Mar 07, 2022 at 05:28:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:24 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no failure
arm (gcc version 11.2.1 20220301): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/850
[2]. https://openqa.qa.codethink.co.uk/tests/854


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

