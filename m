Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2831A6BB
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 07:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfEKFrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 01:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfEKFrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 01:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 611532173B;
        Sat, 11 May 2019 05:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557553635;
        bh=/l3X41U8y02nYAObqpTRmE+LYkUHaWu6DqLimyVR//Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y60gIEroZfTdCsUtPZs38FNk4ah+NibXkdx9XQnqC9EykfrSIVFtwNXv4TDZ93Hpk
         wFMUVbbx1ZegXPiVsKA0nR8cvQSREMhN+bIXyyzXRfqODvX9leeJYSMJENNcm/BNh3
         kULgA4Da9b+nmiCU65pcjWFVvuW9gGzR8pN7IvRo=
Date:   Sat, 11 May 2019 07:47:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
Message-ID: <20190511054713.GA14153@kroah.com>
References: <20190509181250.417203112@linuxfoundation.org>
 <20190510164623.GB21034@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510164623.GB21034@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 09:46:23AM -0700, Guenter Roeck wrote:
> On Thu, May 09, 2019 at 08:42:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.1 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 349 pass: 349 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
