Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5BA229880
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbgGVMtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:49:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE9E206C1;
        Wed, 22 Jul 2020 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422148;
        bh=y3/4VJCTRdIlYtphkAE/Gn/RBkNRjFdO0z0AevSXdDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R95PcF3fQb8RRElBysX344SHutjTptnkFKl5DK4fDoo+4qOVSdceuYQAA/W5HpTPN
         Io/MI+EDIlmspZ+jT13cgU9jOELZz6N0p9ruzumMfbEO+UQjrr+Ewwh4lpuHOSxUJH
         CTMyBJx7isU9/8GjSJPz8+j88gu5g9/aVqKHhdgU=
Date:   Wed, 22 Jul 2020 14:49:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
Message-ID: <20200722124914.GD3155653@kroah.com>
References: <20200720191523.845282610@linuxfoundation.org>
 <20200721163829.GF239562@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721163829.GF239562@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 09:38:29AM -0700, Guenter Roeck wrote:
> On Mon, Jul 20, 2020 at 09:16:26PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.10 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
