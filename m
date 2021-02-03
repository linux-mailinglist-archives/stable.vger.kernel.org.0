Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2243030D09A
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 02:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhBCBFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 20:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhBCBFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 20:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B99B64F41;
        Wed,  3 Feb 2021 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612314262;
        bh=fgFFuKT0AwsUtthU1lpDAzZcl66T+TN2PJgx6lqpLr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pYE+zLib9EAgBh5g2gVEhrHWHsbB8Zot5kRQn2Ang9xEIjMs0vsXTScEx4Ed5ZhuR
         kTYC3CahOfoidLHVGOnLYh/j1eXPn0PXRLSp852cmkMGF50FHup94A+wCqStvd+p2v
         JICu4i+LYJxMnDeQhPG3PysRTMfTgwT0kM3BoSBCPUaT6RbuEkNaX4diozLnKWoOwb
         ErMtBZFTdbhVvYdZan5q+HBeXecOdVXYjnZUazojPxPaQ5O0Ye22epKvjkysUcoSYA
         LlOBKKAS8BileSjGWfKHDRfEhzfrNoZKWSK4TwCKWxnytB4HbxETHMcO+GaifHJTTB
         KrMF7WzNqaENg==
Date:   Tue, 2 Feb 2021 20:04:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.10 02/25] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <20210203010421.GT4035784@sasha-vm>
References: <20210202150615.1864175-1-sashal@kernel.org>
 <20210202150615.1864175-2-sashal@kernel.org>
 <20210202161243.GD5154@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210202161243.GD5154@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 04:12:43PM +0000, Mark Brown wrote:
>On Tue, Feb 02, 2021 at 10:05:52AM -0500, Sasha Levin wrote:
>> From: David Collins <collinsd@codeaurora.org>
>>
>> [ Upstream commit eaa7995c529b54d68d97a30f6344cc6ca2f214a7 ]
>>
>> The final step in regulator_register() is to call
>> regulator_resolve_supply() for each registered regulator
>> (including the one in the process of being registered).  The
>
>This introduces a lockdep warning, there's a follow up commit if you
>want to backport it or it should be fine to just not backport either.

Okay, I'll see if it made it next week before I queue it up. Thanks!

-- 
Thanks,
Sasha
