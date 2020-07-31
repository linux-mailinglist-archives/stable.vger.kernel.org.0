Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB92349F8
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 19:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbgGaRPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 13:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732710AbgGaRPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 13:15:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B8102074B;
        Fri, 31 Jul 2020 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215716;
        bh=cWx1hbEGaUUwS1JJFnOe3X+vRj6dABujYkU2GC/oakE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z8Batu5lPaUADFtk2YKU0dGwnmNAwaJlBCPAHopU4fD4FFJvbU2/tsIgH2XxtdR3X
         GSV9g73r7DSHzcHssgFtV+ZVm9wvUx9dmnDFO1UbwCP2zVaZ/VslUMZi6q1jaWfuaZ
         z1zBwgDg8FHfI/LzqcI2WeqaVg6l/F+qoJWF+sUc=
Date:   Fri, 31 Jul 2020 19:15:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 00/20] 5.7.12-rc1 review
Message-ID: <20200731171503.GA2012979@kroah.com>
References: <20200730074420.533211699@linuxfoundation.org>
 <20200730164823.GF57647@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730164823.GF57647@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 09:48:23AM -0700, Guenter Roeck wrote:
> On Thu, Jul 30, 2020 at 10:03:50AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.12 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
