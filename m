Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E314D57547
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfF0AMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfF0AM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:12:29 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F76F216C8;
        Thu, 27 Jun 2019 00:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561594348;
        bh=EmLbUJPy/+8+uX0ORC9EEgi7UnmvJ36grSg/G2HRIhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I991ou+57tLcVNVECSMPJbM/QOV4+Tvb0HXoczeUnJlnFiwajieaDnvq9mLBIoyW5
         vlfZqi5RBzjSGFoQr7k+BnElNmE3fuBDpRvyMysfmYJDi7+nxomB91pmlasPUmzojk
         jJ5KA2naaZxtrZ6oucK+mwxullFw4y/HxC760OGc=
Date:   Thu, 27 Jun 2019 08:11:58 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] 4.14.131-stable review
Message-ID: <20190627001158.GE527@kroah.com>
References: <20190626083606.248422423@linuxfoundation.org>
 <6991cd1b-9938-5a34-bb69-ecf75e4b5618@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6991cd1b-9938-5a34-bb69-ecf75e4b5618@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 04:32:18PM -0600, shuah wrote:
> On 6/26/19 2:45 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.131 release.
> > There are 1 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.131-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >      Linux 4.14.131-rc1
> > 
> > Eric Dumazet <edumazet@google.com>
> >      tcp: refine memory limit test in tcp_fragment()
> > 
> > 
> > -------------
> > 
> > Diffstat:
> > 
> >   Makefile              | 4 ++--
> >   net/ipv4/tcp_output.c | 2 +-
> >   2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > 
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Great, thanks for testing these and letting me know.

greg k-h
