Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC654140F87
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 18:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgAQRAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 12:00:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgAQRAb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 12:00:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A77E32072B;
        Fri, 17 Jan 2020 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579280431;
        bh=RqOFGmGnIfFWZE56tDRBKVPwq0kMm35arEdloyC37u4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CkTYeXObPX49mGOrUKXpOPitz/5yDS5KxB+XUev0BatVDxubG7MU+PGTGzFGEUJSM
         6bwu8bEKRlnAqAAx6Ltf23azPHKUbfJr/Lucu9bdi0Ugzj9b/HBTgT27NbgY2eTijZ
         iUWcsW3IVcsZjSXEoKL4CeuuhNJEeZ8u6C+lkaMI=
Date:   Fri, 17 Jan 2020 18:00:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/203] 5.4.13-stable review
Message-ID: <20200117170028.GA1952110@kroah.com>
References: <20200116231745.218684830@linuxfoundation.org>
 <456d28d9-1a50-5445-bfaf-9d87bfeb185f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456d28d9-1a50-5445-bfaf-9d87bfeb185f@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 09:05:13AM -0700, shuah wrote:
> On 1/16/20 4:15 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.13 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
