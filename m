Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBF049FB8D
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349045AbiA1OWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244873AbiA1OWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:22:37 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943BEC061714;
        Fri, 28 Jan 2022 06:22:37 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h21so11170342wrb.8;
        Fri, 28 Jan 2022 06:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JqRzFU3NTGaxRCA92BfkWdnqAUoHImOhqbYAAukL/WA=;
        b=CPd86gzw5vDG8e3dfC98RsYhQCjpLk76/QV+NaHGJQ3IfZC4FkflbJgRpCSQaojcyb
         Nu4Wo7x+p7NWc7YpYSOIN3FGIHjbuiitrmy3yxTQQ7LDee5Egst8KO+uLxv2eoVfD9QT
         ULTn3O4b6ujUTZGuG201D0sluLZRrZTGCqqiIta5Uq8jO1nAUT8X0XhzsTuV9F4MgFHO
         XPk0nEyMprAf/3SwRu9z1SULebl2A/wglW4U8DeBQaqhwDdO0wUVA4ZDM87kmxpozIij
         FNN2PW4+4Y9XxaTG0CehdqUTgM5V+E1d++lacIQI8v2KC2ooWvgVzPSYKhId/Mblvtui
         OVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JqRzFU3NTGaxRCA92BfkWdnqAUoHImOhqbYAAukL/WA=;
        b=nEDvQcgUBcqhL1Mua20cHGzOLX0CmAoZXpuuszetAk0X7wdwwlmEbGuOIb9i+Z3sCj
         sAQiGU/ua5A+esAVcLkaTI1y5owzZ4Q5Rws24CfEF3NzPYDW8HwhEY45Cs77Q2kEpXMJ
         4AUdXhZ0i+g5zwu3aNXFGymEaG+ZYKwjCls6kEbnKRBvzILSL8onJRfBytQU3FrsgYD9
         in92nL5OstAeLyfMXkze6mO0+IeiIJ5jzEOf6Cce+0aZeqqF6JqRxmLFEFNcdGK68xhT
         V/uDOIAxZjK+QFGb2x0LipYzzDdBJ7Oy6bJj0rl04kH1ZjMYeeuE/Nf62h7sfoQjSajl
         AYUA==
X-Gm-Message-State: AOAM5330uMGZhTKtk1YqT4N8xutfD5c4auEqSs3HQfoyykFKEgdj5yKc
        kD+ZxszS1JA6HVx6jEtCaQo=
X-Google-Smtp-Source: ABdhPJwdMzo9hv8rwPvTwETuZlhc9M5WtrrznhyCgNe9Nx+siLH/uQ6HBTw9LK6PHcpRClpwV1hibw==
X-Received: by 2002:a5d:588c:: with SMTP id n12mr7377461wrf.386.1643379756041;
        Fri, 28 Jan 2022 06:22:36 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id w6sm2003187wmi.15.2022.01.28.06.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:22:35 -0800 (PST)
Date:   Fri, 28 Jan 2022 14:22:33 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 4.19 0/3] 4.19.227-rc1 review
Message-ID: <YfP8KbSXrqL4HIMl@debian>
References: <20220127180256.837257619@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180256.837257619@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jan 27, 2022 at 07:09:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.227 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no failure
arm (gcc version 11.2.1 20220121): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/664


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

