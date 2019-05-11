Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A8A1A6C1
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 07:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfEKFtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 01:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfEKFtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 01:49:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D0D217F9;
        Sat, 11 May 2019 05:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557553760;
        bh=BgVZ0D+p6Df8VkZZRNsr7FYk9X06lKvt7ha8DKomew0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IMbTBC14gIfi9AmLhs5pSz7h4abctqSq9qaHI+q0bf/k2nLXjNIRC+LWSVi77Rmdo
         3hHYL3zQZOKdugw8MRib3EOVTafy50nq0Yuj/yKHuq59jLDBRzi+uSBHkMQOFMe3JB
         ordtWhLHFz2b32t2hQm0th2sSKdCWJcxFCepenxo=
Date:   Sat, 11 May 2019 07:49:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vandana BN <bnvandana@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
Message-ID: <20190511054918.GE14153@kroah.com>
References: <20190509181250.417203112@linuxfoundation.org>
 <23f8e6bb-f8b6-335c-0148-2c4903159eb4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23f8e6bb-f8b6-335c-0148-2c4903159eb4@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 10:53:34PM +0530, Vandana BN wrote:
> 
> On 10/05/19 12:12 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.1 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Compiled , booted and no regressions on my system.

Wonderful, thansk!
