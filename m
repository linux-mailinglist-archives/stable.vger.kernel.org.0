Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516ED64B4C7
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiLMMGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbiLMMGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:06:15 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2437413D41;
        Tue, 13 Dec 2022 04:06:14 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v7so8142346wmn.0;
        Tue, 13 Dec 2022 04:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gVubB98aC5su9XRgj6h31J9MjnV9xAN9J4GbCNVjdOo=;
        b=a6X/z4k4t79rIe7sQwvswoYBPhqCERNU3l8fZBlWHRzxEapq3TC8fiD7jPSIWVRnPP
         rbdS+9tnQpVfhprQyRbzqQZseu7w2XJe4SK6RZQfeZS2Jc7fWCK4niL7NstRzdacdpm8
         OST0JsKd3RKJ2dIq7DNXAZJf6MOcowClzlJwGGaqnCAr2p6ZKW8oMe+TSg9i8g6IR36y
         d+awhS87n+DlDZTrosCYGptguV3ey4YjPupDEuMF+xaSB0X18/ommGvrVj/h8+Nql/SC
         rsunzvB7nDAYhrI5Dg6tyCO+nSiIQWuqRlvkiBze3yU0Nz5LhFruUdlzQ8qyTu9CH/VB
         hpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gVubB98aC5su9XRgj6h31J9MjnV9xAN9J4GbCNVjdOo=;
        b=DG8/tTSvLWYr5fLOHOdWowVTpbc0HMFt0pFOojmKItsfIF2il6JH/VHSKH9KQMgpjD
         0OOubN0QSK2CHFwiwTimJwxxPsT5ztso6McRA9sqyJZRkDPLr9ZT3KLEwsbD1fcYMs0Y
         xt4nhR7BQmcu4zQ1PwA6kKB991uzZDUFnKF4rjPB2MM8A0SuUQedRatPl21uSO0egbmo
         lu/0t7JboTsOHh0jpV9ORfsFX2cjCQ4zegYluUQXhG2wqMrT8dEtI+eKmYWT2j8S0u/3
         8jbf9InhRbnnnWwARXYTtu/P9Q9pBnjDi47hxYiQ6Mn8NjhmB+9d0UXYFTYGTpWzj9TS
         B00g==
X-Gm-Message-State: ANoB5pnKpjEAhXWyrvUQjwDsesHsmqWIa8SbfkBIlBowYFlMPkQWe4l6
        ZP8+4i6IdR10NHlTLorN9yM=
X-Google-Smtp-Source: AA0mqf7ruOX1+MBiqRj0uUe+3LlgQTYqSwR8fKMxdn8mBnTIsTKbbYK4cHWVmkXXdSTgJxctKo6Gvg==
X-Received: by 2002:a05:600c:538f:b0:3d1:d396:1ade with SMTP id hg15-20020a05600c538f00b003d1d3961ademr15464987wmb.9.1670933172607;
        Tue, 13 Dec 2022 04:06:12 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600c4fc300b003cfbbd54178sm3234923wmq.2.2022.12.13.04.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:06:12 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:06:10 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5hqsggURI1Me1ik@debian>
References: <20221212130924.863767275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
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

On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
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

arm64: Booted on rpi4b (4GB model).
Regression noticed:
Failed to start Network Manager

Will try a bisect and find which commit caused it.


[1]. https://openqa.qa.codethink.co.uk/tests/2339


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
