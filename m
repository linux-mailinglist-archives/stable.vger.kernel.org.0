Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49251B84FB
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 10:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgDYI6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 04:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgDYI6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Apr 2020 04:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA06F20700;
        Sat, 25 Apr 2020 08:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587805121;
        bh=cH4m0D2ZoZm/Y5xn9XGDqkem/KWhRgE9RnlhLe6jTZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rEYJxwMWLS1I0kYasgNsgOkSmX0ZaBZH/7dsBMsB+JHTbM89MhG5rqaP0IYJ6R42b
         BFvi+sOmzuDDqtWOyAk3EmF8zQ4xI9AQU/T/oWgk8ihAtOfwSRD2WCNo0tlQM4bP44
         4KLybxnLBuFJdR2BTgCK5eyX5VGrApLqs14t9nTM=
Date:   Sat, 25 Apr 2020 10:58:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/166] 5.6.7-rc1 review
Message-ID: <20200425085838.GA2052830@kroah.com>
References: <20200422095047.669225321@linuxfoundation.org>
 <4e438765-b045-4201-8a6a-4ab0b986b753@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e438765-b045-4201-8a6a-4ab0b986b753@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 10:24:25AM -0600, shuah wrote:
> On 4/22/20 3:55 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.7 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
