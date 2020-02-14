Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9717215D220
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 07:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgBNGaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 01:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgBNGaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 01:30:16 -0500
Received: from localhost (unknown [12.177.140.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15FC92187F;
        Fri, 14 Feb 2020 06:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581661816;
        bh=ZcCBJlh/TLKyUSKu2p8+ChBwPr7bh6DlGzXvdSNF7qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fxyquLVZsT40CuN4elBJZIdqTtiA9vXwhmMF1EURdxKjyC56mk8JPONrI5pinsLli
         iG/YH/anwpA2s/GLdaTjNdJOuVkN3BhuMkZFGb8mowkpqGsEQdaYIvZHEw2Fds8H17
         0M6YpBM4QE8H/IirJfOCBbtYEoMiksJJZQvaU+aM=
Date:   Thu, 13 Feb 2020 22:30:15 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/52] 4.19.104-stable review
Message-ID: <20200214063015.GA3942495@kroah.com>
References: <20200213151810.331796857@linuxfoundation.org>
 <e6392d0f-5677-a470-3dd9-a1ccb3ea8b6f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6392d0f-5677-a470-3dd9-a1ccb3ea8b6f@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 09:28:44PM -0800, Guenter Roeck wrote:
> On 2/13/20 7:20 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.104 release.
> > There are 52 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 390 pass: 386 fail: 4
> Failed tests:
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:mem128:zynq-zc702:initrd
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc702:rootfs
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc706:rootfs
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zed:rootfs
> 
> Failures as reported separately.

-rc2 pushed out with the same serial fix as 4.14.y had, thanks.

greg k-h
