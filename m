Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC63849D4DF
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiAZWG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiAZWGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:06:55 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BD8C06161C;
        Wed, 26 Jan 2022 14:06:54 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id m9so2259780oia.12;
        Wed, 26 Jan 2022 14:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zwoqcsJ0vg65f3tTKA7jtLvhj3RG6LVW4OcdhKsgerg=;
        b=IdhIABwFwt28XvOqZht0ZE7Or1Vdb4TB4bu1INnOfBnmm2yckAxO6zRUTb0WsEQKEl
         CF5jIf1W+rpf1fYYPIiENUfjDvDp1W5KxyKfsR15YHFVFg90tM16bXVItraULNvWb5lK
         scW06m146Ne2qGz1EIsUEUbXXIaL5gmBntl8WHi1FBBHS/DAE13FG4cBy3JzW4/VRnN/
         9iAcL1p1DIlG9xgHJ1Be5Ak2AigLxLhco8RZ1gThE/q/fzqdyOFoHpeCQukXx/ybcSx3
         xh3x9/lcgyw3u8qOtkt4VfERZmCteMid3Qgeb5o+zctUmqYd2nNHjoCvMCO7rWdvQCiz
         7cPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zwoqcsJ0vg65f3tTKA7jtLvhj3RG6LVW4OcdhKsgerg=;
        b=Ylfe47sW1z9tsn44VhMPyaM1Yl9bB5cE7Rxb8Qe9pYSwnyJI5hnRDNQu/9XU6/k5v3
         08jWEI9Z3PnScTI/T0jYJxuUdLJGMZ5i9eND0/bMwRdmo5ME0gxM106gHX2h1OqU4rNv
         ztKTpHa1qeUNPpBwPrr2NxU7xDK1SQT+NUKii7kBHibzTDe/kD/3ypmQ0djDu0uRmxJh
         +7/rnXDHuq3Gc4AEWJ6MPnccjEwaWFlk4HTbOXbu/Y/x8LuR4AEnimiCJiZ0s4N/oAFj
         lH5D+UkC0AIAGsf7dpagD8MjaqsxV2japhSfa305hZ9TRn6tpcyCwP0i7v4tA2N+u3Aa
         49Lw==
X-Gm-Message-State: AOAM533NybNXF2tCGiFA6JoorCFLhqK4qJ6KPIUbXSD7ubu0eSaGnzql
        +3T+yqHpLMWGxhVa7DculGI=
X-Google-Smtp-Source: ABdhPJzG4Kv7yA2ggalicBmyyqdbIPJ+T79pnfYQpGlr+t1NNMeM3OvzgPL+cG8xidM8fGoLoHjnJQ==
X-Received: by 2002:a05:6808:a06:: with SMTP id n6mr463445oij.45.1643234814311;
        Wed, 26 Jan 2022 14:06:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b8sm6700208otk.36.2022.01.26.14.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:06:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:06:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
Message-ID: <20220126220652.GA3650318@roeck-us.net>
References: <20220125155423.959812122@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:32:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
