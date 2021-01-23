Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4058F301629
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbhAWPHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbhAWPHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C8C322AAB;
        Sat, 23 Jan 2021 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611414419;
        bh=wB/0Wq+TtoMCRvh4vkYO2iT21ZB4DGpLDwv1xJsf1tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xkqbjrvbPty113+Zuh9XcFOGnJHJpmM+xYyYrs3E8kC2bdLgp6Nq9M5dMwYFBziMY
         P6uq9VD2U/wDrZnu/7wtjKy8ocBfwnxzfaRVtFiiMeJvgNIBwHYzwm6oLOjrZAgCsz
         kUM+nkuagNcfZxc11M4Cpm9x4mMdQYVFAs7vAahc=
Date:   Sat, 23 Jan 2021 16:06:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <YAw7kEE2k07YjnWm@kroah.com>
References: <20210122135735.652681690@linuxfoundation.org>
 <20210123095244.GA6686@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123095244.GA6686@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:45AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.10 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of these and letting me know.

greg k-h
