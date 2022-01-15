Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E77A48F677
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 12:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiAOLEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 06:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiAOLED (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 06:04:03 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D593C061574;
        Sat, 15 Jan 2022 03:04:03 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f141-20020a1c1f93000000b003497aec3f86so10548943wmf.3;
        Sat, 15 Jan 2022 03:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yw3PuBhpnWk465/slIz9ay5VHPk1ugQBdt25BvgmcbI=;
        b=Bf3S07atOKuDgtWRLYnFPxERCLul1tVCkbGUop7qyyEA/kLUwwDmz0tigeSr9e64vB
         iPLr6t0ph9b4mkTEKob+2EZ2Zlshb3pq0r3Vb3o1Y9o1cVh0pON6BqnjtDfz/H2tQe31
         ojwL7gFsFnmU42DHcgMTNigxzRsGdKdQy+QGSYEuczjhayfI4Tl96t140feDoZ8UlKqQ
         qYaZGWq+DXYLGjuZ1nytPZDxJUrFhDH35vJUDFuq+uzBz87hjYXQKHx2rbTfNsr3F990
         2fMKOWDHgjNWYuGjCScO3YOdpLJWCd1z+yTfCm0neUyZG3d8X3XxcpvJfBDaBsXSdd5z
         fk7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yw3PuBhpnWk465/slIz9ay5VHPk1ugQBdt25BvgmcbI=;
        b=LRXnAKXjSppwp3VWB/8DOnml0/vmmxkkpfnl+0/ncF1SovbO++Zco6chir89zsGhP6
         Mckzq3KeOZ6wiFjU0LuXyNgl7Efd5+Kn4qwuYa1xkoyGHeQJUi/0L7BZaYOzZK6NnpSb
         7B7tPTD5NxWY5pt5yDPg7KJScMU4T+wnDoC1qzCSyTv9hV85pnDjox2Iob6IAiMh1R6V
         6BzGfGnERn0j5hQ4Kir2BALlRwqKBEkQI7vYAHLapRyzq6uUBT3OeyK+XT0u2zyNkK38
         W81qBrcP6oieALlj/sRJW9SCI4eTa5snR3cn0OH3VD5nNgpC+G/RBLd3cjmu/9J5LlHx
         weYA==
X-Gm-Message-State: AOAM532qWg7chm/nQX6URlf0VNYPTHorZkG+uvDUh2f3b7HWw7fE1juq
        EBkB632mJ/GWrbLqzRnHvD0=
X-Google-Smtp-Source: ABdhPJy0THKGpNqKpNysTSoRafuptYoEqLMxvF86PX4JLb3YHTSklKX3M1NZHZchYpZpHaVXZ8zWEQ==
X-Received: by 2002:adf:fac3:: with SMTP id a3mr12005953wrs.369.1642244642026;
        Sat, 15 Jan 2022 03:04:02 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id j9sm8320092wms.0.2022.01.15.03.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 03:04:01 -0800 (PST)
Date:   Sat, 15 Jan 2022 11:03:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
Message-ID: <YeKqH0BTgf/P0ytf@debian>
References: <20220114081545.158363487@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jan 14, 2022 at 09:16:00AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220106): 61 configs -> no new failure
arm (gcc version 11.2.1 20220106): 99 configs -> no new failure
arm64 (gcc version 11.2.1 20220106): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220106): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/627
[2]. https://openqa.qa.codethink.co.uk/tests/630


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
