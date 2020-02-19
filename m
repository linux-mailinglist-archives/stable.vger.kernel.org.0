Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D83C164DF2
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgBSSue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 13:50:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8590F2465D;
        Wed, 19 Feb 2020 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582138234;
        bh=fbEr9DT1+EfANhF3HTmsgAmBGUyveem3b81GzGRfxV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQU2VgJZyOAVb26ubPtH91inksrvQNoTCbU8F6JJoQIazUzCkgCZiSEBBaYoHFzAN
         vIK736gIb+bkZcBkdq68HIXDYAqb0jd4yvUvebahfScm3AMGglTvk4Wi76HoNVMrYr
         uuL4HwaAOgXWBMgqCOK+/W14d92fM+PNtiOBjSO8=
Date:   Wed, 19 Feb 2020 19:50:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
Message-ID: <20200219185031.GA2857377@kroah.com>
References: <20200218190432.043414522@linuxfoundation.org>
 <263059ef-8934-23fc-ddcd-fe91b0eaf4b7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <263059ef-8934-23fc-ddcd-fe91b0eaf4b7@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 04:02:35PM -0700, shuah wrote:
> On 2/18/20 12:54 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.5 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
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
