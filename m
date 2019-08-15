Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645188F4C9
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 21:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHOThw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 15:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbfHOThw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 15:37:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E78572083B;
        Thu, 15 Aug 2019 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565897871;
        bh=v0ACJuoWQU5RAFwW7Y92jbObD6HXuwQ6z3LCH1a7Fgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0V73gtRmvyOg4wUkTqphFCsFcz8qg2rADtLApk/0zW3eSuu7V+TcAqODOO8CyGAo
         6mLD/K3thofCzmJ/KU5jip0BV3UKPDMNJ0Luj9bR5QGmn6mfzU3XKWHVzK9j5KS58F
         i/WSHHy2QSHRQoK9eg6dTUVdxC9MAGK0ms2y665s=
Date:   Thu, 15 Aug 2019 21:37:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Message-ID: <20190815193749.GH30437@kroah.com>
References: <20190814165759.466811854@linuxfoundation.org>
 <20190815151822.GC23562@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815151822.GC23562@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 08:18:22AM -0700, Guenter Roeck wrote:
> On Wed, Aug 14, 2019 at 06:59:16PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.9 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
