Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E533FF34
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 07:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCRGEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 02:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhCRGE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 02:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3773964F10;
        Thu, 18 Mar 2021 06:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616047469;
        bh=QAZHZLeu87PtiWj9GjIEhM2n7AFBNGGF9LnotKAguC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tIyBCNgn+ndZI6+VLJKeBUURCxJpLy+R09c3QbQLwbNttjCQBUxO1H/zDCii+wM7M
         y+qw8qZHvX+sY3Qfe5QDR5vFiWsKjUryk3iP6QnNzN5MwuLKlfviPnlEWIRXfVcrUP
         xXCcJfvNqbWxYIC8uhVFEJfx7onb4B1k57beL1Og=
Date:   Thu, 18 Mar 2021 07:04:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
Message-ID: <YFLtaQs1W9I1AdF3@kroah.com>
References: <20210315135740.245494252@linuxfoundation.org>
 <c0902934-ea11-ba1e-fa2d-b05897aab4b3@huawei.com>
 <YFIh6ZyWb2JtCu6H@kroah.com>
 <f2328179-00d9-41e0-6bd8-7bd39b025563@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2328179-00d9-41e0-6bd8-7bd39b025563@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 01:54:34PM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/17 23:36, Greg KH wrote:
> > On Tue, Mar 16, 2021 at 02:35:36PM +0800, Samuel Zou wrote:
> > > 
> > > 
> > > On 2021/3/15 21:56, gregkh@linuxfoundation.org wrote:
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > This is the start of the stable review cycle for the 4.14.226 release.
> > > > There are 95 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.226-rc1.gz
> > > > or in the git tree and branch at:
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > 
> > > Tested on x86 for 4.14.226-rc1,
> > > 
> > > Kernel repo:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > Branch: linux-4.14.y
> > > Version: 4.14.226-rc1
> > > Commit: 57cc62fb2d2b8e81c02cb9197e303c7782dee4cd
> > > Compiler: gcc version 7.3.0 (GCC)
> > > 
> > > x86 (No kernel failures)
> > > --------------------------------------------------------------------
> > > Testcase Result Summary:
> > > total_num: 4728
> > > succeed_num: 4727
> > > failed_num: 1
> > 
> > What does this "failed_num" mean?
> > 
> > thanks,
> > 
> > greg k-h
> 
> total_num: The number of total testcases
> succeed_num: The number of succeed testcases
> failed_num: The number of failed testcases
> 
> Maybe I can revise the description in the next email.

So as something is listed as "failed" here, what failed and was it
caused by something in this -rc?

That's the important thing for us to know here, not the quantity of
passing tests.

thanks,

greg k-h
