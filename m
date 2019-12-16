Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A701209F7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 16:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfLPPmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 10:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbfLPPmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 10:42:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3EF720665;
        Mon, 16 Dec 2019 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576510957;
        bh=mkQvZm0uC15Hnw7IIu7YuQQcSZSkqqDlHPtwfw1xq2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x3RldMA6mflVi/XE+5VP1oL1n09dPaSFhb9Hcm8l2vQAxUZoTufCAsJnPQ8W+SMzq
         yjoyshDbjqLy9xhckA+RkGp8/d161MrRqfPnjVX5lZaiXpNlFhuHtFnWN36l2C40tI
         jDWlnuW+xFXBJk48b1gVqkW4JyIW4eGv+KndUk58=
Date:   Mon, 16 Dec 2019 10:42:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     d.schultz@phytec.de, chenjh@rock-chips.com, heiko@sntech.de,
        lee.jones@linaro.org, zhangqing@rock-chips.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mfd: rk808: Fix RK818 ID template" failed
 to apply to 4.19-stable tree
Message-ID: <20191216154235.GE17708@sasha-vm>
References: <1576497605185176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576497605185176@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 01:00:05PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 37ef8c2c15bdc1322b160e38986c187de2b877b2 Mon Sep 17 00:00:00 2001
>From: Daniel Schultz <d.schultz@phytec.de>
>Date: Tue, 17 Sep 2019 10:12:53 +0200
>Subject: [PATCH] mfd: rk808: Fix RK818 ID template
>
>The Rockchip PMIC driver can automatically detect connected component
>versions by reading the ID_MSB and ID_LSB registers. The probe function
>will always fail with RK818 PMICs because the ID_MSK is 0xFFF0 and the
>RK818 template ID is 0x8181.
>
>This patch changes this value to 0x8180.
>
>Fixes: 9d6105e19f61 ("mfd: rk808: Fix up the chip id get failed")
>Cc: stable@vger.kernel.org
>Cc: Elaine Zhang <zhangqing@rock-chips.com>
>Cc: Joseph Chen <chenjh@rock-chips.com>
>Signed-off-by: Daniel Schultz <d.schultz@phytec.de>
>Signed-off-by: Heiko Stuebner <heiko@sntech.de>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>

Adjusted context for missing 586c1b4125b3 ("mfd: rk808: Add RK817 and
RK809 support") and queued for 4.19 and 4.14.

-- 
Thanks,
Sasha
