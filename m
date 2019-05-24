Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2E29ED1
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391510AbfEXTHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 15:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391503AbfEXTHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 15:07:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5FCA2175B;
        Fri, 24 May 2019 19:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558724851;
        bh=A6/JoHyyjMUdq8M1/t7NxVezHpxIBIL9Ea3XwORrlSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D07n5+Tg29CwtpLBXWs6JSIhD6SBvEKWTL3TAF649xb/bUdjWgvV6iCyyCQlPxvAA
         0dionBBsq9da4jbn7WaMcxeZVTHXz4e1ILaDawgEV+nOuZ2oq+caL83AwfrJw5eXdI
         MIlwkfGe0WBVuKDmnvZL4105T9KvRABZZjuX4mik=
Date:   Fri, 24 May 2019 21:07:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
Message-ID: <20190524190728.GA18691@kroah.com>
References: <20190523181705.091418060@linuxfoundation.org>
 <689feba6-bce3-1d16-b5b6-27ce8b8a9e2d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689feba6-bce3-1d16-b5b6-27ce8b8a9e2d@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 12:55:59PM -0600, shuah wrote:
> On 5/23/19 1:05 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.5 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 25 May 2019 06:14:44 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Compiled and booted on my test system. No dmesg regressions.

Wonderful, thanks for testing these and letting me know.

greg k-h
