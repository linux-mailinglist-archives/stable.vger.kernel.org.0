Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CFA130262
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 13:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgADMcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 07:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgADMcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 07:32:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF87215A4;
        Sat,  4 Jan 2020 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578141161;
        bh=Z6bSytfpsB+EqeQntAzhj+/tleTbh5duUoUtFDTLvho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xtwVRdPjTzIGJ0u4oRAcvrCv/0D/6eWFGSKaXyAFkwwcBbuJYbR2JpU0IAR/LKaEO
         EZQFUU0m+SVC8uUAwo1/xjqXi+iRtJpNgbHp2C9H3/I3TwfFvn8MBJy86zUn0mLGx+
         2K/AQ2Fq0XXTzcThRO+9DQzutXO+FtVNH4ufap6s=
Date:   Sat, 4 Jan 2020 13:32:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
Message-ID: <20200104123239.GE1296856@kroah.com>
References: <20200102220029.183913184@linuxfoundation.org>
 <72f41f89-bf68-d275-2f1e-d33a91b5e6cd@roeck-us.net>
 <20200103154156.GA1064304@kroah.com>
 <20200103174624.GA27087@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103174624.GA27087@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 09:46:24AM -0800, Guenter Roeck wrote:
> On Fri, Jan 03, 2020 at 04:41:56PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Jan 03, 2020 at 06:27:53AM -0800, Guenter Roeck wrote:
> > > On 1/2/20 2:06 PM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.93 release.
> > > > There are 114 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 04 Jan 2020 21:58:48 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Build results:
> > > 	total: 156 pass: 155 fail: 1
> > > Failed builds:
> > > 	sparc64:allmodconfig
> > > Qemu test results:
> > > 	total: 381 pass: 381 fail: 0
> > > 
> > > ERROR: "of_irq_to_resource" [drivers/spi/spi-fsl-spi.ko] undefined!
> > > 
> > > Caused by 3194d2533eff ("spi: fsl: don't map irq during probe")
> > > which is missing its fix, 63aa6a692595 ("spi: fsl: use platform_get_irq()
> > > instead of of_irq_to_resource()")
> > 
> > Now added to 4.14 and 4.19 queues, thanks!
> > 
> sparc64:allmodconfig builds now pass in both v4.14.y and v4.19.y queues.

Wonderful, thanks for letting me know and running all of these
builds/tests.

greg k-h
