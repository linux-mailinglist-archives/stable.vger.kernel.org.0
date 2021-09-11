Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64012407936
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhIKP5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 11:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhIKP5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 11:57:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA137C061574;
        Sat, 11 Sep 2021 08:56:31 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so3663239wmq.1;
        Sat, 11 Sep 2021 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DKyQKF0uv74AcDVWwXo9ZcVNn3jaA6qhslMovLjMdsU=;
        b=GP9s/mawKcOPO+C1EVJzBJSqCs/qAjhLsBuxKA+qnaW5GSw6W/jpi8J5x1l2Ha9GGs
         60JMjPqB/BQb6oB11rTP8RmyctZiFVZYLYN3xxwQjuHevzeKFmkOj3en15cjJee/XyDf
         vo6q+bkUMiMDjJ6fJptwZM2fZd+ANWte911/2ADbGkLiyn6lNjKyWjif0cifnKt5NZBj
         1boGXqVTQlJSeDNfH+3wAIsyz/2ca5wUFz8tJD/nPOtJ+KWvoHjtCaCA2E2yag7gp7gu
         JRJfSfliz/Svu5jJfuoq0/OQBSYPXtRXULWj3tU9fAPDl6SzzVLxusLYc0YPcdl1WMM8
         aE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DKyQKF0uv74AcDVWwXo9ZcVNn3jaA6qhslMovLjMdsU=;
        b=Ud5wnXdvjfy+XIQCAjc+EKYL6n2CAAab8k/8e2m68Y3EtptuqzGYNfGpfxODBDITyA
         6AREw+kQCgaeZtiH/stJcfOESW6WUMAgo/iVDFJ7ZbS+opcEbPHgGnr0wnVyWK6jKjgg
         ZMD/iMdQXY8qH3pwhI/abv044LsYm8qOMrR6ufdl5rSkd7nxw1WrBwVlzOTt4kYfKZJh
         Q+n/z8oGpGhpdCPjt0ETHdAjbjUvRdo78uqPhAAFPdfUpMHCpN5IjfiaOX9maaJCQC6E
         oTt8U48m1BtaICDF1nR3IB5Ti+/LyQzduDDFJQTnuhvXBp3Ls1Dx85rgGazr1UHmFd6p
         nwXQ==
X-Gm-Message-State: AOAM531BbsYs6HBFcUPp2T+YeAvX33CAFtzZxw3LPUpSYWxR9q9XkUUx
        Gs3ePBSWmiSy7uold2Ekfx4=
X-Google-Smtp-Source: ABdhPJyK9LShW9xZOIoqGDprdLVAS7nwkzkpWVnVaSfZzDDZc7wEXAovSO1w0/wphl9i2BT2vQesww==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr3104298wmb.112.1631375790286;
        Sat, 11 Sep 2021 08:56:30 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id y9sm249592wmj.36.2021.09.11.08.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:56:29 -0700 (PDT)
Date:   Sat, 11 Sep 2021 16:56:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/26] 5.10.64-rc1 review
Message-ID: <YTzRq6DqWsGNiBJv@debian>
References: <20210910122916.253646001@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Sep 10, 2021 at 02:30:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.64 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/119
[2]. https://openqa.qa.codethink.co.uk/tests/120


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

