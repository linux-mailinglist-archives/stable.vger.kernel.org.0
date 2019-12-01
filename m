Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A66810E2B3
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 18:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLARCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 12:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfLARCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 12:02:47 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 987F020716;
        Sun,  1 Dec 2019 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575219766;
        bh=ue/tCj9Yx7cGL5JUY8Y07Ih6j7iw7ttezcBGTcorhv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ca6AM2DppLKst7NNYZv22fmbBPsMwsBps+Y76+zg8k21IOWihqZF+oXr2/2CYb0Sk
         QeXimbJURTSpgc+2p8XJt+rgxxzT96sJAW4N3awamCO4xwhnMD4mQ4Q0TICc3YFkEN
         0aCGEa3zQlJucE/igSGjUsZFfERN2f5ELTONm7SU=
Date:   Sun, 1 Dec 2019 12:02:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1)
 detection
Message-ID: <20191201170245.GU5861@sasha-vm>
References: <5688116.JcRxOpqE2I@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5688116.JcRxOpqE2I@debian64>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 09:52:14PM +0100, Christian Lamparter wrote:
>commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
>---
>From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
>From: Christian Lamparter <chunkeey@gmail.com>
>Date: Mon, 25 Mar 2019 13:50:19 +0100
>Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
>To: linux-wireless@vger.kernel.org,
>    ath10k@lists.infradead.org
>Cc: Kalle Valo <kvalo@codeaurora.org>
>
>This patch restores the old behavior that read
>the chip_id on the QCA988x before resetting the
>chip. This needs to be done in this order since
>the unsupported QCA988x AR1A chips fall off the
>bus when resetted. Otherwise the next MMIO Op
>after the reset causes a BUS ERROR and panic.
>
>Cc: stable@vger.kernel.org # 4.19
>Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
>Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Queued up for all branches, thanks!

-- 
Thanks,
Sasha
