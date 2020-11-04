Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B412A65DE
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKDOIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgKDOIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:08:41 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3067CC0613D3;
        Wed,  4 Nov 2020 06:08:41 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id s21so22307164oij.0;
        Wed, 04 Nov 2020 06:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=me+a+boQKuGKjUptE+3PxM1+LgvSbaKwHmzk9EGJZJc=;
        b=eqf6AFFa7B0/GBwljCs4ksCbUInucf/LchmVPHk8pB+EZ3eFQ+UJhcXGpwdgL35jtq
         SLWpmChg+T0M0Dv6mhWIjoPn/CyCyC/MwrBFZHBTeDgJuJqVel9dvxVWpoyp6xEA9lYY
         QtBdovs+kMwOqid7GTIqkwdiDUeSe02aj92LcK6T6seRulvgs/6EJkyEVJ6ITz8zyxXj
         PgNVKaUe/F9TrrZ1cmcUKaIcCHwP1UrO7wxkaMUX5pjU8Z8OcMybrcdqXMng5ZHn5+A/
         DFNA4/4yXqtdJ7G7f7V4YP9Zkr0cuIWrnPaa3sf6FD287AxJdZkg0Lwi7pwtJO/k1uGU
         DIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=me+a+boQKuGKjUptE+3PxM1+LgvSbaKwHmzk9EGJZJc=;
        b=UzHMLggB7MIii0cbYR4h7dtPL/C/Krun7xW6iPB6oprdyr7LV0o2FckWPumoyvd9uF
         2gvAxPHqE0Vqivtfnb0amWeNXHMJ3KnXjat+wwocS36sloaDfAm5Oa5Va8LvpLHpCsJc
         XJ8kc2NNihofu8cn6CqMbbD83xT16PizLLYx1HSMN3R1oRWmnrDeTrGLbyYzh1QGsHUQ
         ZKJ/6YFS5RWzvwD3IGLq0RqO/pANiGzvTQ5VdUJSyRDbFQCsU/fLHmLpmGlcfoAfQMI6
         jFD0wj7nYO0GJfOXfckeM+ihHTsYELIXV4xek3qlJppwjJQ24mf5fqDebV4JgwdOAUop
         pQOg==
X-Gm-Message-State: AOAM532iViuJUHTETukggqj0B0BCOIxaRJx0QvNQeRXSYLkigvxwiGU2
        a5Fx5nXQnB/J+i1m/+a1AQ0=
X-Google-Smtp-Source: ABdhPJz+iXGrtx1WW2Efxquf4rm6qfPwgQZK0sw7FtTKPM3zAh7KMKPUwsBuc9950fWlvBXqxoufAg==
X-Received: by 2002:aca:dd43:: with SMTP id u64mr2514893oig.90.1604498920641;
        Wed, 04 Nov 2020 06:08:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x13sm539647oot.24.2020.11.04.06.08.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 06:08:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 06:08:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/125] 4.14.204-rc1 review
Message-ID: <20201104140839.GB4312@roeck-us.net>
References: <20201103203156.372184213@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:36:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.204 release.  There
> are 125 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.  Anything
> received after that time might be too late.
> 

sparc32 images fail to build.

Building sparc32:defconfig ... failed
--------------
Error log:
In file included from arch/sparc/include/asm/io_32.h:14,
                 from arch/sparc/include/asm/io.h:7,
                 from include/linux/io.h:25,
                 from include/linux/irq.h:25,
                 from include/asm-generic/hardirq.h:13,
                 from arch/sparc/include/asm/hardirq_32.h:11,
                 from arch/sparc/include/asm/hardirq.h:7,
                 from include/linux/hardirq.h:9,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:9,
                 from include/linux/suspend.h:5,
                 from init/do_mounts.c:16:
include/asm-generic/io.h: In function '__pci_ioport_unmap':
include/asm-generic/io.h:900:2: error: implicit declaration of function 'iounmap'; did you mean 'vunmap'?

Guenter
