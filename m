Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF2221D92
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgGPHqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 03:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgGPHqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 03:46:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EE3206C1;
        Thu, 16 Jul 2020 07:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594885582;
        bh=hdSSvyRjLr2q5K9OrFcecgMptQqwj90OLvlRIEBQMX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Awsmb9OEXqqTDOEqtKFp2muv6d0/lJR10kK0S66x52JAYJI7UZZwtNVESeIawHhNV
         3ljLxMfPXI/abQzZiS/4/j5N8B+s6sK3RltwA0V/tGa4B71+kkFpUK+aWGId31Ejmr
         DQ5+jRKLiTPL5SrtaN/+X0nX/f1n5hCYkX0F12TY=
Date:   Thu, 16 Jul 2020 09:46:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/166] 5.7.9-rc1 review
Message-ID: <20200716074616.GA975409@kroah.com>
References: <20200714184115.844176932@linuxfoundation.org>
 <e8d1da73-9c00-66c9-58d7-18175f539015@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8d1da73-9c00-66c9-58d7-18175f539015@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 07:54:08AM -0600, Shuah Khan wrote:
> On 7/14/20 12:42 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.9 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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
