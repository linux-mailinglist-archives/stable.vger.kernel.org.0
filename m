Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E2D3CBBA8
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhGPSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGPSKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 010F96109E;
        Fri, 16 Jul 2021 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458877;
        bh=lzf5dWz+ajTUaQSl//l9YzLyI8L4sja0PFbe00mxGGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k4Dsb3bADXToAAjv4XNoC6D6U5PQ9Q1g9LZ/b6xIGIjvGVPYmWZtOXPURhQhg0Efi
         zU5hQx6XZ6hJ0tA/ouatVdI3m6DS9i7zh/ZebyW/guZ19csK8Gd2BuUCvqaIBzASXT
         RA9yLBNCW0nEWQRrheHuylZfbPLjH5R8bBFpcV4k=
Date:   Fri, 16 Jul 2021 20:07:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
Message-ID: <YPHK90sGzPC1tzjs@kroah.com>
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

I'm just dropping these patches for now.  thanks.

greg k-h
