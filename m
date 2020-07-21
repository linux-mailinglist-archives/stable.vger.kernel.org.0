Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42C7227D53
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 12:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgGUKms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 06:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGUKms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 06:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA7F20714;
        Tue, 21 Jul 2020 10:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595328167;
        bh=7MFx4mhho7ivMAssZqUvEbE0ZiOgK1QwP2jKmRMEoMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hi5RUoaZUaMESjiAVTddK8OkCtoFqxh6ztcLbv8pFEO8d/di+vHrBOUwejgQqO1X2
         gxR0J+G8FBMjFHa92fSHrzCRoMGEIhXT3nKK4d1G5pKl69CNmCj1kxeqAtAfM1uzxo
         nkWms0kiF+uBCtMCzDQeStWGRWL6Q4BcH/b7D56w=
Date:   Tue, 21 Jul 2020 12:42:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
Message-ID: <20200721104256.GE1676612@kroah.com>
References: <20200720191523.845282610@linuxfoundation.org>
 <8f328303-f1fa-e4b6-d6bb-a2817c7474f7@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f328303-f1fa-e4b6-d6bb-a2817c7474f7@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:37:47PM -0600, Shuah Khan wrote:
> On 7/20/20 1:16 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.10 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.10-rc2.gz
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
