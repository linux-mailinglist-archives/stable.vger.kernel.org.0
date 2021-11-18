Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582774556CE
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244672AbhKRITN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244359AbhKRIR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 03:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A40861B5F;
        Thu, 18 Nov 2021 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637223269;
        bh=gTMVE/v3w0muZO+V/rfc/1NUnV4AkBHzpkleFAa7i4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W9jxoyEBBEkdVZJFDlu+N8irf1nGyuOGwSnlEvCaHtrNxuaPP7feSBlRdNSBgWiXP
         HtuRdffiyCjiGg9oBV/A9VfnrN5akSQD/h0OWrtiGBLRBdCjKHSTDXyctIvd//5VEb
         mgU4QXWcIdmlVK+0uyo/nlDwRMJzniN7naipKNaU=
Date:   Thu, 18 Nov 2021 09:14:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger Kiehl <Holger.Kiehl@dwd.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZYLYlvdfi9ddToA@kroah.com>
References: <20211117101657.463560063@linuxfoundation.org>
 <413ef3-c782-be14-da3-da86ed14a210@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <413ef3-c782-be14-da3-da86ed14a210@diagnostix.dwd.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 08:25:12PM +0000, Holger Kiehl wrote:
> Hello,
> 
> On Wed, 17 Nov 2021, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 5.15.3 release.
> > There are 923 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> On a Deskmini X300 with a AMD APU 5700G this does not boot (rc1+rc2 also
> do not boot). As Scott Bruce already noticed, if one removes
> c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix __get_wchan() for
> !STACKTRACE" it boots.

Now dropped, thanks.

greg k-h
