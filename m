Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414621382BE
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 18:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgAKRvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 12:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbgAKRvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 12:51:40 -0500
Received: from localhost (unknown [84.241.193.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D801A2084D;
        Sat, 11 Jan 2020 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578765099;
        bh=jx3kcM6qGze6CYM2SBoNSYF7Vp/HAkC1tNSfVTZLE2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHJWaTnIaS1MKqb4zE7vw8djtMlCzhp4QAUmrseAjPJflRU5K4Zntgz3lfS4z70hZ
         FdmD0KwTxMl16PqPkn6pGRTFb88+AOg4IP144/LzEEzC+/h0Q4SOWz6BtbpuZ0E6TO
         kn4RIYyCZsoL32mNO5iR2UzsKfLA7Kc9WmKMyVZQ=
Date:   Sat, 11 Jan 2020 18:51:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/91] 4.9.209-stable review
Message-ID: <20200111175114.GA403776@kroah.com>
References: <20200111094844.748507863@linuxfoundation.org>
 <0668a7b6-502b-719b-a2eb-59519de7bf3e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0668a7b6-502b-719b-a2eb-59519de7bf3e@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 11, 2020 at 07:44:31AM -0800, Guenter Roeck wrote:
> On 1/11/20 1:48 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.209 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 172 pass: 169 fail: 3
> Failed builds:
> 	arm:allmodconfig
> 	arm:u8500_defconfig
> 	arm64:allmodconfig
> Qemu test results:
> 	total: 358 pass: 358 fail: 0
> 
> drivers/hwtracing/coresight/coresight-tmc-etf.c: In function 'tmc_alloc_etf_buffer':
> drivers/hwtracing/coresight/coresight-tmc-etf.c:295:10: error: 'event' undeclared

Ugh, I thought I dropped those earlier, but they came back through
Sasha's autosel.  There's another build error with another coresight
patch in there too, looks rare enough that your scripts didn't catch it
:)

I'll go push out a -rc2 now with the offending patches dropped.

thanks,

greg k-h
