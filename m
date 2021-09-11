Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1755A4078D2
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 16:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhIKOhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 10:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhIKOhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 10:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6D3A6109F;
        Sat, 11 Sep 2021 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631370951;
        bh=LW2199kttJtBTwAhoKWy75wM87SVN6+UIBjbbND4LYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uMcyHemGp+1THisLwBmc8sth9JoOxiEj44S11tY69ywFVKEmUkfe7yZcIUVhkAgpG
         rF7SMCIGr8F7KU+zyBAEw5DGe70MThctGMSeBNG1bYBnj7ATTZYmKwiOBY5v+bXz0D
         HaVo6f8Q/G2SQguHdFB9ezWbBjiTMJ8ShDVx7bX6JRauvCYBq+32RXRraq7m10BbQQ
         xHcV9prI5MtKamXcOmLEfBiJ3YaocRFbZLE4OROn4UruO+vlbFtm56dF3QNmbqqFbJ
         4Dq/gnCSnNHLaUzhYV6H/VWfrSEFnD06ye93bUIDVsdoxjtxU5lCYj+k3r5YVbAcEQ
         4uEgyAuabiDrw==
Date:   Sat, 11 Sep 2021 10:35:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.14 38/99] KVM: PPC: Book3S HV: XICS: Fix
 mapping of passthrough interrupts
Message-ID: <YTy+xUtEEpln2Sq4@sashalap>
References: <20210910001558.173296-1-sashal@kernel.org>
 <20210910001558.173296-38-sashal@kernel.org>
 <27739836-bad2-6b3f-7f40-e84663fbbf24@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27739836-bad2-6b3f-7f40-e84663fbbf24@kaod.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 07:48:18AM +0200, Cédric Le Goater wrote:
>On 9/10/21 2:14 AM, Sasha Levin wrote:
>> From: Cédric Le Goater <clg@kaod.org>
>>
>> [ Upstream commit 1753081f2d445f9157550692fcc4221cd3ff0958 ]
>>
>> PCI MSIs now live in an MSI domain but the underlying calls, which
>> will EOI the interrupt in real mode, need an HW IRQ number mapped in
>> the XICS IRQ domain. Grab it there.
>>
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Link: https://lore.kernel.org/r/20210701132750.1475580-31-clg@kaod.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>
>Why are we backporting this patch in stable trees ?
>
>It should be fine but to compile, we need a partial backport of commit
>51be9e51a800 ("KVM: PPC: Book3S HV: XIVE: Fix mapping of passthrough
>interrupts") which exports irq_get_default_host().

Or, I can drop it if it makes no sense?

-- 
Thanks,
Sasha
