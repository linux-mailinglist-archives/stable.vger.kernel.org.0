Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3A013AD5D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgANPSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgANPSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 10:18:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A08222C4;
        Tue, 14 Jan 2020 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579015089;
        bh=ympg1hiVbMKbw9k2iIFP+5ggi34Gv3Oy1HvJ7tLTdGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cm6kyE9IES+mOy15gjTzAxr2xbZNWxqa50M85aszKRHM+WxHSfw56lscy4+QN2xXF
         40/xkvMmrZTJwbeBAPAHL742GRIaRFbEpVYrldt0nBOCyGY8Htm/GKcXONWdV1OxgK
         5BUmWs8sneQsEb5PqEfE0KlBsD7vfiARnqQ/ayfQ=
Date:   Tue, 14 Jan 2020 16:18:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
Message-ID: <20200114151807.GA2029513@kroah.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <67098cc6-6b86-c441-065a-2cb7fe9a2be6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67098cc6-6b86-c441-065a-2cb7fe9a2be6@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 03:02:56PM +0000, Jon Hunter wrote:
> 
> On 14/01/2020 10:00, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.12 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail

Wonderful, thanks for the testing and quick response.

greg k-h
