Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5BF374C37
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 02:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhEFAPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 20:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229673AbhEFAPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 20:15:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A601261164;
        Thu,  6 May 2021 00:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620260060;
        bh=096xI+qq81ppXCw9EPK5Ma7vQkLFbEJxt4UQKHOxELA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Czy/j8JRaeWc7sta2wP4tEgSiNHaGZdKqOHSZjKaiKPGuLPy8rT4olB3BqJe8oAgZ
         VcgVLEo7aQBKvMi2/T3ay0LYiFVKkABB8zNUlMsKhfwo8MsA8ER1tgeITS+SN5jYav
         P/cknbOOsx+2jRW25JMIqS7uR8uAMVPV4p+jyP6X2SCQrpcV9vfFDOUwuULqzufdzd
         JRRmgrABnemgDzuCTsZRwVsjqBA+SgPAmlsoU2/QqBZ/I6cX8BoGqFzealQDIN5xn7
         GlUgZV9mVSR4b3zMeNJ2nBMC00EuzM0AbKvbebJHdb8d1fm3OFApcS6XmIitec4guG
         ecKqYoOvojTJA==
Date:   Wed, 5 May 2021 20:14:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH AUTOSEL 5.11 036/104] KVM: arm64: Use BUG and BUG_ON in
 nVHE hyp
Message-ID: <YJM02uCYV24jrg+N@sashalap>
References: <20210505163413.3461611-1-sashal@kernel.org>
 <20210505163413.3461611-36-sashal@kernel.org>
 <874kfhnn2k.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <874kfhnn2k.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 05:48:51PM +0100, Marc Zyngier wrote:
>Sasha,
>
>On Wed, 05 May 2021 17:33:05 +0100,
>Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Andrew Scull <ascull@google.com>
>>
>> [ Upstream commit f79e616f27ab6cd74deb0995a8eead3d1c9d65af ]
>>
>> hyp_panic() reports the address of the panic by using ELR_EL2, but this
>> isn't a useful address when hyp_panic() is called directly. Replace such
>> direct calls with BUG() and BUG_ON() which use BRK to trigger an
>> exception that then goes to hyp_panic() with the correct address. Also
>> remove the hyp_panic() declaration from the header file to avoid
>> accidental misuse.
>>
>> Signed-off-by: Andrew Scull <ascull@google.com>
>> Acked-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20210318143311.839894-5-ascull@google.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This has no chance of working without the patches that enable BUG()
>support at EL2, and *really* isn't stable material.
>
>Please drop this patch.

Will do, thanks!

-- 
Thanks,
Sasha
