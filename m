Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2E87E70
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 17:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436668AbfHIPsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 11:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436655AbfHIPsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 11:48:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9931F20C01;
        Fri,  9 Aug 2019 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565365726;
        bh=dVcmiKw0Zp4IJqjjXC3ZGRrvdaZkAfiqJ/aCcb22S2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wOKNjlfguQiz7nfWTMeSxhyzOKm12YJ/Ixhtxs11TDhJNr7E4NKJV1PmP6gXSFHK1
         IA6xYvqMWXNpn/EiGXnDOg5tNGMITnhZ+KbX8FPGtyhPw43DqjkhLECdefWIX5uJWx
         BdtZ3qYqblWwr7vRL/loZNLrg9Gab89CqKkU2r9c=
Date:   Fri, 9 Aug 2019 17:48:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/56] 5.2.8-stable review
Message-ID: <20190809154843.GB22879@kroah.com>
References: <20190808190452.867062037@linuxfoundation.org>
 <20190809153730.GC3823@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809153730.GC3823@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 08:37:30AM -0700, Guenter Roeck wrote:
> On Thu, Aug 08, 2019 at 09:04:26PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.8 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
