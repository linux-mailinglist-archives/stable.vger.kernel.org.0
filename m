Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279992EBF0C
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 14:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbhAFNpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 08:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbhAFNpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 08:45:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D19A2311A;
        Wed,  6 Jan 2021 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609940678;
        bh=xmjBSwRkN92iVuAoCcEXoCFTOQpFpIROo2jsrZmXejI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0RVtKEilAHgErec2a53LfTMSr32THCBrqWZoWJ1C0onApYPM57Ao6KbKgmIrYxTCD
         pkAvw9YTBCDX75E+aZyEWG44VLD8oAf5dtL1isucEiJjHwG6ILyAL4FdhFRLsXdfjO
         /O5CkvZFfBmUQ6cnc+z1gGC7YQODKxRgRufJ350E=
Date:   Wed, 6 Jan 2021 14:45:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
Message-ID: <X/W/Fwvcyp0BB9nL@kroah.com>
References: <20210105090818.518271884@linuxfoundation.org>
 <20210105181637.GA220537@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105181637.GA220537@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 10:16:37AM -0800, Guenter Roeck wrote:
> On Tue, Jan 05, 2021 at 10:28:46AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v4.19.164-30-g40a2b34effd3:
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 418 pass: 418 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Glad it now all works, thanks for testing!

greg k-h
