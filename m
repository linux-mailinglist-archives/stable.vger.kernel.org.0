Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F02C2494D7
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 08:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHSGL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 02:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgHSGL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 02:11:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525772063A;
        Wed, 19 Aug 2020 06:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597817488;
        bh=5eFGWvDmadpQ9UTKEI8y8p0GubTJgk0mYB9WK1YFrg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCZ+WdmiJPUBkvqNtIOxYEsb3MSgeH2AbDgfUfwXoj0PsEBANc7GubTfYoGV+Vj75
         +Cc9Kit6ty8kgQilJDHdsPP3+fJUllD9bttmPAzTAOfM1iZm7PbtqWmtRD4q/TVBMJ
         RBDngqyAi4bnFCAvlvDZyaLgBTo42U6NHpOXmZ1w=
Date:   Wed, 19 Aug 2020 08:11:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/464] 5.8.2-rc1 review
Message-ID: <20200819061151.GC868164@kroah.com>
References: <20200817143833.737102804@linuxfoundation.org>
 <67569cf0-3ba1-001b-9666-4a13696ff79f@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67569cf0-3ba1-001b-9666-4a13696ff79f@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 04:35:23PM -0600, Shuah Khan wrote:
> On 8/17/20 9:09 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.2 release.
> > There are 464 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.2-rc1.gz
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

Thanks for testing all of these and letting me know.

greg k-h
