Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8578F316115
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBJIcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:32:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhBJIb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:31:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B542864E53;
        Wed, 10 Feb 2021 08:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945864;
        bh=z3TfF0J06NhLK15fZdiKI4nYQYykxRWlEtz4UQQIz0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G9xJfv0PTYB5ytTfjp5ZugMCXzqjM44xK6+b+Yt8b24VwFkgDDIR/PskFAxRd5q3x
         FUsUvefjoTKMNchfQ+jKSAvAbIASWOORpmor/6X0DMjSjdbnvxzG7Hm1kiiqwZK4Oa
         yux4+/s6bDoGvyw8fNmTOnPD2LaJzMnolPXG/qOk=
Date:   Wed, 10 Feb 2021 09:31:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <YCOZxVkFMDrRuytX@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <20210208183353.GA14334@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208183353.GA14334@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 07:33:53PM +0100, Pavel Machek wrote:
> On Mon 2021-02-08 15:59:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of them and letting me know.

greg k-h
