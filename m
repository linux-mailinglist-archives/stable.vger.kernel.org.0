Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46FB1DA9FD
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 07:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgETFjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 01:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgETFjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 01:39:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 402EF2075F;
        Wed, 20 May 2020 05:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589953175;
        bh=B/0XsSX2rZV42opP+3nXuLgTMwjD3F2wSqRXJmFEIZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDWHoOK4xl01FH/rleLdqDeAsw6CeltE0MEzoEzv42GCHtdo5E7unHQ2+b6nHb1Zk
         s0Y0KjzJQafxyyAbfOwlzGYMkTURseSksLUTQJjCrq9nSpJWRN2/yFCfEJW2PoQk33
         A7s+kYqzN3TAe+SZz7DdfuOBvXwEYiHRdowNHj7o=
Date:   Wed, 20 May 2020 07:39:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/192] 5.6.14-rc2 review
Message-ID: <20200520053932.GA2174594@kroah.com>
References: <20200519054650.064501564@linuxfoundation.org>
 <aa12b3ae-5b6a-5879-faff-aa0bbcf945f5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa12b3ae-5b6a-5879-faff-aa0bbcf945f5@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 01:37:20PM -0600, shuah wrote:
> On 5/18/20 11:47 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.14 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 May 2020 05:45:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.14-rc2.gz
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
