Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B133695CF
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242874AbhDWPNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237174AbhDWPNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:13:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1EC61477;
        Fri, 23 Apr 2021 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190775;
        bh=oOGCkzYZtkH/bdiDDPO14HmE3zvLzwY2zsgGUNGdJS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dGA/KJYDvnKFAHgzDEO5M9R4ADPINTYcp5yHe+QotYtup/HqXzfoSbkS0mSEesAeJ
         O3Aj43vs8SE3fLS6YneHrAAtDJCQdMHD0mgdCHdb6yOyAl09+UvDLSrOM2vPDrwWIi
         CmPx+yBMLFyG5uH0KXKajIlrJ2QTlqAD7LvInDh0=
Date:   Fri, 23 Apr 2021 17:12:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrei Rabusov <a.rabusov@tum.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YILj9cIVDaT9l8oB@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <YH7A5zclP6USkEpY@yaviniv.e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH7A5zclP6USkEpY@yaviniv.e18.physik.tu-muenchen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 01:54:15PM +0200, Andrei Rabusov wrote:
> On Mon, Apr 19, 2021 at 03:05:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.32 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On my i686 (gcc 10.3) I found no issues with the new rc
> 
> Selftest results [ok/not ok]: [1435/81]
> 
> Tested-by: Andrei Rabusov <a.rabusov@tum.de>

Thanks for testing and letting me know.

greg k-h

