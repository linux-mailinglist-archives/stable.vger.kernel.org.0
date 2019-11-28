Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2821A10CC50
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfK1P7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 10:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfK1P7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 10:59:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E4592158A;
        Thu, 28 Nov 2019 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574956791;
        bh=9hSihV5nKtWpMwgXvlJvqVvYGlCxsQfuFo+8JDyk0us=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LRnZmfnPlQRKQJro0FAbreMibc8TCGvD1hpH1ouiT+IkY3Ce8v4ccP6y6/nU2kDe2
         Ux3Bs9FEy3+qg34nljOf9gYmOg/7eVxMbri3oZF33Gv5/T3xGTz6VT/62WMTfD0KqH
         WlV1A9MGFMZjA5T/Q5xECeuHxYhOKo2GZ/I5OLLU=
Date:   Thu, 28 Nov 2019 16:59:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/95] 5.3.14-stable review
Message-ID: <20191128155948.GA3418086@kroah.com>
References: <20191127202845.651587549@linuxfoundation.org>
 <573a667c-2f94-568e-b032-5c7860adaed4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <573a667c-2f94-568e-b032-5c7860adaed4@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 08:47:51AM -0700, shuah wrote:
> On 11/27/19 1:31 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.14 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> It didn't boot. Panics in netns_cleanup_net()?
> 
> I am attaching a screenshot for the panic. I will try rc2 and see
> if it improves things.

-rc2 should fix this, if not, please let me know.

I also did -rc2 for 4.19 and 4.14 with this fix.

thanks,

greg k-h
