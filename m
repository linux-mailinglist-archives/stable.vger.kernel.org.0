Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0653040ED2A
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhIPWOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240764AbhIPWOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 18:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB7AA6108F;
        Thu, 16 Sep 2021 22:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631830390;
        bh=dsOuovH9Kp0/Y7aVaHgWs9poFvSiJI5QPHtFbQ7UB+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ECs+MA7oh2od9NNE8nBOlbqxT7yq7iR/f4JXp6nWXxahLC/Ka6ZW8xVLiWPxs0lIB
         97SE/93aqf2sTmlDvu1ucW52PJX+HwFQGeNuZDyZyJL6IGcT50DHEm76EnEr9XDti8
         KkihsjNQ9iUrNKemFIN+23f10GEYNXnnVwcoT1ZNURNsHwJkOFeUv5s1vLThEEIITq
         g+TOOC6x3CWCewConmgDSqEcpuISMpmybj2KHUFvLZA+40SZYBo+cf63RLgSFewVor
         Rn60/6jCHVP0dPNK8l+cN67igpGAoUwQrigOvak4QlnxISYzZSvLbWJRJO77OCSt0H
         yvoqdWZhSDS9g==
Date:   Thu, 16 Sep 2021 18:13:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 345/380] KVM: arm64: vgic: move irq->get_input_level
 into an ops structure
Message-ID: <YUPBdFVrQwUHAXzf@sashalap>
References: <20210916155803.966362085@linuxfoundation.org>
 <20210916155815.779126002@linuxfoundation.org>
 <87r1dobco8.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87r1dobco8.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 07:25:27PM +0100, Marc Zyngier wrote:
>On Thu, 16 Sep 2021 17:01:42 +0100,
>Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> From: Marc Zyngier <maz@kernel.org>
>>
>> [ Upstream commit db75f1a33f82ad332b6e139c5960e01999969d2c ]
>>
>> We already have the option to attach a callback to an interrupt
>> to retrieve its pending state. As we are planning to expand this
>> facility, move this callback into its own data structure.
>>
>> This will limit the size of individual interrupts as the ops
>> structures can be shared across multiple interrupts.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/arm64/kvm/arch_timer.c |  8 ++++++--
>>  arch/arm64/kvm/vgic/vgic.c  | 14 +++++++-------
>>  include/kvm/arm_vgic.h      | 28 +++++++++++++++++-----------
>>  3 files changed, 30 insertions(+), 20 deletions(-)
>
>As I replied to Sasha earlier, I don't see a good reason to backport
>this, as it doesn't improve anything on its own. Unless there is a
>compelling reason to get this backported, I'd rather see it dropped.

Yes, I'll drop it. I originally brought it as a dependency for a patch
that ended up being dropped. Thanks for pointing it out!

-- 
Thanks,
Sasha
