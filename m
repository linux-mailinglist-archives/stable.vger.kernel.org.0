Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706E0D6C98
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 02:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfJOAqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 20:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfJOAqG (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 14 Oct 2019 20:46:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BDB2089C;
        Tue, 15 Oct 2019 00:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571100366;
        bh=coZUBIAggPWGgXP2M9naUQ//dKJPZ6XucUWvfsm3NX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PgX4hdxh6/NtepHxw92PRdRKAbsA4ScQsuG0VqZ1e9B7ZZdcR7O/g7zyKF13nWitT
         LLS9u5Zyp36L7QPkywamU6O83fmoamndlJ+eXHCkj67PhaE4Ovw9r3VVTr14KPBIgA
         2Bp5MUcZjMlIes4ezFPq8RoUC+atpZf2bfgj58Ns=
Date:   Mon, 14 Oct 2019 20:46:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     zhongjiang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: Fix an undefied reference error in
 noa1305_probe" failed to apply to 5.3-stable tree
Message-ID: <20191015004604.GG31224@sasha-vm>
References: <15710652585179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15710652585179@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:00:58PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From a26e0fbe06e20077afdaa40d1a90092f16b0bc67 Mon Sep 17 00:00:00 2001
>From: zhong jiang <zhongjiang@huawei.com>
>Date: Mon, 23 Sep 2019 10:04:32 +0800
>Subject: [PATCH] iio: Fix an undefied reference error in noa1305_probe
>
>I hit the following error when compile the kernel.
>
>drivers/iio/light/noa1305.o: In function `noa1305_probe':
>noa1305.c:(.text+0x65): undefined reference to `__devm_regmap_init_i2c'
>make: *** [vmlinux] Error 1
>
>Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

This driver was added in 5.4, the stable tag here is wrong.

-- 
Thanks,
Sasha
