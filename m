Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE8D11C697
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 08:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfLLHmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 02:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfLLHmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 02:42:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3F72077B;
        Thu, 12 Dec 2019 07:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576136539;
        bh=5zCv/eaTMVaq/nkMFbjBVTsliC4akO/35mkrg4dmBhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uXeHBHPaiQWkoyyQgFzuRg1AV9xSRZESkigMpXy2HavIzsFFbOXaV+ODHBV3dtwQ4
         itvxFXWTj+JvbUnaVgJhYzEsvw40pEBlff6kOU3GjBkAV/5HlShSwEE7fZ2I2zOTiY
         vN6CN1pLvyeFGm1igpauGMq8YIdJaw2zjtzwTf+Q=
Date:   Thu, 12 Dec 2019 08:42:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review [warning related]
Message-ID: <20191212074217.GB1368279@kroah.com>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191211214337.GB2676@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211214337.GB2676@debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 03:13:37AM +0530, Jeffrin Jose wrote:
> On Wed, Dec 11, 2019 at 04:04:49PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.16 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> 
> the following is from "dmesg -l warn"
> 
> -------------------x------------x------------------------
> ================================================
> WARNING: lock held when returning to user space!
> 5.3.16-rc1+ #1 Tainted: G            E    
> ------------------------------------------------
> tpm2-abrmd/679 is leaving the kernel with locks still held!
> 2 locks held by tpm2-abrmd/679:
>  #0: 00000000d3bc394f (&chip->ops_sem){.+.+}, at: tpm_try_get_ops+0x2b/0xb0 [tpm]
>  #1: 000000004a4d7099 (&chip->tpm_mutex){+.+.}, at: tpm_try_get_ops+0x4b/0xb0 [tpm]
> 
> ------------x----------------------x---------------------
> 
> the fix for the above to a typical kernel is here ...
> 
> https://patchwork.kernel.org/patch/11283317/

I need to wait for that to get into Linus's tree before we can do
anything about it for a stable kernel release.

thanks,

greg k-h
