Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96B1D48D2
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 10:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEOIwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 04:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgEOIwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 04:52:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5501D206B6;
        Fri, 15 May 2020 08:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589532724;
        bh=1LyoXzXBlHR/2FOqWA0gGiLvv9svrT2bA80Zjuz+qsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pEx3rd/KyL0om8G/qSVfIA5d8W7HNz5VqBbCQopD9qHWF5Xv3qSUG/RD3KdlB08No
         ti5aZbXAM9TFq0T1cWZABh9bDD/RCS+gPbMXMlYluCol/JxoyIdA+eT3GOYB2JGWeZ
         U+vX/3I9p7VUTR5SmNXAwswvhdvmPBUX4EcCXFUU=
Date:   Fri, 15 May 2020 10:52:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/118] 5.6.13-rc1 review
Message-ID: <20200515085202.GD1474499@kroah.com>
References: <20200513094417.618129545@linuxfoundation.org>
 <6ef26ca0-ebb2-9f9a-c9a8-32365667a7a9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ef26ca0-ebb2-9f9a-c9a8-32365667a7a9@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 04:59:52PM -0600, shuah wrote:
> On 5/13/20 3:43 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.13 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
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
