Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3054C2B546A
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 23:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgKPWbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 17:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730313AbgKPWbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 17:31:51 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDA2C0613CF;
        Mon, 16 Nov 2020 14:31:51 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id l11so15307407lfg.0;
        Mon, 16 Nov 2020 14:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iSYKumRzw7eYrCW4RMOKX9kdE0Zs7ymFb38Zx2Z3008=;
        b=uV91XdhqSZGDi6joKFKhCRH4M1G928Du1MQaGuPaFF0mk4tv+t9PDhs4Hc6WME/Wvs
         Iyj8pFN95Ew2qCO5AgKZvcn1iHTtbTSWCJPqIvVf5SkKTj6m20lWM4OAZttUo8fuey0z
         +ScktwRElsc/yRnblEvUmmJVctjYY5L7EbQKeS6mTmWzmoDCav+AjqcP5T6LmcFBLgzI
         d7f5E2Ut7KDiJYYUVtZgXFb17xIq2fibojG/LMBjE3SSyKB7WXBPZeCqLG6/I8gDS/Fv
         0hVzQyQe0LNwEeLMqedSE7QOVf7y4YEzeW8sIR0EToYS19S/XAQYQ5e7A0P+6NfgnrtX
         7VKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iSYKumRzw7eYrCW4RMOKX9kdE0Zs7ymFb38Zx2Z3008=;
        b=GB/0FWpNeqnwwzdOPITmEUQSmaSPasve1khe/OvQ6zSUds1wAfDWI/iEtxtS2ABolg
         U8Ss8WXG9MF4lhW5c0LU1gc6mdZnkY+CTzJsurHNbEoNMCnUYEpftjHtJtp0AutifaLu
         /v0gwaD+pvQm1Vop+QpaXvimrQNsHqAw1KWOh2paNef2DP+LAsTccWjqwwMWl7/eUUTK
         eAN8O48KWXiOAyGSTVyK9PxUlUq9pW3qeWUMnyZuitNCR1dOqEq6+Kq6WCVBiTngFHnT
         nXEZ6tWBueoxulHNzZGECsEIR1lZyUxm0wNYlxoVNY7IsR41+YMNKKcnP6+CzxvB+9uN
         ZGNw==
X-Gm-Message-State: AOAM531KukqRXqO51Ar+lXeUAqPy8y778CBeQeZUVmocAl/JKCrWkKx3
        ylrKf7zd+3JLsNntdDIspLQ=
X-Google-Smtp-Source: ABdhPJwr+w/3bZyj+XwkV9anNeh/Humh8Tbve+lpyWy+/p3m4xfKycR26U+SDJUW9ifhqxtuIG/RuQ==
X-Received: by 2002:ac2:58e6:: with SMTP id v6mr525554lfo.137.1605565909601;
        Mon, 16 Nov 2020 14:31:49 -0800 (PST)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id 23sm2946213lft.140.2020.11.16.14.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:31:48 -0800 (PST)
Date:   Tue, 17 Nov 2020 01:31:46 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
Message-ID: <20201116223146.cmb6myelohnlbw7y@mobilestation>
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation>
 <4c58b551-b07f-d217-c683-615f7b54ea30@nokia.com>
 <13fff200-660a-27b8-6507-82124eee51c5@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13fff200-660a-27b8-6507-82124eee51c5@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 02:09:09PM +0100, Alexander Sverdlin wrote:
> Hello Serge, Thomas,
> 
> On 13/11/2020 10:17, Alexander Sverdlin wrote:
> >> So IMHO what could be the best conclusion in the framework of this patch:
> >> 1) As Thomas said any platform-specific reservation should be done in the
> >> platform-specific code. That means if octeon needs some memory behind
> >> the kernel being reserved, then it should be done for example in
> >> prom_init().
> >> 2) The check_kernel_sections_mem() method can be removed. But it
> >> should be done carefully. We at least need to try to find all the
> >> platforms, which rely on its functionality.
> > Thanks for looking into this! I agree with your analysis, I'll try to rework,
> > removing check_kernel_sections_mem().
> 

> but now, after grepping inside arch/mips, I found that only Octeon does memblock_add()
> of the area between _text and _and explicitly.
> 
> Therefore, maybe many other platforms indeed rely on check_kernel_sections_mem()?

Taking into account what Maciej said, now I am not sure it was a good
idea to discard the check_kernel_sections_mem() method. Indeed it is
useful for a custom memory layout passed via the kernel parameters.

> Maybe the proper way would be really to remote the PFN_UP()/PFN_DOWN() from
> check_kernel_sections_mem(), which is not necessary after commit b10d6bca8720
> ("arch, drivers: replace for_each_membock() with for_each_mem_range()")
> which fixed the resource_init()?
> 

If you think they are redundant, why not?

> As completely unrelated optimization I can remove the same memblock_add() of the
> kernel sections from the Octeon platform code. 

Why not as long as it will work. AFAICS the octeon platform code does
some kernel start address adjustment while the generic MIPS code
doesn't. Are you sure using the generic version for octeon won't cause
any problem?

-Sergey

> 
> -- 
> Best regards,
> Alexander Sverdlin.
