Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D432F8E6
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 09:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCFIIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 03:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhCFII0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 03:08:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E3365005;
        Sat,  6 Mar 2021 08:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615018106;
        bh=7MqLNS/VVbz8eHfXJi5HBrZoe1beVZd2IWQ9p+o2vms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q+b7RDbCF6xrgAv+7WC3+rmIlDHv8XA4+tj8PDUXYlMQET+dyWlNQii9GsjXQUmej
         wEyimfGsDXqYwwgKGAMn+yRMDbEIpo34fc6do0E78mMA7olHsyW4JsoST+KrK2pD8S
         9agV0HnPuOO26E0+kSQlmTYzUxz/ac2MWVBHV53Q=
Date:   Sat, 6 Mar 2021 09:08:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
Message-ID: <YEM4d6O+6Jfw3RH/@kroah.com>
References: <20210305120849.381261651@linuxfoundation.org>
 <20210305220634.GA27686@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305220634.GA27686@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 11:06:34PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.4.260 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Ok, so we ran some tests.
> 
> And they failed:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/1075959449
> 
> [   26.785861] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=CVE-2018-3639 RESULT=fail>
> Received signal: <TESTCASE> TEST_CASE_ID=CVE-2018-3639 RESULT=fail
> 
> Testcase name is spectre-meltdown-checker... Failing on qemu? Somehow
> strange, but it looks like real test failure.
> 
> I'm cc: ing Chris, perhaps he can help.

Can you bisect?
