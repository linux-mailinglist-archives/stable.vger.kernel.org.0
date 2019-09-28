Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F51DC1211
	for <lists+stable@lfdr.de>; Sat, 28 Sep 2019 22:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfI1UCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Sep 2019 16:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbfI1UCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Sep 2019 16:02:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8023F20863;
        Sat, 28 Sep 2019 20:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569700934;
        bh=iBI4ADUUwpbjA+pmHsEfnTeue1a9adW21YpVKP9WhKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2F5ar22dPjflJL9yIU58hu70yONBakpNONVOBBsTvNXDHVVGdyHdS1PDdcN/Q2yB
         +XUqR8207O4FeHFf1saqEFOAxmexTHTj23wLC9UQ43DmmvdORzZpKjh10ipBAGqLVk
         YQZea0UROJnoEp41s4cIDmuxBDLTJJx4BDk+yCgo=
Date:   Sat, 28 Sep 2019 16:02:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Baolin Wang <baolin.wang@linaro.org>
Cc:     stable@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        linus.walleij@linaro.org, natechancellor@gmail.com, sre@kernel.org,
        longman@redhat.com, linux-gpio@vger.kernel.org,
        david@lechnology.com, linux-pm@vger.kernel.org, arnd@arndb.de,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BACKPORT 4.19.y 0/3] Candidates from Spreadtrum 4.14 product
 kernel
Message-ID: <20190927153055.GP8171@sasha-vm>
References: <cover.1569404757.git.baolin.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1569404757.git.baolin.wang@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 05:52:26PM +0800, Baolin Wang wrote:
>With Arnd's script [1] help, I found some bugfixes in Spreadtrum 4.14 product
>kernel, but missing in v4.19.75:
>
>513e1073d52e locking/lockdep: Add debug_locks check in __lock_downgrade()
>957063c92473 pinctrl: sprd: Use define directive for sprd_pinconf_params values
>87a2b65fc855 power: supply: sysfs: ratelimit property read error message
>
>[1] https://lore.kernel.org/lkml/20190322154425.3852517-19-arnd@arndb.de/T/
>
>David Lechner (1):
>  power: supply: sysfs: ratelimit property read error message
>
>Nathan Chancellor (1):
>  pinctrl: sprd: Use define directive for sprd_pinconf_params values
>
>Waiman Long (1):
>  locking/lockdep: Add debug_locks check in __lock_downgrade()
>
> drivers/pinctrl/sprd/pinctrl-sprd.c       |    6 ++----
> drivers/power/supply/power_supply_sysfs.c |    3 ++-
> kernel/locking/lockdep.c                  |    3 +++
> 3 files changed, 7 insertions(+), 5 deletions(-)

I've queued these up for 4.19, 4.14 and some for 4.9 and 4.4. Thank you.

--
Thanks,
Sasha
