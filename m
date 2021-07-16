Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2676C3CBB9B
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhGPSFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhGPSFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C649E613F5;
        Fri, 16 Jul 2021 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458579;
        bh=hHOk0AALvY0XZ2Op5RzBpqCrtQxxj6CZaFOP7fxpVLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EoF34jhQm/bYr4JBdTfGXFNsrSrXyVOSU6/toPHQF0K/+UKwr4KeV/htnsTj/tzz8
         pILpWNwy4PIILyDhc8GaG/FKHqTWvVYtCxKS3uhRpm3+QJC3QMmUFUFy0zPjpKjEvG
         irutnpXiyg293PtfXIjnd6ovBtyv9ZJpRn/ojDRo=
Date:   Fri, 16 Jul 2021 20:02:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
Message-ID: <YPHJ0EMGHkXX5Igb@kroah.com>
References: <20210715182551.731989182@linuxfoundation.org>
 <dcc3c82c-a026-99c8-0342-b231665ec301@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcc3c82c-a026-99c8-0342-b231665ec301@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 06:40:15AM -0700, Guenter Roeck wrote:
> On 7/15/21 11:36 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.12.18 release.
> > There are 242 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building s390:defconfig ... failed
> --------------
> Error log:
> /bin/sh: arch/s390/kernel/vdso64/gen_vdso_offsets.sh: Permission denied
> /bin/sh: arch/s390/kernel/vdso32/gen_vdso_offsets.sh: Permission denied
> ...
> 
> Original commit:
> 
> diff --git a/arch/s390/kernel/vdso32/gen_vdso_offsets.sh b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
> new file mode 100755
>               ^^^^^^
> index 000000000000..9c4f951e227d
> --- /dev/null
> +++ b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
> 
> This commit:
> 
> diff --git a/arch/s390/kernel/vdso32/gen_vdso_offsets.sh b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
> new file mode 100644
>               ^^^^^^
> index 000000000000..9c4f951e227d
> --- /dev/null
> +++ b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
> 
> Same with v5.13.y.

Ah crap.  Quilt does not handle permissions like this.  And really, we
shouldn't be doing that either in the kernel, I thought we fixed these
all up so that the executable bit did not have to be set.

Let me go dig...

thanks,

greg k-h
