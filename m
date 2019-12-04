Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E613B11368F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 21:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLDUh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 15:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbfLDUhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 15:37:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9942073B;
        Wed,  4 Dec 2019 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575491875;
        bh=TB+uX2qjF9SpmCCJYueLPTn/FbWdVHY1zPaYgMGx3/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vCOa2JeF9wS07Z33S/nfHiNXO4q6ooFELXai9bTp7AaNvY5CPwoMX1JmAjc00Dhbo
         C4I1BRej1ZVd1ZedcejhwtOIzleOt87reURw8iwBXodmrLomMndMjqXm6eQ/jQplxU
         Y0YegK6fBQmTRVuoQ4wtUZvmJzOgcNXnNpkzv9Dc=
Date:   Wed, 4 Dec 2019 21:37:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/46] 5.4.2-stable review
Message-ID: <20191204203753.GC3685601@kroah.com>
References: <20191203212705.175425505@linuxfoundation.org>
 <a070b014-b70b-06ae-8765-831819d57fbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a070b014-b70b-06ae-8765-831819d57fbe@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 10:50:06AM -0700, shuah wrote:
> On 12/3/19 3:35 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.2 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing these and letting me know.

greg k-h
