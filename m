Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC87887586
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 11:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405723AbfHIJR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 05:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbfHIJR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 05:17:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DCA321743;
        Fri,  9 Aug 2019 09:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565342278;
        bh=eMbXzOzbe31w1KTgLGkUFV9OMI7J0VYsbFxLFuNbMTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ge1o1L5BEfciq/lxTeqGUs38TkHyWCwCZHBC+k19uTKHl/B1Lbpo5xhhga3JwRg3b
         voVsf1uD7ZPZmeVZVDvVm6ZDHDL550qvT4IotGDYEjBwaRiJeyXxg7ZzaVMw0yWx4f
         0vmDQ/JmTQXFsgm06KAlQDX0GZd7bKX4MKDYhKww=
Date:   Fri, 9 Aug 2019 08:30:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/56] 5.2.8-stable review
Message-ID: <20190809063021.GA2378@kroah.com>
References: <20190808190452.867062037@linuxfoundation.org>
 <c3469416-8f7f-6281-0a28-ee0e1ff4bdf9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3469416-8f7f-6281-0a28-ee0e1ff4bdf9@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 06:36:13PM -0600, shuah wrote:
> On 8/8/19 1:04 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.8 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
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
