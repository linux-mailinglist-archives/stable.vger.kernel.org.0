Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9233006A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhCGLjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhCGLhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:37:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7872E64FCC;
        Sun,  7 Mar 2021 11:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615117075;
        bh=38duZBm0F47o5nZhY69bfHxeJMiTkBH1qvyVSK6kols=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BVwlm2dFqtgr6i9ZPkXKzFhUPYkIPIpIm0K5i/0aIo6z4lM5DzTzHucINL7DAEIEo
         7a0Q3Jazg2mZTCsSTUqz/BSmv1ls9sPo1lOTqSsF8zY1pVaJ3s6oLRpPBNe9/T7w42
         AyLlANk46VCclH6QSXLI2poaXfsLzI/Z6zRKsGNE=
Date:   Sun, 7 Mar 2021 12:37:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/104] 5.11.4-rc1 review
Message-ID: <YES7ELO2Fqfo1LtW@kroah.com>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210306163956.GA26313@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306163956.GA26313@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 06, 2021 at 08:39:56AM -0800, Guenter Roeck wrote:
> On Fri, Mar 05, 2021 at 01:20:05PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.11.4 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 435 pass: 435 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these.

greg k-h
