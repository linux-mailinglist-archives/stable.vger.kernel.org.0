Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791113E34F8
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 12:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhHGKnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 06:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhHGKnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 06:43:08 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC7C0613CF;
        Sat,  7 Aug 2021 03:42:50 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k38-20020a05600c1ca6b029025af5e0f38bso10681276wms.5;
        Sat, 07 Aug 2021 03:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jh1cGoRe6XZ0CTMV2qnMAjtdzLuvCfx5y1DOrhUr2OM=;
        b=IXHQ2ROHVkLerINWqyH+BaxNR17a9r49JhKMR2Rtx1GiAMc7CgBgZkmvMM5EdMpLv6
         gAZApsimtF6yyw2vLwETiofBTwsuu7RuNH41eElE1kKhN0NEnNnq/pslHCnuCVIGbewF
         3tybuQ3SFUDLcVCgAjWkfKg8jF4j1cSYczf2QAtzRj2S0kaxKNxOGfyJNB5ZnXD1a5P8
         kD3vD5riGF7OEQfAVEDLPpFkoLznLBK3aSahhRni1jQDChM6YLQb6qS34js6gfQ9ZAjA
         m9AzK3Lwz5s3G2ZrpwoAWUPPw5Zp2/AF7ZRPn0RnC1lXXXLbCqgkNmn+y5/6hFVfyq9Z
         26Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jh1cGoRe6XZ0CTMV2qnMAjtdzLuvCfx5y1DOrhUr2OM=;
        b=AhNEsktXMaUDz0yJ5xQRNdp0IWnSqvCEhGEqdOG25Xq467JGIezz103M2j9xdGg6j7
         0k3mamQtKCYIRF4qsqTO8G8aiiz4gqxcmYcWXNKfXB08/Blkoq/HK+bYGmufNyfXRylA
         rpSq8dnFukHBC8teBrk33DT3ub6p8yVtvpK2RK8Suvq7V4q374ezqTSbZoscr903/XkN
         LLm66qHig+jxp9tkr1Ovq+gy7DKaGrSnnrLe43p65xWQleCAS3mB0JsP23FgMdFLqZex
         qrCEfEXqq6hHyIqsUIZNrA76f8TWXLZTcG0PxqNsqGwmFEie75h2SANXFlOjWeHOZQM3
         lpUA==
X-Gm-Message-State: AOAM533bwCO25Ob0uVPFoG0db6H6LGOJxhmID4I2ShQ5icEbtsbisJOj
        PcbNiWfbYI1oqsobiYbuj6Y=
X-Google-Smtp-Source: ABdhPJwqHRHzUkrmcGD3/x4kU4SE2Tl/CcP0nGlNNPD5TdcZn4j6S+y7rM4Z9MFkQ3RnA20Oi0NMmw==
X-Received: by 2002:a7b:cf2e:: with SMTP id m14mr24356887wmg.95.1628332969378;
        Sat, 07 Aug 2021 03:42:49 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id x9sm15317513wmj.41.2021.08.07.03.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 03:42:49 -0700 (PDT)
Date:   Sat, 7 Aug 2021 11:42:47 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/16] 4.19.202-rc1 review
Message-ID: <YQ5jp3zP1wDxqKpF@debian>
References: <20210806081111.144943357@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 06, 2021 at 10:14:51AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.202 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/9


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

