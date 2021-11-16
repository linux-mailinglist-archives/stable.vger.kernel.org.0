Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FE145212A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbhKPBAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359705AbhKPA6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 19:58:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A576137F;
        Tue, 16 Nov 2021 00:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637024139;
        bh=4NY9PxDCuh5GbF0H7m/B5TkI4hIsPPPPDbyERGtTSfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnF0ICSrrZdBsGx9JZs+lnK+ax3WinjrDaa5Acs+fYt2lU7z3gqakV6KW4p3R+bgl
         L7UZDEIkehhluyLsshg8UK98b5a0m4RooKmVLIEBfJ+2i4j15xq0Z3kshe/Zg7A5C7
         UbQ36pq7VdTHeGtf1/iqIjymI5NfjbBVPY9COB1RxNrSTcRIrYrfzkDJ8kftKAxj0O
         L8VKy72+ur5HfZ09tfCoi4QUujeAL4j17cOI5hSqJL1eO2GjKKupGwjBWbd7lV1bsR
         7KlXVGFr7t7VaWcTpgG+ETuvQHyqAAmYUlsfFoG183sGPyciuSLF+Aymbr3O8QljLV
         sti170sj/zBlg==
Date:   Mon, 15 Nov 2021 19:55:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mikko Perttunen <mperttunen@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 5.4 043/355] reset: tegra-bpmp: Handle errors in BPMP
 response
Message-ID: <YZMBignedNCFwY5h@sashalap>
References: <20211115165313.549179499@linuxfoundation.org>
 <20211115165314.943849440@linuxfoundation.org>
 <94e5add7-9e65-cbfb-46b5-b6eee6514247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <94e5add7-9e65-cbfb-46b5-b6eee6514247@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 07:19:58PM +0200, Mikko Perttunen wrote:
>On 15.11.2021 18.59, Greg Kroah-Hartman wrote:
>>From: Mikko Perttunen <mperttunen@nvidia.com>
>>
>>[ Upstream commit c045ceb5a145d2a9a4bf33cbc55185ddf99f60ab ]
>>
>>The return value from tegra_bpmp_transfer indicates the success or
>>failure of the IPC transaction with BPMP. If the transaction
>>succeeded, we also need to check the actual command's result code.
>>Add code to do this.
>>
>>Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>Link: https://lore.kernel.org/r/20210915085517.1669675-2-mperttunen@nvidia.com
>>Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>...
>Can we drop this patch from all stable trees. A revert has been 
>submitted by Jon Hunter -- the reason is that the tegra-hda driver has 
>a (harmless) bug that was previously masked, but with this patch 
>causes the driver to fail to probe.

I'll drop it, thanks!

-- 
Thanks,
Sasha
