Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D2529D308
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgJ1Vk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgJ1VkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:40:25 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41593C0613CF;
        Wed, 28 Oct 2020 14:40:25 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id f7so1126521oib.4;
        Wed, 28 Oct 2020 14:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vXJ8T6o56jCu0MfyhV0AaXLWIggqfrdfu2QfkoykE0E=;
        b=qAYe/s5ueGb41zUJGnXbyQHqIkDknGGdV8jURXU5ROg6XREOsOOCRX8GTdFOsOOkdU
         sU6WFxyH47EtnlvvmkXEYq+owlBYFeP4zHMa11oxrcQtXcNpgXr4e99wdXI2gph5DBhL
         xU30AVYM+wTjEwBNad5ZyK1EFtk90yMRNu6GXs0dbfPapR1RU4v7mY+TWOI5X4dq3hW1
         YvsB3vjL1aE56SrJLViaH7Us+/IlPaLgy3r2mfC9j9BLI/yHjibJiVZIjSQuDcnEE+eg
         nX5/1KlkrH8zMF1s67E+Qa21EJjv7vOy36kV92BNiB9ZeJxFYCJA4zLfnedly9ib7FpR
         fjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vXJ8T6o56jCu0MfyhV0AaXLWIggqfrdfu2QfkoykE0E=;
        b=HMkJikZwLpNLw6lDZYE4EA0EBl4XBE5n2K/Qa/jIFckZo/yItIRd9DS28YExSjMjf+
         Mvx6n6MqmV5IwEUcUVYFR2Nf1/UIZeUmMqpIvl8Lp6UnlEs52ATqNmkPqUOOWa2/YEc6
         aouKbc1eieqzbZUr9ARudn0JAHLKvFC+FQlngRuhxzB08UrVVMHz4+XqdqgZUMJlq1do
         7NGRTpVoKyAXEqoH/505Yfa6JZKq3Gin6nswJc7475wUzfkba6cWslMdsXZaFADRVfYu
         Ct/N966eaXXnNOhrx6MLf1LXI9GjFRSxBWst8APMr+psxaJrL1bf6mtIB0TP/pk0UuC8
         Ha9w==
X-Gm-Message-State: AOAM532jZq7sL726BLCX5uSr1hEQhW8Jhe9QBP//e2qn374QNHBGrLz2
        DYYkf+lJYRLZOz8JBGKvfiNDfbXEFTQ=
X-Google-Smtp-Source: ABdhPJzT8qb7IzhBhUuOF9G+KhXSdCi6RzMK4BAibwsPVC6Dudlo2OFziJjYHEbfTuOD8Q7mrYewDg==
X-Received: by 2002:aca:f543:: with SMTP id t64mr457080oih.91.1603914981096;
        Wed, 28 Oct 2020 12:56:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j4sm136175ota.17.2020.10.28.12.56.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:56:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:56:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201028195619.GC124982@roeck-us.net>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028171035.GD118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry.

On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.153 release.
> > There are 264 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 152 fail: 3
> Failed builds:
> 	i386:tools/perf
> 	powerpc:ppc6xx_defconfig
> 	x86_64:tools/perf
> Qemu test results:
> 	total: 417 pass: 417 fail: 0
> 
> perf failures are as usual. powerpc:
> 
> arch/powerpc/kernel/tau_6xx.c: In function 'TAU_init':
> include/linux/workqueue.h:427:24: error: too many arguments for format
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
