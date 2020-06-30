Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F5320F86F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgF3Pdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389449AbgF3Pdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 11:33:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0673B2074F;
        Tue, 30 Jun 2020 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593531217;
        bh=TypKxZAmsSNCLbi44qY9lLva7pPVMmEcQU2SNc5IMDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PWruNt0q0Wzctyaqc1YJHABpFnz2FjV8orruPzoZFyuQbvW3GjcZ/oE4YTAWlAKHE
         T4ayXCeiAs9ddCncQXsWuT0EWnHvPX6JkaRGGLJflEpygNQiwKa11hj6NDbGrnRMy/
         WA6Skx5YUb396LB3JeDLc96h55pWIOS3MshIWtkw=
Date:   Tue, 30 Jun 2020 17:33:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
Message-ID: <20200630153325.GA1785141@kroah.com>
References: <20200629151818.2493727-1-sashal@kernel.org>
 <42dadde8-04c0-863b-651a-1959a3d85494@linuxfoundation.org>
 <20200629231826.GT1931@sasha-vm>
 <20200630083845.GA637154@kroah.com>
 <20200630151248.GY1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630151248.GY1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 11:12:48AM -0400, Sasha Levin wrote:
> On Tue, Jun 30, 2020 at 10:38:45AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 29, 2020 at 07:18:26PM -0400, Sasha Levin wrote:
> > > On Mon, Jun 29, 2020 at 02:37:53PM -0600, Shuah Khan wrote:
> > > > Hi Sasha,
> > > >
> > > > On 6/29/20 9:13 AM, Sasha Levin wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 5.7.7 release.
> > > > > There are 265 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > > 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.7.y&id2=v5.7.6
> > > > >
> > > >
> > > > Looks like patch naming convention has changed. My scripts look
> > > > for the following convention Greg uses. Are you planning to use
> > > > the above going forward? My scripts failed looking for the usual
> > > > naming convention.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > > > and the diffstat can be found below.
> > > 
> > > Sorry for that. I was hoping to avoid using the signed upload mechanism
> > > Greg was using by simply pointing the links to automatically generated
> > > patches on cgit (the git.kernel.org interface).
> > > 
> > > Would it be ok to change the pattern matching here? Something like this
> > > should work for both Greg's format and my own (and whatever may come
> > > next):
> > > 
> > > 	grep -A1 "The whole patch series can be found in one patch at:" | tail -n1 | sed 's/\t//'
> > 
> > If those don't work, I can still push out -rc1 patches.
> > 
> > It might be best given that the above -rc.git tree is unstable and can,
> > and will, change, and patches stored on kernel.org will not.
> 
> That's a good point. Maybe we should push tags for -rc releases too?
> that would allow us to keep stable links using the git.kernel.org
> interface.

If we really want to do this, then yes, we could.  But that kind of goes
against what we (well I) have been doing in the past with that tree...

thanks,

greg k-h
