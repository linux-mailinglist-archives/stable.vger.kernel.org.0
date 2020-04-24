Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4281B7052
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgDXJMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgDXJMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:12:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC0082076C;
        Fri, 24 Apr 2020 09:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719554;
        bh=t0Et9NuUznj1yMEWKlEsvCLzBff1vdHhFUTvncIdPYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mm80pggYax7dmYkrA2bmeVQyluscZvE3t+nc20G9kdnlBcI5ZjS/BSeGNbI01b9Ns
         3EN2XVxIA1v7KxG+lcPFsHYAY+ehMlglYh5y2rJwlQLwJwmBuyxnFAtDDVaDw4M7iI
         EIkyJXlc2hrcoiExKmvptL5gUpoyJu+NEccDiHRg=
Date:   Fri, 24 Apr 2020 11:12:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/166] 5.6.7-rc1 review
Message-ID: <20200424091231.GA359097@kroah.com>
References: <20200422095047.669225321@linuxfoundation.org>
 <20200422203644.GD52250@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422203644.GD52250@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 01:36:44PM -0700, Guenter Roeck wrote:
> On Wed, Apr 22, 2020 at 11:55:27AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.7 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Thanks for testing all of these (including the -rc2 versions) and
letting me know.

greg k-h
