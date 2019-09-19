Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF9B733C
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 08:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbfISGhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 02:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388106AbfISGhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 02:37:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098BE218AF;
        Thu, 19 Sep 2019 06:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568875053;
        bh=VPa0SrjRAhGZf8NCwjxSVaQoJjEkf1i9PHrA6nQ5yzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o1S4aK0m/AC3hTJONsLlHbkr0DLMpR06I3zmB7a74oO+6RZ3x3rLtBKt5PfDVEJ03
         h5Cce6WQwmGJyXPL1NsDnOmvYT4sl2IICPSExMfSmU0Fh0Z/3L268+yeedgEAFHrF0
         /4B2qcfAG1m7Co2uoVGhQWIP4OD1zmG+edirLWdQ=
Date:   Thu, 19 Sep 2019 08:37:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/50] 4.19.74-stable review
Message-ID: <20190919063731.GD2069346@kroah.com>
References: <20190918061223.116178343@linuxfoundation.org>
 <20190918193749.GB30544@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918193749.GB30544@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 12:37:49PM -0700, Guenter Roeck wrote:
> On Wed, Sep 18, 2019 at 08:18:43AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.74 release.
> > There are 50 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> For v4.19.73-51-g7290521ed4bd:
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Great, glad that got fixed up.

Thanks for testing all of these.

greg k-h
