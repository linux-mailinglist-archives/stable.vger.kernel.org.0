Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA313CF765
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 12:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhGTJY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 05:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhGTJW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 05:22:58 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C576BC061574;
        Tue, 20 Jul 2021 03:03:36 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f17so25361374wrt.6;
        Tue, 20 Jul 2021 03:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OIcANxhJ7Hzi5kMQjOO6J+/K5pkPWuwTP7TNo7gfvhM=;
        b=BN4HhCFX6r3RvdD9HkrUI0m2HGFcyIaskJVWLh+mCUuFZ1yM2Pe40gJWRyyqo2+Yc/
         z7ppo45lcSsIcro3snXchWcf1zuwsaSlvt3pA8Wa0hA4UkFbkLm48cNdauqmn3bEtM5w
         p5v7i9rphUPrqBCW6uyr7hdfH8qx3y6jaz4fXOypIYkpd+U6m/9YBd7tX8DnBhSNCq2b
         MjREs6OBCst6OuYQbO2lBAPaMzivW8+apj+oIT+VHSmo5IKtpRNQAdBUL1W/4ryWcf4h
         81UEi/X3BiDRtqN5C3PPOEGKxl+kO/NEjg8alNvsHHmvizajQqPOouSirOGULLPFBxsP
         soOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OIcANxhJ7Hzi5kMQjOO6J+/K5pkPWuwTP7TNo7gfvhM=;
        b=dFtl8ZHVz3LjjeA9WVmR2pm7vOCfk5xDeYqAPf/YT+3Te9CyNPuPbIYt43vg7n3KX7
         oHos5iF5ns0ShOOfv9c/X8sJF3YcoSzAN/1wUNT7NTkUKkgkpEDsU1CFdkNaiA9sety6
         oex56VZrf6Ejc8sE82YxNwc00MtwJOYlQkyAAAGHerHYTbLalkVZjWKOCL1QgvgqvoGp
         TI/2Igw8SCNspuTWph/Qs4T9LCO7xfdJ2/2S+QLsScsN4tiRU3OkbXLWz7p+Q0TngKpc
         C4yOL/QbktQmkZ3Pui/rY7aQF9yyVXQqzKls2RlzODR4qmztBwiQyIwKrWroVJDiBvDf
         oBTw==
X-Gm-Message-State: AOAM532HA8CzIG41CFe1WcCG4/JesQRdF6nVLeK6qtyRV27OFU+/KgXA
        Tq463iUykv728sSUsrUTa5k=
X-Google-Smtp-Source: ABdhPJymlNUEsRSX0duvNslXrxGhgeqdClttsjpXYq9XvZQvcJjeUj9C2Qlv7GaGW8GCW5/wmqjXcA==
X-Received: by 2002:a05:6000:1049:: with SMTP id c9mr15044384wrx.154.1626775415358;
        Tue, 20 Jul 2021 03:03:35 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id c15sm18906633wmr.28.2021.07.20.03.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 03:03:35 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:03:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/239] 5.10.52-rc2 review
Message-ID: <YPafdWDs6VgOeqEZ@debian>
References: <20210719184320.888029606@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 19, 2021 at 08:45:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
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
