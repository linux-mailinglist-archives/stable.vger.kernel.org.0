Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165B8441ACE
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhKALpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232354AbhKALpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 07:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE2860FE8;
        Mon,  1 Nov 2021 11:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635766955;
        bh=pg73EoNfZFnrvniXr6TqULBVuw9n2QOmf1j+cJnIiIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v4yBTKUtE2ZMU2Vjt8gCvpEJD/sB9oOhv0xoDOGQDGg8cbtpb+aT+foCjKzqykSS3
         CaYFx4cYjXAzMH6W5t5oV+FdUivxtfpfVTz0QwP1nMBWrf8xjSPt7ArivigKLRDFUr
         9SAGP8BNCYKJOmoT6iScZntsIDlNX0PueKuxe678=
Date:   Mon, 1 Nov 2021 12:42:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc1 review
Message-ID: <YX/SpTZC4ulePcmx@kroah.com>
References: <20211101082451.430720900@linuxfoundation.org>
 <20211101103732.GA24359@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101103732.GA24359@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 11:37:32AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.215 release.
> > There are 35 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm getting some failures on 4.19.215-rc1, and at least this one is real:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/1734614739
> 
>   CC      drivers/mtd/nand/raw/nand_samsung.o
> 3313drivers/mmc/host/sdhci-esdhc-imx.c: In function 'esdhc_reset_tuning':
> 3314drivers/mmc/host/sdhci-esdhc-imx.c:966:10: error: implicit declaration of function 'readl_poll_timeout'; did you mean 'key_set_timeout'? [-Werror=implicit-function-declaration]
> 3315    ret = readl_poll_timeout(host->ioaddr + SDHCI_AUTO_CMD_STATUS,
> 3316          ^~~~~~~~~~~~~~~~~~
> 3317          key_set_timeout
> 3318  AR      drivers/pci/controller/dwc/built-in.a

Thanks, let me go fix this and push out -rc2...
