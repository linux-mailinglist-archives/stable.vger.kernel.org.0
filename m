Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E4FD3878
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 06:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfJKE3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 00:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfJKE3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 00:29:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A502089F;
        Fri, 11 Oct 2019 04:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570768188;
        bh=gCx5YHH5VjxJhgJJ/tLxPkRAC3Lkst3E5Co1aLOBd6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joLF3Qm28BCaRxQD0Xoh0sQvgQhU2FaCdONduvk/OWb/lgqu6Hb55k6YURoW4FD0A
         Xd2Rvz0Y/YSnkYbGqc85fK69SCGqAAdtRIWNBK1GMhdOzbFS9+cRAQ04wtmK78ZA5l
         yRquX6XkltDVmQjtUveeO2V885sTNnt3eYI/Y2ZE=
Date:   Fri, 11 Oct 2019 06:29:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
Message-ID: <20191011042945.GB939089@kroah.com>
References: <20191010083449.500442342@linuxfoundation.org>
 <ce4b3f10-eafd-1169-9240-fb3891279c2a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce4b3f10-eafd-1169-9240-fb3891279c2a@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 10:12:26AM -0700, Guenter Roeck wrote:
> On 10/10/19 1:36 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.149 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Preliminary.
> 
> I see several mips build failures.
> 
> arch/mips/kernel/proc.c: In function 'show_cpuinfo':
> arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaration of function '__ase'

Thanks, will go drop the lone mips patch that I think is causing this
problem.

greg k-h
