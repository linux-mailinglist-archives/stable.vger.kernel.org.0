Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B83B20D62
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEPQtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfEPQtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 12:49:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B5C205ED;
        Thu, 16 May 2019 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558025388;
        bh=f39J1y2HUBBvWJ/ZSxKNXPA2X7fuggYgqUX7ZitxiOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yEBswWOftjFuEI2KC+4z2rUHEcT7Cf1oD+RVQjGd8xRByrH0JwtcORXetNBPby6jr
         uzP8X4YCZsKomIdSwje2Y0B0emGowIyiCjp5m+Pb8/BN/3+0JT2frGHocB93EwxiF6
         GMZzSnpFnoR+GRtX2FKSB9r9m3nt8jAzkctJw7YA=
Date:   Thu, 16 May 2019 18:49:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190516164946.GB12641@kroah.com>
References: <20190515090616.670410738@linuxfoundation.org>
 <38cc4651-4e70-48c8-5793-5857d0f33cc5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38cc4651-4e70-48c8-5793-5857d0f33cc5@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 07:55:43AM -0600, shuah wrote:
> On 5/15/19 4:56 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.3 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
