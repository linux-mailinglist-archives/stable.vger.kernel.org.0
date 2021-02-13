Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27CF31AB75
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBMM7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 07:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhBMM7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 07:59:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3273B64DD8;
        Sat, 13 Feb 2021 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221105;
        bh=KX817fQCMz0eYPoWQ/uHl6yQAIt84VeqapvXBI7anKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecve1woEVqpZtp89aOXnLSJUTl9lL0jQzfMj5UtthNUlcGAdUwI1D1tLoKCYZpYt5
         L8x/XhY31a91ihvFzoNvNAcJzPhobImmrhIsKPkGjE5v3H1osLwLN//pE+QsJmCDyU
         IrZaiSpNTvcLxymcXQIVY5UUOSxBShPSjbsgWsCk=
Date:   Sat, 13 Feb 2021 13:58:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <YCfM74g6TVB4+Ili@kroah.com>
References: <20210211150152.885701259@linuxfoundation.org>
 <20210212180825.GC243679@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212180825.GC243679@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 10:08:25AM -0800, Guenter Roeck wrote:
> On Thu, Feb 11, 2021 at 04:01:44PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.16 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing.

greg k-h
