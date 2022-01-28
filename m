Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3696949FBA5
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiA1O3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiA1O3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:29:09 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A21C061714;
        Fri, 28 Jan 2022 06:29:09 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so4210382wme.0;
        Fri, 28 Jan 2022 06:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cBSmv6ogb1cxiwO45LAPv1J5ovdz5y9xPUc2j3/AZeY=;
        b=CuWJuLyc6hZWPi10EE0eOFSkOZZCYkXImgtkRZpUaw7VImcl8LuS1ZDPiVfI3FGbvU
         kbyqx5ocCX+DEg3REQOw1Qe57WtFn4JJVkTulQyhc6mgSZQKpsrt/VvvmJyYA3v6GJ/g
         lXI/9Gn0PFl1AHYCMsJxiLR7AvhhtQJ9O48nRWnkPmpa+8n0y4kKUmUpVxi6pzbamCjy
         53J99lwhXFZBzImsDKTImK0pv8srfveMU7/glZPR7lGxSs4MqtOipW+1H9lMt7nspgWa
         WnwaRAy1lgOCv3qGrt5hqIz4jj/vlusxi7aPjvBYAuaI352e6PpQg/57Uxewyblfcj3c
         myJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cBSmv6ogb1cxiwO45LAPv1J5ovdz5y9xPUc2j3/AZeY=;
        b=v24ubdIN5YC11xGEEaEWcq3X6u7Aei712r5G8z8v1TWuHm39wPjplrZHn8lB3/QGnd
         xGTQukYIN1ZP1IfpnIV7ZnLhrqxcAHq1ITWKyJwKynecao7FWJBqdTRCWb+/BctI5FuZ
         JKraR9xf0xoDXVVuTRzQdRsrgtSf7AGr2aqAVym+UePYAOY7Rfsst6ntRDKbn5xaYyON
         xIxLHr/eaAx36QiOPQzg6+Cis5xdVjiaEjxow+qqLA37o0EF65npqr7iM/Gl7HKzEf8E
         3TEEs0W7Kh3n8fGBgVoSg/vfN1z6LqC+ZtJwDsDJV5gXwOhQTzvFXhC/a3HHoM8k1Ygd
         BxsA==
X-Gm-Message-State: AOAM532l1OaEd9VdZgNHZX9MMefiUnswRQY2xv2Bp2V4FlB33hHGm36j
        B0vOorrjTtNKUSspZOftW5s=
X-Google-Smtp-Source: ABdhPJymsXJu3dPTiIpIW1Di6atglsnzDkCxFVcyTEm5EVMM/m2gt/4JdaZU5jWR9wywus94/vWalA==
X-Received: by 2002:a7b:cbda:: with SMTP id n26mr16464409wmi.76.1643380147986;
        Fri, 28 Jan 2022 06:29:07 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id l4sm5507162wrs.6.2022.01.28.06.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:29:07 -0800 (PST)
Date:   Fri, 28 Jan 2022 14:29:05 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 5.15 00/12] 5.15.18-rc1 review
Message-ID: <YfP9sVf9skXfXfH1@debian>
References: <20220127180259.078563735@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jan 27, 2022 at 07:09:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 62 configs -> no new failure
arm (gcc version 11.2.1 20220121): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/667
[2]. https://openqa.qa.codethink.co.uk/tests/671
[3]. https://openqa.qa.codethink.co.uk/tests/672

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
