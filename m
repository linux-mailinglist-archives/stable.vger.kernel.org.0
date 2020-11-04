Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115F02A65D8
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgKDOH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgKDOH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:07:58 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983A0C0613D3;
        Wed,  4 Nov 2020 06:07:58 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id t16so4909722oie.11;
        Wed, 04 Nov 2020 06:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VKQTADKWbwsUwSbsUHgL7+P7gK0ZiXSB4+VvuuMdBSM=;
        b=jpGEHr+5MJN5vDwibuhO42SDoPqOvGnNgZorP1yPO9/OySDz2V5ZJkHr7o5/J2H3Ai
         raBbAsgp3xYJORgYKPT0Qdc8qxzpxQf7UU5rQ489Cu8eA1Jh1+dLVHeycB5NQ5Ust73/
         CQoJVzc5J5co6jS+kjOFjHJL2eekh3BCDWkmHubOBHJXiUlHPKTi8ain2FRLGrMNdL3p
         JQpceb74yeHEp4FrZOQ/BxtdnrKJHTSUd7DXbwLM5oL1yYTLAFEzcJWrsP4MePxrq4dV
         y2UnaQhzPIjyCvGjMwFyD8KW6HmqowVkHbkBaksJ+AkZAWry02JY41ueXBtQttOEuCBL
         lpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VKQTADKWbwsUwSbsUHgL7+P7gK0ZiXSB4+VvuuMdBSM=;
        b=eKZqMfw+boSlf3rh5go0eEMbQrGi0eVf5I/twNXhGVWsGveeBViAYpD3vR7bCxl3V+
         Uc88scU4pBo4iqwX5EXTfOQFJLICEVT/hTDSpkBLtcjvZasa9HzNrlm4oD2Ti67qrELa
         kAZJTP+gzcoiD5KvmNg+KMUVQmQT58/47ZdWtkxwJK0jH+tJ5tfPlVTItr6zCANv3Zbf
         hPnsLIf6lLQhUNb1WZkszsd3ft1vQRML7YLQEtxLRU+f13aUXcQ3u9dg9CMTAHKcSAYx
         uB4GQrasOFQbI9yopZyWP9FEUbGheC3dEn/sufeyf5olgV0lvmCGh+h/1Xg/WBs9TVZ4
         EPYg==
X-Gm-Message-State: AOAM532joFJG7hLMHznirWmgKsAKsOpwNSopYFcYqmu1Nt3KR1gw1xNg
        21gtNtx4PCHAhwgSkff/FPlIhfU6UOE=
X-Google-Smtp-Source: ABdhPJyLXcamT3Lj3lRe1C8J4BVsWH5OjYiutEk2E0DoGlRiQVffdsFt+FVldwVIk7JTG72jG5bGDg==
X-Received: by 2002:aca:c3d6:: with SMTP id t205mr677887oif.10.1604498877977;
        Wed, 04 Nov 2020 06:07:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l44sm542751ooi.44.2020.11.04.06.07.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 06:07:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 06:07:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/214] 5.4.75-rc1 review
Message-ID: <20201104140754.GA4312@roeck-us.net>
References: <20201103203249.448706377@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:34:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.75 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 

All sparc images fail to build.

Building sparc32:defconfig ... failed
--------------
Error log:
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
In file included from arch/sparc/include/asm/io_32.h:14,
                 from arch/sparc/include/asm/io.h:7,
                 from include/linux/io.h:13,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:13,
                 from arch/sparc/include/asm/hardirq_32.h:11,
                 from arch/sparc/include/asm/hardirq.h:7,
                 from include/linux/hardirq.h:9,
                 from include/linux/interrupt.h:11,
                 from include/linux/kernel_stat.h:9,
                 from arch/sparc/kernel/irq_32.c:15:
include/asm-generic/io.h: In function '__pci_ioport_unmap':
include/asm-generic/io.h:1012:2: error: implicit declaration of function 'iounmap'; did you mean 'ioremap'?

Guenter
