Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41197D3986
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJKGrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfJKGrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 02:47:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5814214E0;
        Fri, 11 Oct 2019 06:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570776457;
        bh=F9PU0iHZAUB5dvz6HHkRKuomppsyOg6pcXNb0u08bIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FTrf686pbZT2wz3fFzvKWjUlhlSXy454F43VPSiXXYA55vcFPEwU6p0RymCiCFp78
         DsVPxawfE0xYni3UyULz7O3wqLmopAr54UEk3Qk/TJy/wl4UNDBkapz2Ir2kUdl+Fj
         Can7/msPBnheQRI/bz+lRMbeCWZ39/pQgyspIgFE=
Date:   Fri, 11 Oct 2019 08:47:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/148] 5.3.6-stable review
Message-ID: <20191011064734.GA1064179@kroah.com>
References: <20191010083609.660878383@linuxfoundation.org>
 <ac86815e-774a-7655-0619-9d3cae5e9ba0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac86815e-774a-7655-0619-9d3cae5e9ba0@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 09:02:45PM -0600, shuah wrote:
> On 10/10/19 2:34 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.6 release.
> > There are 148 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing these and letting me know.

greg k-h
