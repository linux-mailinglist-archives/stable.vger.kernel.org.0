Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0EB12F9E4
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgACPmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbgACPmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 10:42:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F3B222C3;
        Fri,  3 Jan 2020 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578066120;
        bh=E6bkP2iLtXcpJMcX8Se1oy9jd3znrWQRpOblbHywcP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XrC3JbJ2Ab1dRvJXkRDe2XDLuLr892OkN4/27W0uZs/3So2/oxxlXcQUoqZlOfndz
         qRH6eO/P4AoBRkMacSg5D0cHtjkxgjgBAA1kznAIS1s95h6lXRh8xjKPTo0mQ43xii
         MqWxHSPKRcLnHYLg+BCilQ47VuukIk6b+FVyOyjw=
Date:   Fri, 3 Jan 2020 16:41:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
Message-ID: <20200103154156.GA1064304@kroah.com>
References: <20200102220029.183913184@linuxfoundation.org>
 <72f41f89-bf68-d275-2f1e-d33a91b5e6cd@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72f41f89-bf68-d275-2f1e-d33a91b5e6cd@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 06:27:53AM -0800, Guenter Roeck wrote:
> On 1/2/20 2:06 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.93 release.
> > There are 114 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 04 Jan 2020 21:58:48 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 155 fail: 1
> Failed builds:
> 	sparc64:allmodconfig
> Qemu test results:
> 	total: 381 pass: 381 fail: 0
> 
> ERROR: "of_irq_to_resource" [drivers/spi/spi-fsl-spi.ko] undefined!
> 
> Caused by 3194d2533eff ("spi: fsl: don't map irq during probe")
> which is missing its fix, 63aa6a692595 ("spi: fsl: use platform_get_irq()
> instead of of_irq_to_resource()")

Now added to 4.14 and 4.19 queues, thanks!

greg k-h
