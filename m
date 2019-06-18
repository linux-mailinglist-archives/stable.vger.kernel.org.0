Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5174A96E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbfFRSGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 14:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729491AbfFRSGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 14:06:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C2782084A;
        Tue, 18 Jun 2019 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560881202;
        bh=yfcudZ+ucn3bTGDOuYYL1wZnSM5wsihhuo0WtmveN0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZwfNeHOzYEUk4GBIH2rR2l002Q2Fh2JZaYBlytLihL4W37FSG4x0XGjpO8NQoFKXb
         cPEdqifNKLBYjouGUpXUB5g2cv6K/ZZI2DlNxWlTzaO8VnTVxtwvrnSzUCgYPMTG7P
         lLrtDNiRUhCgDO9LSdJTXBgZib6zGUS4fzQqW1jA=
Date:   Tue, 18 Jun 2019 20:06:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
Message-ID: <20190618180640.GE31484@kroah.com>
References: <20190617210759.929316339@linuxfoundation.org>
 <20190618163832.GC1718@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618163832.GC1718@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 09:38:32AM -0700, Guenter Roeck wrote:
> On Mon, Jun 17, 2019 at 11:08:20PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.12 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 366 pass: 366 fail: 0

Wonderful, thanks for testing and letting me know.

greg k-h
