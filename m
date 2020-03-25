Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994D1191E59
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 02:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgCYBCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 21:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbgCYBCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 21:02:01 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C020520719;
        Wed, 25 Mar 2020 01:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585098121;
        bh=fTS3usdqqJIgrKn6+NcJLodUoqxhl3ahgAmrCc2Hs70=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=2ZVymyTW1Lre02jPiUXzzmB5uwEbC/Ru9TWaXB8Ny+GVyP2405r+0kEMD1mJnIS5e
         h1EJLT2TjoefqyWnwcW69aZXGYzTSHdxkQvVvv6uPWQMohPV9Op7NbzVV1orDMC3dK
         OvRSA4lQKH1zVFUerLV0iCt+0CsiB/S7BH/RdOJs=
Date:   Wed, 25 Mar 2020 01:02:00 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Yubo Xie <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com
Cc:     Yubo Xie <yuboxie@microsoft.com>, linux-hyperv@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong time unit
In-Reply-To: <20200324151935.15814-1-yuboxie@microsoft.com>
References: <20200324151935.15814-1-yuboxie@microsoft.com>
Message-Id: <20200325010200.C020520719@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: adb87ff4f96c ("clocksource/drivers/hyperv: Allocate Hyper-V TSC page statically").

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
