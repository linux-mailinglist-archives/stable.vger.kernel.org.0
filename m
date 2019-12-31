Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3AB12DA45
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 17:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfLaQS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 11:18:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfLaQS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 11:18:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9075E205ED;
        Tue, 31 Dec 2019 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577809107;
        bh=+kbr+nf+uJvJOXADvACxtkLghF7h5c2QbuCJOlC25Tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kr+pPRHFn5yWepMZJJr6gK2P4NCtXvjOCacTGjc3ygfmD6nUcglCZ5oA9OQmDMMQi
         Hb1s1tCbpcWEVUQVhi0MDtRnXyRQRFAqw9QG4kMM1QCK3wfCZxy78oViL7CfZWI7YN
         4ckodXftfLT/OpoMdt7PLrGCS3Pqae/lIgNHiNMw=
Date:   Tue, 31 Dec 2019 17:18:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
Message-ID: <20191231161824.GA2279398@kroah.com>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191231160519.GB11542@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231160519.GB11542@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 31, 2019 at 08:05:19AM -0800, Guenter Roeck wrote:
> On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.92 release.
> > There are 219 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> > Anything received after that time might be too late.
> 
> For -rc2:
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 381 pass: 376 fail: 5
> Failed tests:
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:initrd
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:ide:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:sdhci:mmc:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:scsi[DC395]:rootfs
> 
> Bug-for-bug compatible with mainline. That makes me wonder if I should
> stop testing those ppc images instead of being annoyed by the failures.
> Thoughts ?

I think the ppc developers need to fix the issues.  Or just mark the
configuration as obsolete and remove it from mainline?

thanks,

greg k-h
