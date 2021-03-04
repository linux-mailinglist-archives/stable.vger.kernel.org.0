Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6227A32D105
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhCDKlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 05:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238834AbhCDKlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 05:41:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 627B064F34;
        Thu,  4 Mar 2021 10:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614854444;
        bh=B/1LwVphMx2xlLbMK3A6RZWUoNM603cdyZtP8eXhjJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lc9f2MpJgQQXCnMEt2PqRANQQmBOUcoge/5IvjgM3QIGpdmrvnrxgHb0uSK9XZLuI
         bwzSqta9jPiPpUszeiVqTgAEmg2wFW/u/QfaMEeUQ3ynumobRuWUIHm1GinfFtUb9Q
         id2fwBRSxkrFYmQ8uHkythMVnyro+89OEckfz2ms=
Date:   Thu, 4 Mar 2021 11:40:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guillaume Tucker <guillaume.tucker@collabora.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
Message-ID: <YEC5Ku8XBW9DC8H1@kroah.com>
References: <20210302192700.399054668@linuxfoundation.org>
 <d26f494c-4906-4ed4-e277-0c486e83e343@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d26f494c-4906-4ed4-e277-0c486e83e343@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 10:18:30AM +0000, Guillaume Tucker wrote:
> On 02/03/2021 19:28, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 657 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc4.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> No build errors seen on kernelci.org:
> 
>   https://kernelci.org/build/stable-rc/branch/linux-5.10.y/kernel/v5.10.19-658-g083cbba104d9/
> 
> 
> No test regressions either:
> 
>   https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/kernel/v5.10.19-658-g083cbba104d9/
> 
> 
> Tested-by: "kernelci.org bot" <bot@kernelci.org>
> 

Great, thanks for testing and letting me know.

greg k-h
