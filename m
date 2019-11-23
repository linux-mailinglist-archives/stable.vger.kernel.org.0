Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85AD107F9F
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWR3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 12:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKWR3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Nov 2019 12:29:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13F02067D;
        Sat, 23 Nov 2019 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574530154;
        bh=8mN30eUOUA6iFm0aORtj3oVwwIyWOi6kmdmngRYjnFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVWygiwt39YkKlH6Pyy2rwS7Lv/5ACQetw9LrqtU2kRjax0a04EGPAp+l+mxCnqDf
         dMuX/wAIbH5/bjxdwkFPHHx5pWK/DjIWjfEIlR/OTfTDYCvdj2KlkJampu3tlDUNG6
         hvNAXjKD10j1XlmtAteYSUZbIvYeJVT/3aQ5rdmE=
Date:   Sat, 23 Nov 2019 18:29:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 0/6] 5.3.13-stable review
Message-ID: <20191123172912.GA2135561@kroah.com>
References: <20191122100320.878809004@linuxfoundation.org>
 <d750d6a0-c0a8-5d0e-370d-511b2de3409b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d750d6a0-c0a8-5d0e-370d-511b2de3409b@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 05:50:52PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 11/22/19 4:30 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.13 release.
> > There are 6 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
