Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D312683D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 18:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfLSRfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 12:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfLSRfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 12:35:06 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492B6227BF;
        Thu, 19 Dec 2019 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576776905;
        bh=s5oaspOL57PeyHvJJ2IZujrmMyDV5G1RgW/jNsRFpcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aeu9sc1zY3qe/XYURcfyADyDRQSTY4m2jgc72uJjDA9qYqsqBUeapVh15uArYh1Pz
         /j2mksn7HnCACdYISyc8+X3B8RSXfCmgNGfo6CFlQdR8YvP+RNFi4eBFnFfrcL5c0b
         brTHvQUO3hWECeyPuRkD51cWKHNHIIaUCg9yeyjY=
Date:   Thu, 19 Dec 2019 12:35:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 128/350] spi: pxa2xx: Set
 controller->max_transfer_size in dma mode
Message-ID: <20191219173504.GN17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-89-sashal@kernel.org>
 <20191211104738.GA3870@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191211104738.GA3870@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:47:38AM +0000, Mark Brown wrote:
>On Tue, Dec 10, 2019 at 04:03:53PM -0500, Sasha Levin wrote:
>> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>>
>> [ Upstream commit b2662a164f9dc48da8822e56600686d639056282 ]
>>
>> In DMA mode we have a maximum transfer size, past that the driver
>> falls back to PIO (see the check at the top of pxa2xx_spi_transfer_one).
>> Falling back to PIO for big transfers defeats the point of a dma engine,
>> hence set the max transfer size to inform spi clients that they need
>> to do something smarter.
>
>This won't fix anything by itself, this asks other code to change how it
>behaves which may or may not work in older kernels.

I'll drop it then, thanks!

-- 
Thanks,
Sasha
