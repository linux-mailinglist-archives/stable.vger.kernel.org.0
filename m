Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C551B456125
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 18:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhKRRLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 12:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233903AbhKRRLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 12:11:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAFCC60295;
        Thu, 18 Nov 2021 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637255330;
        bh=D78NxU2zghKsclghXx0yz3B0QO/agSm5yD90cTOxoPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVOX7XjQZNMGLYfWa2H45MH36B5Xf7odxtfEw3Ro0+U7vLdUIQpfvUATZME+j80wT
         q5jJsyxhy0B8LIc0SVcdVSajkHjRWlXAmDOOx0q6A3vR1xpVonJy8PmrOe9EuJiAai
         Qc8LNCN0ee89E1R4+Vdj+FXAmx/qtmnQOtB1Q/ic=
Date:   Thu, 18 Nov 2021 18:08:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger Kiehl <Holger.Kiehl@dwd.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZaIoGm+td26duG7@kroah.com>
References: <20211117101657.463560063@linuxfoundation.org>
 <413ef3-c782-be14-da3-da86ed14a210@diagnostix.dwd.de>
 <YZYLYlvdfi9ddToA@kroah.com>
 <45eb66bb-818d-d1f-a78f-f7c7c1bcaa2@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45eb66bb-818d-d1f-a78f-f7c7c1bcaa2@diagnostix.dwd.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 02:08:33PM +0000, Holger Kiehl wrote:
> On Thu, 18 Nov 2021, Greg Kroah-Hartman wrote:
> 
> > On Wed, Nov 17, 2021 at 08:25:12PM +0000, Holger Kiehl wrote:
> > > Hello,
> > > 
> > > On Wed, 17 Nov 2021, Greg Kroah-Hartman wrote:
> > > 
> > > > This is the start of the stable review cycle for the 5.15.3 release.
> > > > There are 923 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > > 
> > > On a Deskmini X300 with a AMD APU 5700G this does not boot (rc1+rc2 also
> > > do not boot). As Scott Bruce already noticed, if one removes
> > > c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix __get_wchan() for
> > > !STACKTRACE" it boots.
> > 
> > Now dropped, thanks.
> > 
> Thanks. Now 5.15.3-rc4 works fine!

Wonderful, thanks for testing and letting us know.

greg k-h
