Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D748F11C949
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfLLJhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfLLJhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:37:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374A9214D8;
        Thu, 12 Dec 2019 09:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143439;
        bh=9T8qbkKxvGdsgH/x9PIs2KKMJmn/JOtZtnDP7i1vdy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hRgDpX9Z8e16Qkn1Ta7Da8mvw31j+yI5Ls5qWySQkyZNXp9BCRSfp4a8PscoRiMXf
         gPkxlrxtJiSTMujgYESTy2uRJ2NN0oMrlBQmyvX8UtXLKXQmogNA7vxruvkLEM/gE4
         YvBjKVOKX2yl+Z7ueB0EnRsZDnMdiF9wKPCTZS+k=
Date:   Thu, 12 Dec 2019 10:35:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/92] 4.4.206-stable review
Message-ID: <20191212093530.GF1378792@kroah.com>
References: <20191204174327.215426506@linuxfoundation.org>
 <2959daae-72f2-8f85-df04-d6a0fe33516d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2959daae-72f2-8f85-df04-d6a0fe33516d@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:19:00PM -0700, shuah wrote:
> On 12/4/19 10:49 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.206 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Dec 2019 17:42:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.206-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> I know this is way late. I managed to boot 4.4.206 finally on my test
> system running Ubuntu 19.10.
> 
> It turns out, Ubuntu 19.10 defaults to LZ4 compression.
> 
> /etc/initramfs-tools/initramfs.conf
> COMPRESS=lz4
> 
> Enabling the following worked for me.
> 
> CONFIG_RD_LZ4=y
> CONFIG_SQUASHFS_LZ4=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_DECOMPRESS_LZ4=y
> 
> Stable release older than 4.19 will require the above change.

Ah, thanks for figuring this out.  Or you can run without an initramfs :)

greg k-h
