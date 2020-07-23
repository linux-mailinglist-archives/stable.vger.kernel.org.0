Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931F722B595
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 20:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgGWSX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 14:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgGWSX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 14:23:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 568DE20792;
        Thu, 23 Jul 2020 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595528638;
        bh=+J2bMlsb58hbrdjz/HEQZUqeTCu60KQ8AfRmqqS4f88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O8E3pztspP7jRL5lw3lPB2G3woBunQuhgvYubR8NIiSA4b7lwPeDTUD86XD2qfR6+
         Jj/2qEW/6vye/p/omc3DOK7suXotaPHNMSMhleoGzDDwuPIf++77lotdrmTO9PD3ys
         hmVAcsYN4X2urry/HyxJ1fm/g7NG5ajhvSe7XWQA=
Date:   Thu, 23 Jul 2020 20:24:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases [7/23/2020]
Message-ID: <20200723182402.GB2960332@kroah.com>
References: <20200723155708.5233-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723155708.5233-1-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 08:57:08AM -0700, Guenter Roeck wrote:
> Hi,
> 
> Please consider applying the following patches to the listed stable
> releases.
> 
> The following patches were found to be missing in stable releases by the
> Chrome OS missing patch robot. The patches meet the following criteria.
> - The patch includes a Fixes: tag
>   Note that the Fixes: tag does not always point to the correct upstream
>   SHA. In that case the correct upstream SHA is listed below.
> - The patch referenced in the Fixes: tag has been applied to the listed
>   stable release
> - The patch has not been applied to that stable release
> 
> All patches have been applied to the listed stable releases and to at least
> one Chrome OS branch. Resulting images have been build- and runtime-tested
> (where applicable) on real hardware and with virtual hardware on
> kerneltests.org.
> 
> Thanks,
> Guenter
> 
> ---
> Upstream commit 2aeb18835476 ("perf/core: Fix locking for children siblings group read")
>   upstream: v4.13-rc2
>     Fixes: ba5213ae6b88 ("perf/core: Correct event creation with PERF_FORMAT_GROUP")
>       in linux-4.4.y: a8dd3dfefcf5
>       in linux-4.9.y: 50fe37e83e14
>       upstream: v4.13-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
> 
> Upstream commit d41f36a6464a ("spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours")
>   upstream: v5.4-rc1
>     Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
>       in linux-4.14.y: c75e886e1270
>       in linux-4.19.y: eb336b9003b1
>       upstream: v5.0-rc1
>     Affected branches:
>       linux-4.14.y
>       linux-4.19.y

All now queued up, thanks!

greg k-h
