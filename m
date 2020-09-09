Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204A1263531
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgIISAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgIISAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:00:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72F021D46;
        Wed,  9 Sep 2020 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674414;
        bh=/od97QU4j5gIbyc2XC5wtjt5niD3XibN2goJI7ZBqsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HEqb4Cth+SDmb8tk04OIY2x8keXt5AxTySFEePo3y21voysy+rSk2fHXvbhd4DfII
         mOfpMHUE5YNi0PV+DFQgvhsBaM5W78XW2HIWq+Koop2fdiPnCXUM4rjKXMEyL9MZO3
         nGyIjGxHhHjH6BMOq0NpAK9NeExiQj09etquc9k8=
Date:   Wed, 9 Sep 2020 20:00:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
Message-ID: <20200909180023.GA1003763@kroah.com>
References: <20200908152241.646390211@linuxfoundation.org>
 <a2949ad4-fa8f-1944-7835-4cb5e4c4134e@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2949ad4-fa8f-1944-7835-4cb5e4c4134e@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 07:39:08PM -0600, Shuah Khan wrote:
> On 9/8/20 9:22 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.8 release.
> > There are 186 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing all of them and letting me know.

greg k-h
