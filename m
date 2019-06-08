Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DFD39C23
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 11:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfFHJbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 05:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfFHJbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 05:31:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF844212F5;
        Sat,  8 Jun 2019 09:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559986297;
        bh=CGW5M0zjb3vwQmCJB27waGJ+UOGX2egStttcvy4+rzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XzsTdy9Ne1T0Y5DJjLHluX/AJAJpduqT6UdhHxB0nLiLEtjSEvyD7XPwE9EI4VpCS
         iS1tvGcsO7VOaIniyzFMYgVSkG5yBiYGpVySgQqng4Kcbz1RqGEkHVxmbvmaBCiPqd
         P+UUnLl22lhVbT4zJVAChDnnpaNd2yfpk88RvKcQ=
Date:   Sat, 8 Jun 2019 11:31:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/85] 5.1.8-stable review
Message-ID: <20190608093134.GC19832@kroah.com>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607201916.soitroxwy7ji523d@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607201916.soitroxwy7ji523d@rYz3n>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 03:19:17PM -0500, Jiunn Chang wrote:
> On Fri, Jun 07, 2019 at 05:38:45PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.8 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 09 Jun 2019 03:37:09 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.8-rc1.gz
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
> Compiled and booted.  No regessions on x86_64.

thanks for testing and letting me know.

greg k-h
