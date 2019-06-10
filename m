Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F355F3AECE
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 07:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbfFJF5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 01:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387667AbfFJF5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 01:57:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B745207E0;
        Mon, 10 Jun 2019 05:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560146226;
        bh=gVSjw6cdQb6viXKvlgOAwxtKB7Vv7gaxQtNRY9At4+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnpViJzd0Fh/QqWnMiJw6azEXk6YjpqzDENORTkQ7Uc1aXVEQQViJqHZupxW/w1C8
         0jpKlFBF4gaGpdA/4Gj+qW6eSCJo4X1viyX6JZfZNzs5q+O8GJOoYnu1SS+eJbS/nI
         lmm2il7qbGRbGgHovP008rcSaXjFGo6IF23+5tVc=
Date:   Mon, 10 Jun 2019 07:57:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190610055704.GE13825@kroah.com>
References: <20190609164127.541128197@linuxfoundation.org>
 <20190609223737.2gaz62e3q2yp2ruy@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609223737.2gaz62e3q2yp2ruy@rYz3n>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 05:37:37PM -0500, Jiunn Chang wrote:
> On Sun, Jun 09, 2019 at 06:41:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.9 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Compiled and booted.  No regressions on x86_64.

Thanks for testing and letting me know.

greg k-h
