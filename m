Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6FB2807AA
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 21:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgJATXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 15:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 15:23:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C900520759;
        Thu,  1 Oct 2020 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601580230;
        bh=/kPOGbFQAg6NdGEpwS/e1rdoRf5Oode3dKCi3Ziva6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EkW6bY9cdOcy/n4EZMSWoUersMiHgSNHW62qjsAhVRhw8v7Ut7VTpPtFvG5C3Mpup
         mkk4wKt5WzCzBgiJejjkksX/r4je7P/8YyiPqp2CXQ6ldZYdALxTzVHTKLevma87fU
         jacf3cg2htfAt2GY86rIalkW2ziJZa/4PYR9ooAs=
Date:   Thu, 1 Oct 2020 21:23:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
Message-ID: <20201001192350.GD3873962@kroah.com>
References: <20200929105929.719230296@linuxfoundation.org>
 <20200929205446.GB153176@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929205446.GB153176@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:54:46PM -0700, Guenter Roeck wrote:
> On Tue, Sep 29, 2020 at 01:00:43PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.13 release.
> > There are 99 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 153 fail: 1
> Failed builds:
> 	powerpc:allmodconfig
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> powerpc link problem as usual. The fix has still not landed in mainline.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these and letting me know.

greg k-h
