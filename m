Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E139195978
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgC0PDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgC0PDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:39 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B61502072F;
        Fri, 27 Mar 2020 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321418;
        bh=L7n4LBcH98cHqRxHbboMVK3YOv6chI2s8pwqRCgOxc4=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=Jv53Elj1NlzGS6Aqs5RMYz2pMa+BfGttF/KoaRt35a10wPhou8ysqq6XEZLKrxnXN
         qDf9ur82nhBm1HwzKE+WK+VrAw2RLII9gQ3FNQnkINEOeKuPfRYyByKLKiqZcUK9ZR
         4hPqkhi35Wgg3Z+Sa+thf4lQmySBUXGTUWvGYN0g=
Date:   Fri, 27 Mar 2020 15:03:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
To:     Yubo Xie <yuboxie@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V2] x86/Hyper-V: Fix hv sched clock function return wrong time unit
In-Reply-To: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
References: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
Message-Id: <20200327150338.B61502072F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function").

The bot has tested the following trees: v5.5.11, v5.4.27.

v5.5.11: Failed to apply! Possible dependencies:
    0af3e137c144 ("clocksource/drivers/hyper-v: Untangle stimers and timesync from clocksources")
    ddc61bbc4501 ("clocksource/drivers/hyper-v: Reserve PAGE_SIZE space for tsc page")

v5.4.27: Failed to apply! Possible dependencies:
    0af3e137c144 ("clocksource/drivers/hyper-v: Untangle stimers and timesync from clocksources")
    ddc61bbc4501 ("clocksource/drivers/hyper-v: Reserve PAGE_SIZE space for tsc page")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
