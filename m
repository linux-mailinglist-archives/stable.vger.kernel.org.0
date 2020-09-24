Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E2327776A
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgIXRGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 13:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIXRGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 13:06:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A582B238D6;
        Thu, 24 Sep 2020 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600967190;
        bh=QGHHjt3laS9Cal2zzVRmEFTHuxdzTVaeVSxpKSsS+HQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRVoe+V+iVpQ1og9mtsr6WTkUOIueO9RxsZYewGtzL2LAALlZPH5M4P9PqF3hBVYa
         B3eg9EPxE6vqcZHIirrureNKks6TdX+k+GYQ+dT1ga5t7tLVWx71mG5lCsyMFdTTyi
         1vgVK0Yaxqkd4O0B/jePOoP5UtXJ8OxkIRv/+NGI=
Date:   Thu, 24 Sep 2020 19:06:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
Message-ID: <20200924170646.GC1182944@kroah.com>
References: <20200921162036.324813383@linuxfoundation.org>
 <20200922201943.GF127538@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922201943.GF127538@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 01:19:43PM -0700, Guenter Roeck wrote:
> On Mon, Sep 21, 2020 at 06:26:52PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.11 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing them and letting me know.

greg k-h
