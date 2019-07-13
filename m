Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852F267943
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 10:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfGMIXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 04:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfGMIXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jul 2019 04:23:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4164720830;
        Sat, 13 Jul 2019 08:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563006222;
        bh=+oQF0qgLB7byqqsAhI9UCLj6UMPFW5EBwG9bNThK4Jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IewA3SzHE2unPyPBXYdE1kjPHna2S1IpEToFHvulpxkaiBsoCbJrg2vFNUunSwyfi
         iBZ1GDGM/ZBc31L4NvnYTBcpdGqCRoj8daZl32ORktSIYKtgAQ6UFDoejE0z6XHj57
         ruDXRdwmEnnu957iee+tLErYDig4Lwk5Xv8/D96c=
Date:   Sat, 13 Jul 2019 10:23:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190713082339.GB28657@kroah.com>
References: <20190712121620.632595223@linuxfoundation.org>
 <3fa8fece-4d05-afad-8d09-1cb6942407dc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa8fece-4d05-afad-8d09-1cb6942407dc@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 04:07:06PM -0600, shuah wrote:
> On 7/12/19 6:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing and letting me know.

greg k-h
