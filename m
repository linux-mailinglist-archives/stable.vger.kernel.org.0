Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5C391130
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 09:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhEZHKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 03:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232336AbhEZHKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 03:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 119C9610A8;
        Wed, 26 May 2021 07:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622012919;
        bh=sMPNH6FYN0JDqdjj3L/ygquBaugIlYCDJrWZD6ZAQVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eGhmZPvT12I372fHieA+oAxwEf4ikMsUCl6z3A2OChebH7Xau4wSlpwaqorVMIiiJ
         qCKyNjSPRxEfxgWWP8BN+97B988MBq0CsYOmKBYrVdce82bx2bf2WmfVsjWnk90XwJ
         fpnSynct93vbwU5lnHo/Azf0owWCEzF7HiDoz71Q=
Date:   Wed, 26 May 2021 09:08:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
Message-ID: <YK3z9MJxSeYC/nJZ@kroah.com>
References: <20210524152326.447759938@linuxfoundation.org>
 <20210525182836.GA236211@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525182836.GA236211@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 11:28:36AM -0700, Guenter Roeck wrote:
> On Mon, May 24, 2021 at 05:25:06PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.122 release.
> > There are 71 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> > Anything received after that time might be too late.
> > 
> > greg k-h
> > 
> > Christoph Hellwig <hch@lst.de>
> >     nvme-multipath: fix double initialization of ANA state
> > 
> This patch was later fixed with commit commit e181811bd04d ("nvmet: use
> new ana_log_size instead the old one").

Argh, I thought I ran my script to catch these, I wonder what went
wrong.

Hm, my script caught it, no idea how I missed it on my end, my fault.
Thanks for pointing this out, now queued up.

greg k-h
