Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F023E846
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 09:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHGHsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 03:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgHGHsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 03:48:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B9122CAF;
        Fri,  7 Aug 2020 07:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596786486;
        bh=JoFwnLK/guDqtFajOlwEO878b/NAAm1mSZr6A9sB2Jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIVIEOUraOWq7Y+kNauU8IPjutT0VhOOoUbxk+WYiEyxETFqAPN93V5C+9GoX1++u
         L8nZ1bGzrwdTR3Dt6Oquxvbpr3ASNghcNo+6XReqf4biS0toIpk5d1ATfbtS81EeCF
         tEZFhtEBxuR52eSQSgNuNqt/owb7gTYValR0QS84=
Date:   Fri, 7 Aug 2020 09:48:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/6] 4.19.138-rc1 review
Message-ID: <20200807074819.GB3048107@kroah.com>
References: <20200805153505.472594546@linuxfoundation.org>
 <20200807072418.GA23375@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807072418.GA23375@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 09:24:18AM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.138 release.
> > There are 6 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.138-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> Testing did not find any problems:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y

Thanks for testing!
