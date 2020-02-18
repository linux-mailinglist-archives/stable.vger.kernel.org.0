Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F35162B1A
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgBRQxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgBRQxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 11:53:45 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA7D62176D;
        Tue, 18 Feb 2020 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582044825;
        bh=DkcPvIlWCLa4HVS+/GVo7aDEXBZrw7EXNb0eOA/k5KI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d4OJ9FjcOWqdV79M44XULpdRO7r+Aojy5hbGFmNwOhkz1bWa5zoTGfe34lWEjZCP+
         AghQWqFu47AbJ1yAzvmi1G/keyoShp2BYzAsYpOkUUwUSz20FmWSqWB0iicEpwXyK+
         mV0lDJbbY2Fc//yChjaeSc9Woci8K3cbqtB9UXTU=
Date:   Tue, 18 Feb 2020 11:53:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     krzk@kernel.org, olof@lixom.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ARM: npcm: Bring back GPIOLIB support"
 failed to apply to 4.14-stable tree
Message-ID: <20200218165343.GR1734@sasha-vm>
References: <158196661868212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158196661868212@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:10:18PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From e383e871ab54f073c2a798a9e0bde7f1d0528de8 Mon Sep 17 00:00:00 2001
>From: Krzysztof Kozlowski <krzk@kernel.org>
>Date: Thu, 30 Jan 2020 20:55:24 +0100
>Subject: [PATCH] ARM: npcm: Bring back GPIOLIB support
>
>The CONFIG_ARCH_REQUIRE_GPIOLIB is gone since commit 65053e1a7743
>("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB") and all platforms
>should explicitly select GPIOLIB to have it.
>
>Link: https://lore.kernel.org/r/20200130195525.4525-1-krzk@kernel.org
>Cc: <stable@vger.kernel.org>
>Fixes: 65053e1a7743 ("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB")
>Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>Signed-off-by: Olof Johansson <olof@lixom.net>

This isn't needed on 4.14 and older since 7bffa14c9aed ("arm: npcm: add
basic support for Nuvoton BMCs") was added after 4.14.

-- 
Thanks,
Sasha
