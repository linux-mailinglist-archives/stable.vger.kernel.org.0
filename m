Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7C32E5F2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhCEKPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhCEKPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:15:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F7BE64F5B;
        Fri,  5 Mar 2021 10:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614939345;
        bh=LQO0GYleOioZ8BoxpVtzneVCI9JUoMq/b2rhTDq/f0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAxAeWMG8J49MDuVosnyV+wL1iKaJtSfTAM+s7AVBVcLjyTZxATOrpnKgPhINvB/c
         ElLbCe6j/LsKK1z7FAcI+jFCOR0WzgBOZbzL95CXBXWUPzlxloKmVBGmytqNk1RI7N
         Gn7bUR21uLlyStUYc0wingRCE2wR1IJYTLWd9bnI=
Date:   Fri, 5 Mar 2021 11:15:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        lkft-triage@lists.linaro.org, patches@kernelci.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
Message-ID: <YEIEz0lHjzRLCkGl@kroah.com>
References: <1eca83a8a33c44f99ed11d3b423505df@HQMAIL107.nvidia.com>
 <da58faaa-e0f4-c0f4-d68c-7c1c09415b58@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da58faaa-e0f4-c0f4-d68c-7c1c09415b58@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 05:07:42PM +0800, Samuel Zou wrote:
> On Tue, 02 Mar 2021 20:28:49 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 657 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc4.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Tested on arm64 and x86 for 5.10.20,
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Version: 5.10.20
> Commit: 83be32b6c9e55d5b04181fc9788591d5611d4a96
> Compiler: gcc version 7.3.0 (GCC)
> 
> 
> arm64 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4716
> succeed_num: 4713
> failed_num: 3
> timeout_num: 0
> 
> x86 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4716
> succeed_num: 4713
> failed_num: 3
> timeout_num: 0
> 
> Tested-by: Hulk Robot <hulkci@huawei.com>

Thanks for testing and letting me know.

greg k-h
