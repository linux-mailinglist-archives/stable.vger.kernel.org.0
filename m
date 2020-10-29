Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C233729E6AA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 09:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ2I4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 04:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgJ2IzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 04:55:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0BE2080C;
        Thu, 29 Oct 2020 08:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603961716;
        bh=L0Whugwuq44cmb2RrDNlRmlOZlDj6nLzopxg1GC5Grc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OcSBLObog+beMOfElgPhgx0r4+HhbVv1+17deRgJ2tycyYRHdDZkbtEcEOCMyMdjX
         fXPVypX+y0VVdyyryWUJwSndUmQfFdU42e0PCxTyeo6p6QQcy+Hap1Sb5awqWtcahX
         dlnV/iw/uNjRaOMZufWBBXBlmCDs4NvHg8l1iCf0=
Date:   Thu, 29 Oct 2020 09:56:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201029085606.GA3324771@kroah.com>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028160000.GD28011@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028160000.GD28011@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 05:00:00PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.153 release.
> > There are 264 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> > Anything received after that time might be too late.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/208235954
> 
> It shows failed run -- https://lava.ciplatform.org/scheduler/job/73174
> -- but that seems to be something wrong with our test infrastructure.
> So... no problems detected by CIP project.
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing 2 of these and letting me know.

greg k-h
