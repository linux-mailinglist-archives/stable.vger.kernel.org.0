Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232DD4C8AD2
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiCALc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiCALcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:32:53 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0874831F;
        Tue,  1 Mar 2022 03:32:10 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b5so20062652wrr.2;
        Tue, 01 Mar 2022 03:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4GIe3uUVxEnTlUQjwjwrGN0rH/SNQXEEB09+dyoNVP4=;
        b=keJn8RUOdYY/YAmC6qOnds0+QFnRFcaFVSyiRHwcAHvA1YtDjj+OhmcMHyu+VyXAa3
         V9YyfNjywGc9KDbBab++i4eGWefKvals62lS2XMgjIbYInKJk6tKFzPQEJgvBsvWr5TK
         rTsDa9Zg9M+u7w6QQ7w/T4CF/dWLEHKPlc296WmRaR/2HPNUnpAIaA0AUi/qzWZJ59JZ
         Mn8t0jecFT7HYS2frRD2qsuqV2amj5Jgnn8Q8rPh1O6OVk3uDxKJWVL/PNJ4z22mnanO
         Q3wxuIEOnuN3JcdX+anza4TdK/b2nYvSrVyaR62plJ0q/AHvLCdJQ36v8jOeh8IStHrR
         vtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4GIe3uUVxEnTlUQjwjwrGN0rH/SNQXEEB09+dyoNVP4=;
        b=HXGIU3tddLidrPZvRnlIVNIToUu/hLFfTMn9oPXhlIh8Fdsr8xyz9yxrLq9fqxHc03
         Zu5+v0Kir+KgcCFfNlWyhqfDtd70OKyNjls9cvffjBJ33ZfRuYpI1WSLpoor8uTZMMOH
         P1uXx+RDlyq44wzRw1CzwbqarFK2w5rJqKZAEh83q2CgtGsrjMuG7RBZqIL8RjpTPpPK
         /LH9Vwo7qx7N6U0+LcyORqeCEEKeDvX+7IBBTE0qk63k7p2FeiBHLFUwqWIYcoalrseV
         LTFafIpBxnXS8gBAhVC7fCtyGqxjeMWmgLcasf+s58cTwcuGXtSQELPBXi3b4Ir8sJUE
         ZJwA==
X-Gm-Message-State: AOAM530Ngr+11GQQLq9oUvlCcD0bolRlwdhBLO2LBavjxt631vQ73xFk
        69Ib5lgoPgcUBx0DKsBuc0M=
X-Google-Smtp-Source: ABdhPJy9YNrTjW1aIvoot9dCqpltZ7XbRqQFZ9a026M96U2B/L0KdUl69wfhjvj6OLMd2p4w+0Xdzw==
X-Received: by 2002:adf:f611:0:b0:1ed:e11a:67a4 with SMTP id t17-20020adff611000000b001ede11a67a4mr19226342wrp.215.1646134328837;
        Tue, 01 Mar 2022 03:32:08 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id c4-20020adfed84000000b001e5b8d5b8dasm19151972wro.36.2022.03.01.03.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:32:08 -0800 (PST)
Date:   Tue, 1 Mar 2022 11:32:06 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/34] 4.19.232-rc1 review
Message-ID: <Yh4ENsU3fjdf2Sdy@debian>
References: <20220228172207.090703467@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:24:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.232 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 63 configs -> no failure
arm (gcc version 11.2.1 20220213): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/819


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

