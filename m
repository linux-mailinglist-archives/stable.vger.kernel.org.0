Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC04B7338
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388254AbfISGgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 02:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388253AbfISGgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 02:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 724D421927;
        Thu, 19 Sep 2019 06:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568875005;
        bh=fNcpNjL3+ZaeqXWPPQOmDXQGgZuOBgJuqNOdnxawZFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VLa2aPoiLrHjHMKDa3PmNqHrmoyiY4FaxoCarVovCO/eJj4nHRCPFEG8xDHASapAd
         JCsOE0AxyjGjc5VDOkwFBRDks6xVeoZlFDxTEuhukLWOp3OKkkJWabX/7DTo+FyE66
         SXh/hQdv6fopGU+teVcOwHleu9qzMv5hWdck4z5o=
Date:   Thu, 19 Sep 2019 08:36:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
Message-ID: <20190919063643.GB2069346@kroah.com>
References: <20190918061234.107708857@linuxfoundation.org>
 <4ececdb6-6263-97d3-727a-39d89792634c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ececdb6-6263-97d3-727a-39d89792634c@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 07:22:50PM -0600, shuah wrote:
> On 9/18/19 12:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.16 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
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
