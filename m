Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1128DE0E
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgJNJ4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgJNJ4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:56:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D8B207C3;
        Wed, 14 Oct 2020 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602669408;
        bh=Ei9jmuic2Uoy01apYyoIpzoRBIt/TOAMw81NWAkBW10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gorDfJnkc1LwU/Q0gjsXHmjzSSL3YcW371Csm7sR35ijMHpxBb5e4cEz8tHEVsWKw
         P215RXQsAwWEf3nvHU1FAEGzMuf70icySYk6nCc/0U9J4i6icingQEHxy9AxhoalxO
         GyqN+pxNOzMrbc5/WDXn8vmsfm44JV54hpAjFd20=
Date:   Wed, 14 Oct 2020 11:57:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
Message-ID: <20201014095723.GD3599360@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
 <20201013164131.GF251780@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013164131.GF251780@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 09:41:31AM -0700, Guenter Roeck wrote:
> On Mon, Oct 12, 2020 at 03:30:04PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.15 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 

Thanks for testing all of these and letting me know.

greg k-h
