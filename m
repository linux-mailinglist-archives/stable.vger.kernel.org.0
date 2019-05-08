Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB392171B8
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 08:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfEHGg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 02:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbfEHGg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 02:36:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0F9821019;
        Wed,  8 May 2019 06:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557297386;
        bh=LbO4Mm5KufISq1++VGUq0xk5CL1TBZ3yI3ubMIebd28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WyG1mRHfrZMUZ7WBYO6bByptDkThaquaXj+aCCZgFL91SCSS+TkDh2cc2ceOsntIV
         xzdQVWVqAEpD8I3xWGKyz8qyOxUFdv7x3CaxJXlJhSpNllf+DAsGt3iwzCmDZvR3T2
         IlRF7LHnyyd14t8Sz6TxtgIo+Kwm1md4eGvwExW8=
Date:   Wed, 8 May 2019 08:36:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/122] 5.0.14-stable review
Message-ID: <20190508063624.GC28651@kroah.com>
References: <20190506143054.670334917@linuxfoundation.org>
 <20190508005558.GA2689@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508005558.GA2689@asus>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 06:56:00PM -0600, Kelsey Skunberg wrote:
> On Mon, May 06, 2019 at 04:30:58PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.0.14 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 08 May 2019 02:29:09 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Compiled, booted, and no dmesg regressions on my system. 

Great!  Thanks for testing and letting me know.

greg k-h
