Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962A437A391
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 11:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhEKJ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 05:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhEKJ1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 05:27:35 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B348AC061574;
        Tue, 11 May 2021 02:26:27 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v12so19373027wrq.6;
        Tue, 11 May 2021 02:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BIOeuCtQZkr2Vb55BDnqvinEHwuMmbocPghkVdw3hkk=;
        b=D4ssoRaOEWy8DyyiG2MoECnHDRLw2pTd7bF6ihkM8s6P49Lrq4CM8mp+TwPCIRg7M5
         KxduJiN+iR0/zWHQGdNNt/Yv41dElZnySirRAv9OsZutCfUI+zJL8B2cviEcP59hUz8V
         5+1aA4hG+UjQQfaWkv5d4o4fEzv3PjVRTGhDRnLhesQomSNTl332v8j4tWOGxZ+yFBQY
         mwLexPfGc/rDg1chpEttOsSGvH/pLtWn5IkHpZ/DCixDuJI2kMbN4Gvi0U5Q2Ta0cvRz
         la0vZhZVRRkpce5JUKJQ/qLQlw1PdSlnVJ9EdL+DZ0NOzNRFxL7fPESMl0J9XpTo4cxP
         1WRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BIOeuCtQZkr2Vb55BDnqvinEHwuMmbocPghkVdw3hkk=;
        b=PZsD5Uz0/rOEPhxn1egHkFnRZbFp+r1Yj8otpbVPeyOWjY5PErR3pyiZK41lyP8EIk
         I8vPLNoX6IwEU6gnvcuUrmpbalx2qE7acIDE8fYrg11P/y7RM5evho2ju8y8bOHzDXTB
         1R8aRsy/tqM7AzPygS/sKhWAUu+XesYPm8TNMaH7NjvXZlc2QIpoiZRgQX9MQS85QMA3
         jdxwoqRTA5Ke4Txxg2Bo59Gac4uGiAqKeLSAM88LH52GwdWnKyg7d6eslETfqvVWA/F8
         NVuOqPBFvlTTWvvj765B98xXXKpv+cZBwlKn6JoBhtuiggPVgCXAtNBe4GKV+VYCL0vn
         BYpw==
X-Gm-Message-State: AOAM533D9l/pfFWXq6wvkFvGITQXD8D4Uogf8u+spa1pFcIE6LQByQtK
        pgO9blnpoeaFH/L3iJoC17I=
X-Google-Smtp-Source: ABdhPJw2xZdUQzKDb2r0gw083nYYn8D7Y+aW4b2rRtQGKEfUcR26+ni71Qk4f/O4ndfp0B1cjij9hQ==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr37218636wri.41.1620725186426;
        Tue, 11 May 2021 02:26:26 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id f203sm2812196wmf.20.2021.05.11.02.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 02:26:26 -0700 (PDT)
Date:   Tue, 11 May 2021 10:26:24 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
Message-ID: <YJpNwNcYk30BVqRc@debian>
References: <20210510102004.821838356@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 10, 2021 at 12:16:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no new failure
arm (gcc version 11.1.1 20210430): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
