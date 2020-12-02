Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26D2CB5E1
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 08:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgLBHsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 02:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgLBHsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 02:48:21 -0500
Date:   Wed, 2 Dec 2020 08:48:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606895260;
        bh=7KqMB4qr/mGStXIKM0mKELmEUkICD6FHVk6qwr4nwAI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=pc2b+9NjuDryKF+ROKz5FPXKTPndFKbZLeYhz7WGev3ma12pWeijpOA/GRhLWsHCC
         G9neUnDQ0ERIOtZnjN1ju+f2x3GQ5pqVIWFE0anxwq6g02KEumHbaau+f6JAIzUvwv
         xz3mJly6XGq3+25ADzT5ArCZiPf7HoLyjSdnwoU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.161-rc1 review
Message-ID: <X8dG4p+tfE1t4YqD@kroah.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201155924.GA25115@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201155924.GA25115@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 04:59:24PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.161 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> > Anything received after that time might be too late.
> 
> No problems detected during testing:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing 2 of these and letting me know.

greg k-h
