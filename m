Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201583243E5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBXSms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhBXSmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 13:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB1C64F0B;
        Wed, 24 Feb 2021 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614192125;
        bh=ndHq6nY8AS3PLF6/CC1Ru2lsjPoVl1pFkRCRIhFfHjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSsndEX+q071rrTE9M8Ftco5Kdx2m/cU9/HOPkkR7OjaIdmA4V9wcaa2pqxRMrZO6
         i2Hfkt5oM+1V9ntE2T+rbmgTGAAgLouEw9YQLC7/CGOnTCg1N8h0nefD6xvcFDXEuV
         5UqYaz5+mXGcSfXOavZNBctra73Argjhc8VS1txo=
Date:   Wed, 24 Feb 2021 19:42:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
Message-ID: <YDad+mnnwFMyC/Ew@kroah.com>
References: <20210222121019.444399883@linuxfoundation.org>
 <20210222184223.GB22197@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222184223.GB22197@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 07:42:23PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.18 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Two runs are marked as failed, but details show "no available board",
> so it is not a kernel problem.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of these.

greg k-h
