Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B7D5E711
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 16:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGCOqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 10:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfGCOqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 10:46:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9041321871;
        Wed,  3 Jul 2019 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562165199;
        bh=AwY60TRJ/DmztBUPpaqXV1YeRzPfDnODBjapMjTOfik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxYrIwt8UyyWVDHyc/jRpOOCSexC/bnNpAzfLOWosFalXraZYjgGvj5Uyr+lcfE/r
         sRmXoI3WWBuVu2FnUDkYTCjK59uO1uSlmjAtOR8VKFbyT3472wyV8UkYSe8kndB4zX
         tFIYyVeXacvwQYWG/diZ97nCO6JFKKQTcFVcVLjE=
Date:   Wed, 3 Jul 2019 16:46:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.57-stable review
Message-ID: <20190703144636.GA24961@kroah.com>
References: <20190702080124.564652899@linuxfoundation.org>
 <20190702202300.GB29128@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702202300.GB29128@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 01:23:00PM -0700, Guenter Roeck wrote:
> On Tue, Jul 02, 2019 at 10:01:01AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.57 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Thanks for testing these and letting me know.

greg k-h
