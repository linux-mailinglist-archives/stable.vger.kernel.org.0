Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9373CC218
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 11:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhGQJDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 05:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhGQJDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 05:03:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69610C06175F;
        Sat, 17 Jul 2021 02:00:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d2so14916307wrn.0;
        Sat, 17 Jul 2021 02:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4WBgWeaMLZJIrM9raMss1P6r0reF9dkILqG7ojNBzko=;
        b=NNDpUDtkt6LL9apPwP/8RMJDJoRevij8QcbRmhQQNFu5RiItn3DxElcR2LkyEa4GxL
         wXJhENGdZYVLB40hSvMC5GyfrnTrVNRhLQ0rC+f7gV6lx+AVIb4pq0gv03i17JkP8Z7b
         NAOnJFU7aVAPoZdE/78ZqwdD6V31rCCRwTAQflZUI9Ch/Dzz1Ivy0eVRtTlGzkmM4Qv3
         sbTLMd+pJQ2jBYI7hdKhFhmnH+Uf8jAPFASo/b0sjJ9rLAJthkU0cn3I2p/V3+lpkkig
         sYwI+9BDFnKdsMtYyWd64rB2XT+24oWZ3IgIfvW4a47lLoKYppLNPRFsO4yliOVc1/KR
         QhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4WBgWeaMLZJIrM9raMss1P6r0reF9dkILqG7ojNBzko=;
        b=iTxQYXXY98jkgrKDGJWxXVI0+0dqFV/8k7eBt7/hq7oHMB165jMcMkx1NGzspgFPee
         3xKwRDsQr/Yn7reRq65zCF/O3SPYA/WCkejajhRDtAQjsDA6NTarkjzPOK1JhN8+oWG5
         rbWNAxySbq2C+P3hhBpACPJjV1bTHJLpf6TuvZzAsOXL33A3ZMrUEf6vVnqJ9HiQb2Kd
         zwXuTjvbzMbiem5mPL7JhWBR3Hnf/pLFZHXkySOvi0HPZNwFxFms87UtkNMgw8fTANBI
         HQTSuLIPN7k+r2KhPpSs7ZzdyuZ2Rgb7RbjKY8y57ofnJC1DyQl6WF5z74diYgAvky2q
         EfCw==
X-Gm-Message-State: AOAM530OH6ygc091O3gGHAIAiDEUmdNLawGJQkd+74lIWeXG/VIcT123
        LwuoTc3uoMIjeFHkKcl8Uz0=
X-Google-Smtp-Source: ABdhPJy4GFYCcUuMwtsmIKTGMWYd7Lpni9zvZgmSB2jkwTo5XtNFNMBRwIZr8zCj+hTasY4v+wsksA==
X-Received: by 2002:adf:f292:: with SMTP id k18mr17529363wro.265.1626512438047;
        Sat, 17 Jul 2021 02:00:38 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id v21sm13548973wml.5.2021.07.17.02.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 02:00:37 -0700 (PDT)
Date:   Sat, 17 Jul 2021 10:00:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/212] 5.10.51-rc2 review
Message-ID: <YPKcM92R2bJJDOnG@debian>
References: <20210716182126.028243738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182126.028243738@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 16, 2021 at 08:28:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
