Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576C73695AB
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhDWPJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhDWPJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4119E613B6;
        Fri, 23 Apr 2021 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190540;
        bh=DB8AyJVJx3uP6abPgVEUHE+M+RxobNr+RluOPtJBTTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=louW5glYY+cXeezQ7VPYXJAEy4rmzmhCf5BMY/BJ9V2LdBBNDfbtYbz2hrZDj8Aul
         Z5RDF4hJsrNkA+KXj4SGAH/OEe8fKbxLkaisN/4oKGH6Tz1ou07PKVzSHIrqJ8AZSC
         /HMEH3/hCWFwnEZtPG3SbijCz1W/n30lvN02Rf2g=
Date:   Fri, 23 Apr 2021 17:08:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fox Chen <foxhlchen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/122] 5.11.16-rc1 review
Message-ID: <YILjCtobRF6dZSty@kroah.com>
References: <20210419130530.166331793@linuxfoundation.org>
 <607ddbe5.1c69fb81.88e5d.2cd1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <607ddbe5.1c69fb81.88e5d.2cd1@mx.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 12:37:09PM -0700, Fox Chen wrote:
> On Mon, 19 Apr 2021 15:04:40 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.11.16 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> 5.11.16-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
>                 
> Tested-by: Fox Chen <foxhlchen@gmail.com>

Thanks for testing and letting me know.

greg k-h
