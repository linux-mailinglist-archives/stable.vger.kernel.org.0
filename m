Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9D3C257C
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 16:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhGIOFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 10:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhGIOFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 10:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 728BD61378;
        Fri,  9 Jul 2021 14:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625839341;
        bh=NroP3ziw+PZUVQqJc/UKEOyljdUa1HDh2/1Wmds2e+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b74PP76Jkp8/wKRiezq9PSq2rELIChW04OYpiRQ3Tt2/7SOCUXZhKazb3kxOK3gPb
         le+imDuo+mRntlAWfQulsfS5Xj3pPwZQ29/nqeV+o8+E2/vjv0cT0rAFWBBYFDWyWP
         0wzBUeEwbcy4v8ptUnX7kOb/KW82It4L1TpY/c3rTKe7/GYUmmP4CEjW+kiB/xjzkH
         yrQ2cpyB7lXVU6Qnd9o9pkrk1IFfPVpTDW3Fnxy0E3h/vMN6+UzTZfDyaUJYKyx2Ps
         Q5Ljd3VNDHnbGScSr3tgBcz8m0rreTQ/+OhTxVBiu0Zt4X57SAYIuKk6z/U0KgAT3C
         SmiXJ/4A+4Lsg==
Date:   Fri, 9 Jul 2021 10:02:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>
Subject: Re: [PATCH AUTOSEL 5.13 23/85] regmap-i2c: Set regmap max raw r/w
 from quirks
Message-ID: <YOhW7BoCy+dqgWSB@sashalap>
References: <20210704230420.1488358-1-sashal@kernel.org>
 <20210704230420.1488358-23-sashal@kernel.org>
 <20210705120920.GA4574@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210705120920.GA4574@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 01:09:20PM +0100, Mark Brown wrote:
>On Sun, Jul 04, 2021 at 07:03:18PM -0400, Sasha Levin wrote:
>> From: Lucas Tanure <tanureal@opensource.cirrus.com>
>>
>> [ Upstream commit ea030ca688193462b8d612c1628c37129aa30072 ]
>>
>> Set regmap raw read/write from i2c quirks max read/write
>> so regmap_raw_read/write can split the access into chunks
>
>This seems a bit new featureish to be backporting to stable.

That's fair, I'll drop it.

-- 
Thanks,
Sasha
