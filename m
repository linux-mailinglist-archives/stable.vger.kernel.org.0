Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C4628DE07
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgJNJ4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgJNJ4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:56:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657A020757;
        Wed, 14 Oct 2020 09:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602669376;
        bh=jEKtRc9N6wGBbahI0HOZ201QTiFT8nyXZWYm97VnCl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8Q+g6v46UiPg4E2BBLC6xlAZjeGM/rFDfMbKcKBx+tes0QOGx8kgNs7qRcbfPQrB
         VG+2fGxfQAi1Ar6+CetDvcz42Fs2iFnRHxwJNKOvKPlwFZzkjlwq7ByQjyl35J7BdA
         nfFa/88hXcSA/5J/dOrCZ/+8kEAz0W8+vyuvYoe0=
Date:   Wed, 14 Oct 2020 11:56:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
Message-ID: <20201014095652.GA3599360@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
 <d31bda1df5cc75e3217d88eece08dcc2c3c29531.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d31bda1df5cc75e3217d88eece08dcc2c3c29531.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 11:00:07PM +0530, Jeffrin Jose T wrote:
>  * On Mon, 2020-10-12 at 15:30 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.15 release.
> > There are 124 patches in this series, all will be posted as a
> > response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello,
> 
> Compiled and booted 5.8.15-rc1+ .  No typical dmesg regression.
> I also  have something to mention here. I saw  a warning related in
> several  kernels which looks like the following...
> 
> "MDS CPU bug present and SMT on, data leak possible"
> 
> But now in 5.8.15-rc1+ , that warning disappeared.

Odds are your microcode/bios finally got updated on that machine, right?

thanks for testing and letting me know.

greg k-h
