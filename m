Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5874E2E77E4
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 11:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgL3K4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 05:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgL3K4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 05:56:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9656922225;
        Wed, 30 Dec 2020 10:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609325775;
        bh=Gw8mIJ4Tki858u/BW/Nw3TSwmCq5UMaSYZks4bmp2as=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BVDdvNhDKbAu2EiDL0EcBA67LemNoXTIxXePSdN1Ll33dsQCJlzbeLFevhjHf7b0s
         LCWte45sjhmhe7a87gGxnoNwpsIbfXzRGgtK+gurQ8o1qWjx7uwLpQi7ERxmNEZ3bi
         YSKJtP6/u5gqkzFH12UDegwwQuXNcGZZ9MmU6LnE=
Date:   Wed, 30 Dec 2020 11:57:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 000/716] 5.10.4-rc2 review
Message-ID: <X+xdJkfpzsrn5fuk@kroah.com>
References: <20201229103832.108495696@linuxfoundation.org>
 <923e3123-7247-f8e5-8bbb-67f5e43c3b7d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <923e3123-7247-f8e5-8bbb-67f5e43c3b7d@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 02:15:32PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 12/29/20 4:52 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.4 release.
> > There are 716 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 31 Dec 2020 10:36:33 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.4-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions detected.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanksf or testing and letting me know.

greg k-h
