Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDC4382739
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhEQInr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:43:47 -0400
Received: from muru.com ([72.249.23.125]:56546 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230011AbhEQInp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 04:43:45 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 1560680BA;
        Mon, 17 May 2021 08:42:32 +0000 (UTC)
Date:   Mon, 17 May 2021 11:42:26 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [Backport for linux-5.10.y PATCH 2/2]
 clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940
Message-ID: <YKIsckQwullhruX+@atomide.com>
References: <20210517082244.17447-1-tony@atomide.com>
 <20210517082244.17447-2-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517082244.17447-2-tony@atomide.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [210517 08:23]:
> Upstream commit 25de4ce5ed02994aea8bc111d133308f6fd62566 for stable
> linux-5.10.y. Depends on backported upstream commit
> 3efe7a878a11c13b5297057bfc1e5639ce1241ce.
> 
> There is a timer wrap issue on dra7 for the ARM architected timer.
> In a typical clock configuration the timer fails to wrap after 388 days.

FYI, these patches also apply to linux-5.11.y and linux-5.12.y. This
patch applies with fuzz to the related device tree changes though,
so please let me know if separate patches are needed.

Regards,

Tony
