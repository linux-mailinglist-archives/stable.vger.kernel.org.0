Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F98D181931
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgCKNIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbgCKNIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:08:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68A721D7E;
        Wed, 11 Mar 2020 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583932086;
        bh=r6UkvKocCWXfWoUTp/3k8C7Wtq2slxbJkg8qw1n69t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aaJPwka78Pd+pZxKdxxVN1+RkH4b2FWIDPHDGe/pukiUjVOOyH85jF6GIXXVN6q3e
         Xc6fK64M8cHSHAS9rSwpKguKE/moN2ZBFCrh/Cz1UOZhKKJ65nRCPcw8P9vUtyV+2L
         vPJ9tOoC2opKeg83BIg5cEFkhm4LVhXKUv9bm0UA=
Date:   Wed, 11 Mar 2020 14:08:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
Message-ID: <20200311130804.GB3833342@kroah.com>
References: <20200310124203.704193207@linuxfoundation.org>
 <0074ed5d-1c87-4e0c-7d3f-bb5cc4e80366@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0074ed5d-1c87-4e0c-7d3f-bb5cc4e80366@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:26:54PM -0600, shuah wrote:
> On 3/10/20 6:40 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.173 release.
> > There are 126 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. I have a new alert on my system:
> 
> RIP: kvm_mmu_set_mmio_spte_mask+0x34/0x40 [kvm] RSP: ffffb4f7415b7be8
> 
> I haven't tracked it yet.

I think I know what this is, let me release a -rc2 with the proposed
fix.

thanks,

greg k-h
