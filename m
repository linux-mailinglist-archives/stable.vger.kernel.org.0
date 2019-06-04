Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD02933EA0
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 07:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFDFvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 01:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFDFvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 01:51:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA252064A;
        Tue,  4 Jun 2019 05:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559627502;
        bh=Ho4NZbUu0u4gQkEBJFJioxxYEobaRotRU59jpHOk48Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1ZJP+m5a0H2RwbqdH59RJcCbyPTO9WHSngp6XF5wkf1/IUknqSXcfQiHinsOy4WQC
         nsY7ppos9z7y/OeVByaYNDl5LQoACRLChSjqKmwWWtRLIQ5zzxjSsrTczSHOYhXWWB
         /3wSfU//iiTLDtZ9yx/kO/y+TVR0DMJWlN+mqz5g=
Date:   Tue, 4 Jun 2019 07:51:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
Message-ID: <20190604055139.GF16504@kroah.com>
References: <20190603090522.617635820@linuxfoundation.org>
 <20190603171728.GC4704@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603171728.GC4704@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 10:17:28AM -0700, Guenter Roeck wrote:
> On Mon, Jun 03, 2019 at 11:08:53AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.7 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 349 pass: 349 fail: 0

Wonderful, thanks for testing these and letting me know

greg k-h
