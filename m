Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221B62BC49B
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 10:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgKVJM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 04:12:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbgKVJM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 04:12:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7995620781;
        Sun, 22 Nov 2020 09:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606036347;
        bh=y0P3E2ulAiaPfLJoIISH62VTXDSJ6Qi2CaBDYJnwnFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0bzZMK2gcAU8VHDh0GaUxkPUlL1Jdqb/IXMgRcFn9Fmm576uMFxt6k+N5NNrZNHJL
         /yzJ33LrzrOTsmjttYuJq6/FDrWMXtxWk2lA7i//jGYQMa3s4Omsvtrjp94RQsGwfs
         0g/KFJRUJXjujXc6DRfTwGVBhsjRRD9fzWkRkdrc=
Date:   Sun, 22 Nov 2020 10:13:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/14] 4.19.159-rc1 review
Message-ID: <X7oroFpo2hQmn3Gz@kroah.com>
References: <20201120104539.806156260@linuxfoundation.org>
 <20201121083723.GA22875@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121083723.GA22875@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 21, 2020 at 09:37:23AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.159 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> But reviews indicated two patches that are problematic in 4.19:
> 
> rc-v4.19.155.list: fd2278164808 o: | memory: emif: Remove bogus
> debugfs error handling
> 
> - debugfs still returns NULL in 4.19 so this introducesbug. Itis
>   just a cleanup so it can be reverted.

This can stay, the code still works correctly with this patch applied.

> rc-v4.19.156.list: 7d5553147613 o: | drm/i915: Break up error capture
> compression loops with cond_resched()
> 
> - code still needs to be atomic in 4.19; this probably depends on
>   a42f45a2a, see _object_create(). It does not fix anything severe so
>     it can be simply reverted.

It does not hurt anything either, right?  Have you noticed any
regressions with it applied?

> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing these.

greg k-h
