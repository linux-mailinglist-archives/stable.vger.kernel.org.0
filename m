Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D73C92A9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhGNVCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 17:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhGNVCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 17:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 984FE613D2;
        Wed, 14 Jul 2021 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626296362;
        bh=46LZepb4ibcHU0dIyCjWFYG69WtsVts8G634YB/zfu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hmlhNAehPM0iCcte6ZJr9LRGH5D9qqDN/W/0PjfCSHsxS7KhBCr9sm5/SdafO8j/j
         t+cc1OOWD+rL6MS2DhMF+xDgJvFz+es+pAV0m0PSY6zZbqnrMj0frvw7LF5duiTibe
         Ea4woNOSjjGQlfKLfgOsr5T33NrnwmYhfqGoBT9kQ/07SOOtoi3w55nKEaaT5vunSd
         VvXBspWcSAKODcVfjIQV31/hpB3qeyJmgn9iC0wHqw5LmrpDRe0qxuWpGUL/qzcWFB
         GfD7xwVfzC6++b2wtywmmwPtqNWicVPo4A4CQEj3KMF6X4MZXBoBc+35lYLEU/coev
         N/LAQDuW6xYSg==
Date:   Wed, 14 Jul 2021 16:59:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.13 024/108] ARM: dts: imx25-pinfunc: Fix gpio
 function name for pads GPIO_[A-F]
Message-ID: <YO9QKRUOT0Kg0jZ9@sashalap>
References: <20210714193800.52097-1-sashal@kernel.org>
 <20210714193800.52097-24-sashal@kernel.org>
 <20210714203550.zlbvfh6rfnah6iir@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210714203550.zlbvfh6rfnah6iir@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 10:35:50PM +0200, Uwe Kleine-König wrote:
>On Wed, Jul 14, 2021 at 03:36:36PM -0400, Sasha Levin wrote:
>> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>
>> [ Upstream commit e0cdd26af8eb9001689a4cde4f72c61c1c4b06be ]
>>
>> The pinfunc definitions used GPIO_A as function instead of GPIO_1_0 as
>> done for all the other pins with GPIO functionality. Fix for consistency.
>>
>> There are no mainline users that needs adaption.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I'm not convinced it's a good idea to take this patch for stable.
>in-tree users are unaffected and the only effect this can have on
>out-of-tree users is to break them. So the gain of having this is not
>positive.
>
>Am I missing something?

Hm, if those definitions don't have an in-tree users, why are they still
around to begin with?

-- 
Thanks,
Sasha
