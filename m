Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6E252AB5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 11:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgHZJt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 05:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgHZJt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 05:49:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BBC020838;
        Wed, 26 Aug 2020 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598435395;
        bh=dd6Q3zJJql7kypnHGZytFgpvccuDSVcRkAXU2X/jP3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0KwvQzCYe03rvGJd0kCAOrTlSfXrUUZvF8PepqqIilmaoex7gd7b+KwpOE389fxV8
         fl/ffww/ym1wZM+t/xDoeeUcPm+IFASTAkt1WibCqIGpcq0mkNDt5QBlxJlJkoJbPP
         LfdooLSqVbSuEyKE22DyfQwEh/jABWXpkJEVxLLI=
Date:   Wed, 26 Aug 2020 11:50:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/149] 5.8.4-rc2 review
Message-ID: <20200826095010.GC2047935@kroah.com>
References: <20200824164745.715432380@linuxfoundation.org>
 <20200825192201.GG36661@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825192201.GG36661@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 12:22:01PM -0700, Guenter Roeck wrote:
> On Mon, Aug 24, 2020 at 06:48:20PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.4 release.
> > There are 149 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing them all and letting me know.

greg k-h
