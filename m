Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0932FE782A
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 19:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbfJ1SND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 14:13:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37722 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJ1SND (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 14:13:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so7421999pgi.4;
        Mon, 28 Oct 2019 11:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7/YManxxrXMGA7cACVdmSHAatXDpp8qM6jzpbsBeexY=;
        b=JhyDsvpTchOiMxVkb7YsfkV5FYRi7ywU6edxD96DTLFkyE7Y9DihOEkVV20CHw8f+Q
         snB62JN12f5r6M81w/veOo/d2H/1yS11TsolCjiSzasH9T7BdktZ4CKeZFM4CrVUPc3e
         3desTUy9k1tiP+Yd0aEbDOGHnf01l/5ZMDVYAXCn/VX4wfjs+re6Pm7FVKSYjARGlZNd
         YUnARW0RVCUqoONMXPgXC98AhmrujOrXfWnwmi6g/SmsrNLZQteLG08z8Xh3Ztkf/YOS
         v+MzN/6r2pib4FnxYtRW0c2WmWSFWIh5lKdaqdoAiWOHAH4kkKngTI4QkBqkJmRNMier
         VMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7/YManxxrXMGA7cACVdmSHAatXDpp8qM6jzpbsBeexY=;
        b=dQMybcafo/WU7MreXIwhQWl0g1JBrvvlTJdey3nK2DbGMmT/kE/A4xwfTx2Q0YM/TE
         9LSDqSsjTVcDV7KQ7QOoBfbo4zjXP/G6fZm1CIWzBXpYxLvC46B3IRKOOmpXB9Kq9vkL
         WIGUOrK9NcEEvYPObD+xsU+62wJBXzEgevX2fN6CA2nxN+uR69dwaECzH80L/UYant9L
         jl6m4Ob1O1UA1lWMYGTJXwkVLN8XA9Wek0B0wOXGJXbS/NCF6JEUVN2BoOiExVHvUxVa
         BeOdtJcFLLApmrZZN4KK8MuWr0N34j9FoUjTC8CxzRwbcKD6UcKoBb9UQ+A8jvLaJVeX
         j/BA==
X-Gm-Message-State: APjAAAU6PXSnlLal3ME1UNVgNdTYIh3NPK9p8zJFueZ+alH7pRS0+jiq
        UUXet7Mz69cm0+TO9ytKcGNUNPu5
X-Google-Smtp-Source: APXvYqxT37Qs5qDMEEYQ89TSleRCWeDfazdObpqvImSAFVuPZt/n41i/9zLL/BPIwh8ZtGoPSLXt5g==
X-Received: by 2002:a17:90a:f991:: with SMTP id cq17mr796327pjb.30.1572286382386;
        Mon, 28 Oct 2019 11:13:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 19sm185492pjd.23.2019.10.28.11.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Oct 2019 11:13:00 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:12:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
Message-ID: <20191028181259.GA875@roeck-us.net>
References: <20191027203056.220821342@linuxfoundation.org>
 <3961082b-17bc-cef7-f0e5-7bf029b2de2a@roeck-us.net>
 <20191028134905.GA53500@kroah.com>
 <20191028135756.GA97772@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028135756.GA97772@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 02:57:56PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Oct 28, 2019 at 02:49:05PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Oct 28, 2019 at 06:32:14AM -0700, Guenter Roeck wrote:
> > > On 10/27/19 2:00 PM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.4.198 release.
> > > > There are 41 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > 
> > > Building mips:defconfig ... failed
> > > --------------
> > > Error log:
> > > In file included from /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/include/asm/bitops.h:21,
> > >                  from /opt/buildbot/slave/stable-queue-4.9/build/include/linux/bitops.h:17,
> > >                  from /opt/buildbot/slave/stable-queue-4.9/build/include/linux/kernel.h:10,
> > >                  from /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:15:
> > > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c: In function 'cpu_probe':
> > > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaration of function '__ase' [-Werror=implicit-function-declaration]
> > >   349 | #define cpu_has_loongson_mmi  __ase(MIPS_ASE_LOONGSON_MMI)
> > >       |                               ^~~~~
> > > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2079:6: note: in expansion of macro 'cpu_has_loongson_mmi'
> > >  2079 |  if (cpu_has_loongson_mmi)
> > >       |      ^~~~~~~~~~~~~~~~~~~~
> > > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undeclared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?
> > >  2083 |   elf_hwcap |= HWCAP_LOONGSON_CAM;
> > >       |                ^~~~~~~~~~~~~~~~~~
> > >       |                HWCAP_LOONGSON_EXT
> > > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2083:16: note: each undeclared identifier is reported only once for each function it appears in
> > > 
> > > 
> > > Affects all mips builds in v{4.4, 4.9, 4.14}.
> > 
> > Ugh, let me see what happened...
> 
> Ok, two MIPS patches dropped from 4.4, 4.9, and 4.14 queues, and -rc2
> are now pushed out for all 3 of those trees.  It "should" be clean now.
> 
Confirmed.

Thanks,
Guenter
