Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BD61898B1
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 10:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCRJ67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 05:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbgCRJ67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 05:58:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A84120767;
        Wed, 18 Mar 2020 09:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525538;
        bh=BUZ/zIzr3Kz0ae3sm0O5mAskglcwun1m05963pBsQrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RAM4i531bj5ZJvBVFS9QIqy+HzHW5mVhKwAEHP0MvlNb2FxVZmFw8lkEGTe7gNG/V
         U/09ml6Zr5DinI6uReAwNal6lyL5OGbCEDW7L+d+xOPOAN/tGQ/blv3BIeSHBNCS9N
         TmVdYzySFx4ImGaMtax0ZJ1bw8BoBHPKdkhC0G+M=
Date:   Wed, 18 Mar 2020 10:58:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/151] 5.5.10-rc1 review
Message-ID: <20200318095856.GA2034476@kroah.com>
References: <20200317103326.593639086@linuxfoundation.org>
 <e2dadcaa-adba-7472-edf5-5e34c7f5e59b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2dadcaa-adba-7472-edf5-5e34c7f5e59b@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 06:01:12PM -0600, shuah wrote:
> On 3/17/20 4:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.10 release.
> > There are 151 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.10-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
