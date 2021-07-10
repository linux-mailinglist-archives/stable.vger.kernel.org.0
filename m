Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4524F3C31F5
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhGJCrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbhGJCrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 22:47:05 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C78FC028116;
        Fri,  9 Jul 2021 19:33:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so7090941pjo.3;
        Fri, 09 Jul 2021 19:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=49HWs+ixRqF3ieorF0UDQZVsTzBIiB467SvhUde4lt4=;
        b=YUeil/Hofs4LLQMw2L0hjCYdQ5nDkQD8QDOBUJDRI8cqBlPJYLjxSuBzw7Qj3xt6Wt
         +ZDLQztaRpPittEEUV9rq2/Fx/4BOuh9ovCg1IlsN+IKEbVKJ2o3QAICIDCZ6Mon5iSE
         CDTocxUJ5qgy6zZdqPiDYpdK85yah8PqxCakK39ZmnvUu9WT64xKweUSuoK2KexHDxsv
         ExrGsftxn/Lva00tMwntLW86KwmpQ92/ncIlgXYHfFOiI3HDB3lbNPWIbMkxj5SeY4+H
         8cMoJ94qN6pxDB4D2PHpDlTK9zzahO5Jnb972/S8WWvNjA8QS3EAA/0yXDv919EhFRvG
         q/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=49HWs+ixRqF3ieorF0UDQZVsTzBIiB467SvhUde4lt4=;
        b=uIUXcd3FJjuK877KLXq7seiRcf14geJj0CYjDXgb609/7sFGxJxlvtGH398ssjw+Wx
         Eu2BzwsQBEAXTh7vCsgpDHTodEppk2NnhDAIG48O4CP192PE9NgJ4NQTX0VVoKblJvDb
         +/BQzYBVshB5+tK+bkt0FftdS6FRbyNzDK71LwXasP6aopTEwuOuglmlzKKN3uLPS0kK
         dJwiAPo0yko2+TtP+HCtKj776p8GTeHwOGSuss6AAGIPss6HYJgLU1x29B49xjllp8d5
         KO8XQNyqlHciN6X1BzysZdqxQiIAzBBQScfhGzcyQX8gd66txtaTK+REU8ByxXLQJk+K
         GEbw==
X-Gm-Message-State: AOAM533/Tw8J0ucUuSWQfb4fh6B7deHsVbsW5NSxFQV8EOy4R4gWXLxJ
        SXd7GEzUf0hD0n5Sqycu8lNy+hZd5AWneQ==
X-Google-Smtp-Source: ABdhPJwnOzEuKK3CNlelDD0Q4VoMYekxvzFlbaYLHTVlMCkxNJhzAOucZPosEb3GpachzeROCTwjbw==
X-Received: by 2002:a17:90a:1b07:: with SMTP id q7mr41480652pjq.181.1625884413715;
        Fri, 09 Jul 2021 19:33:33 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a6sm6613242pjq.27.2021.07.09.19.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 19:33:32 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.13 013/114] serial: 8250: of: Check for
 CONFIG_SERIAL_8250_BCM7271
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jim Quinlan <jim2101024@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Al Cooper <alcooperx@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
References: <20210710021748.3167666-1-sashal@kernel.org>
 <20210710021748.3167666-13-sashal@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b431c751-0a45-47f1-c5c6-7ca02581ad57@gmail.com>
Date:   Fri, 9 Jul 2021 19:33:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210710021748.3167666-13-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/2021 7:16 PM, Sasha Levin wrote:
> From: Jim Quinlan <jim2101024@gmail.com>
> 
> [ Upstream commit f5b08386dee439c7a9e60ce0a4a4a705f3a60dff ]
> 
> Our SoC's have always had a NS16650A UART core and older SoC's would
> have a compatible string of: 'compatible = ""ns16550a"' and use the
> 8250_of driver. Our newer SoC's have added enhancements to the base
> core to add support for DMA and accurate high speed baud rates and use
> this newer 8250_bcm7271 driver. The Device Tree node for our enhanced
> UARTs has a compatible string of: 'compatible = "brcm,bcm7271-uart",
> "ns16550a"''. With both drivers running and the link order setup so
> that the 8250_bcm7217 driver is initialized before the 8250_of driver,
> we should bind the 8250_bcm7271 driver to the enhanced UART, or for
> upstream kernels that don't have the 8250_bcm7271 driver, we bind to
> the 8250_of driver.
> 
> The problem is that when both the 8250_of and 8250_bcm7271 drivers
> were running, occasionally the 8250_of driver would be bound to the
> enhanced UART instead of the 8250_bcm7271 driver. This was happening
> because we use SCMI based clocks which come up late in initialization
> and cause probe DEFER's when the two drivers get their clocks.
> 
> Occasionally the SCMI clock would become ready between the 8250_bcm7271
> probe and the 8250_of probe and the 8250_of driver would be bound. To
> fix this we decided to config only our 8250_bcm7271 driver and added
> "ns16665a0" to the compatible string so the driver would work on our
> older system.
> 
> This commit has of_platform_serial_probe() check specifically for the
> "brcm,bcm7271-uart" and whether its companion driver is enabled. If it
> is the case, and the clock provider is not ready, we want to make sure
> that when the 8250_bcm7271.c driver returns EPROBE_DEFER, we are not
> getting the UART registered via 8250_of.c.
> 
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
> Signed-off-by: Al Cooper <alcooperx@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20210423183206.3917725-1-f.fainelli@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit is only relevant with 
41a469482de257ea8db43cf74b6311bd055de030 ("serial: 8250: Add new 
8250-core based Broadcom STB driver") which is included in v5.13 and 
newer. You would want to drop that commit from the 5.12, 5.10 and 5.4 
auto-selection.

Thanks!
-- 
Florian
