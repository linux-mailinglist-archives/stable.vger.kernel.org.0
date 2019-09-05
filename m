Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36475AABB9
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbfIETGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfIETGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 15:06:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB7E206BA;
        Thu,  5 Sep 2019 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567710383;
        bh=rvZKHxyj9aAVowVuJr4cLBs5aydsC0LnsEbKMoRFPdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BtVvt68cHZ9LBZTR/k3VsDPD3mnaBJQ5Lyc9S6Zm2bs5ytBKsQpXn3/YE3YTKTFec
         2HCuRqc04w/Wqj3Hmb8hiGkeRf//WvOUORRoezwhhHgiDDx98AW6f7LwQnU6rCMydj
         sxaeF492NwfJM4gqKrvqj/rbEEgrQPescYEpQJNM=
Date:   Thu, 5 Sep 2019 21:06:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
Message-ID: <20190905190620.GC24873@kroah.com>
References: <20190904175314.206239922@linuxfoundation.org>
 <a27a3bd5-8b11-8e7f-88ce-58444410f9a7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a27a3bd5-8b11-8e7f-88ce-58444410f9a7@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 09:00:47AM -0600, shuah wrote:
> On 9/4/19 11:52 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.12 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.12-rc1.gz
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
