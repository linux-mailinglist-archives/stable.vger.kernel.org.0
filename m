Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD13A49DBCF
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiA0HpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:45:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38874 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiA0HpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 02:45:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B1161A00;
        Thu, 27 Jan 2022 07:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC32C340E4;
        Thu, 27 Jan 2022 07:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643269518;
        bh=Pn6SdFQhWRIFVHlZ099gr5Yj9PEQL6cWl2zcqtxdzXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bxVOnLftM90mM4IL9e11P7kFkyhSy8BmhyayYWQVenk5zhWRSRyPU4E6GrZ1PMnkm
         3I7/WQfOHSJexmCFXxyb/9pKskJEytm1/mrpIrnuNm2kqKTyFGY24r4kXlK+FrxM2A
         t3s2oshOUGN0VcsZ68qcZZasPeOgqSmpgMsQXdTc=
Date:   Thu, 27 Jan 2022 08:45:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
Message-ID: <YfJNiyEJNMNwhkpK@kroah.com>
References: <20220124183927.095545464@linuxfoundation.org>
 <abdecad5-9733-033b-e911-d692fef42ed0@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abdecad5-9733-033b-e911-d692fef42ed0@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 01:25:29PM -0800, Guenter Roeck wrote:
> Hi Greg,
> 
> On 1/24/22 10:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.300 release.
> > There are 114 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > Anything received after that time might be too late.
> > 
> 
> A new version of this branch was pushed into the stable-queue git
> repository around 10:30 PST, AFAICS without any actual changes.
> This caused all my builders to start from scratch (again).
> Would it be possible to avoid such dummy pushes ?

I'll try to avoid it, but it is usually easier for me to do "generate
all -rcs and push them out", than do to them individually, which is why
this happened.

sorry,

greg k-h
