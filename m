Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4922911B0
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437739AbgJQLeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436472AbgJQLeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 07:34:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1888B206E5;
        Sat, 17 Oct 2020 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602934449;
        bh=mIFW/MioU6azdyQ/VEY1vjQP36uq847Elii5AnxN+iU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8x1BCPBmWXxdZKUDUwfvzhaa4CBSmXSXI/61UYqFB1AE169BDHEQ4a8DRbTNzfIC
         v6HXz59QBpAkb00dyv77NTI1h+bGugyVrVIvHI+hX1CAskF93RJ83nb5fP6aPM+2xO
         xhQ/O8LMBOyPFCHcrhrBw+WOYH/zfqnD98FvBPCQ=
Date:   Sat, 17 Oct 2020 13:34:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
Message-ID: <20201017113459.GE2978968@kroah.com>
References: <20201016090437.170032996@linuxfoundation.org>
 <20201016210942.GA108535@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016210942.GA108535@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 02:09:42PM -0700, Guenter Roeck wrote:
> On Fri, Oct 16, 2020 at 11:08:02AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.1 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 153 fail: 1
> Failed builds:
> 	mips:allmodconfig
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> The mips build problem is inherited from mainline and still seen there.
> 
> ERROR: modpost: "fw_arg3" [drivers/mtd/parsers/bcm63xxpart.ko] undefined!
> 
> A fix is (finally) queued in -next.

Good!

> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing them all and letting me know.

greg k-h
