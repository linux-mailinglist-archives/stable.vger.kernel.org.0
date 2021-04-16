Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4375736290B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbhDPUIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbhDPUIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:08:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB41C061574;
        Fri, 16 Apr 2021 13:07:34 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id y20-20020a1c4b140000b029011f294095d3so17144675wma.3;
        Fri, 16 Apr 2021 13:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vihkSYmvJphhBDW7J7mjcXtQGD/728BY9hGUF6C9ELE=;
        b=NWdjoFQ5V8e9Uhk67p2p21WJa8PyNVR7vJ8aEX/lyvgbNL6wAEtsTkB0eEs7cE/wfF
         xzrQECnUTH4N20KLuILYipoIbOlktcBCU98z0mxYCeZzTGrdGTdYwu6R53t0lJ7fXZZv
         yGHd0JVkxFlBAXCkBRsI7acf6FE+UhfNwxmZFiddoUoR5sWNj0sEeRS8rVGixF6Dtckb
         HT1TQ0S4EjXwAtia2yHwAe61UbXe8iLjoAXWe9LsKetFm8hInRbwDE4TfhZN8Uadgpjt
         GJMH0qXnlMDQbwGhoH6x/dR2GAa89kHZkB3+qmRCi0Wyi7cShwBy3Y33c8LKjRZxRjm+
         lSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vihkSYmvJphhBDW7J7mjcXtQGD/728BY9hGUF6C9ELE=;
        b=Z5MEM90OQwB8oUk8K0pgmRiYYPlNJfxiQ1/ZWyPFEoFYto/FRtF6EhVOF7Ipq4nvMn
         6esWFtq6esH7GzCXCRBuqXjZnEZ96qOr8i9QlJaT1U6KMysrY07g/2GLyf/O1f4xg/B4
         QG0hxwEk/Z42earRgZRHEPhPQNI+02gg2+ePqippNMaQvhWEUmYHkq/oAwGsgbCMz4d7
         lBIX3fNMdqDsqaBV5rY03AMrSu8NLlPrp2575xMGgwI5PvxtSiU+aOSMa1hXxsbJu6/M
         g2Yctyf74V4UsiHCFONZ8EmHABI2WkAer17GA1ZpZhugjeF7KdzBJ9eR4RVZINqzVPZV
         rtkg==
X-Gm-Message-State: AOAM532dXI2IdtwvSvfQQPZDbT4dBwGMLuWYLSkp6huxOaJQS8cYkfqm
        s+MKe8P9yjSnf+RdHN1REmc=
X-Google-Smtp-Source: ABdhPJxCVzQAyC95qnIF5LcQpV/Q5M5xrQF+TDnQ6dLf7TzgwC4WQ1eJBnsjmOrsz9yMBIvM0C7ueg==
X-Received: by 2002:a1c:b007:: with SMTP id z7mr9793796wme.14.1618603653621;
        Fri, 16 Apr 2021 13:07:33 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id v4sm8869928wme.14.2021.04.16.13.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:07:33 -0700 (PDT)
Date:   Fri, 16 Apr 2021 21:07:31 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/25] 5.10.31-rc1 review
Message-ID: <YHnug+uMm8QrATRR@debian>
References: <20210415144413.165663182@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Apr 15, 2021 at 04:47:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.31 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210416): 63 configs -> no new failure
arm (gcc version 10.3.1 20210416): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
