Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090A675FBF
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfGZHYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfGZHYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDF5921873;
        Fri, 26 Jul 2019 07:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564125888;
        bh=ZK3KTuT3OeX0DMxggFFkQipsUQ2Hi/tyIAUbMqmggPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yw4k2k5jjXypC8c7lASEKpWEl7Ei+Uk64e8h30msNAuuPf1SlqU8QxPFZGU70ytEL
         7u/zdYf9zJgJeyDR0kl6wA9TdHsAh1KLXZ+6S1sdsFJdaTjTG594JXydysuMZi39AV
         ucX2aJZ2ztrDEhEn72pzUbFsagYM8mfjaZM26blY=
Date:   Fri, 26 Jul 2019 09:24:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190726072444.GB19756@kroah.com>
References: <20190724191724.382593077@linuxfoundation.org>
 <20190725221859.GA31733@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725221859.GA31733@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 03:19:00PM -0700, Guenter Roeck wrote:
> On Wed, Jul 24, 2019 at 09:15:52PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.20 release.
> > There are 371 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> For v5.1.19-370-gfb6ea525ffcf:
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Wonderful, glad it is all now working.  Thanks for testing all of these
and letting me know.

greg k-h
