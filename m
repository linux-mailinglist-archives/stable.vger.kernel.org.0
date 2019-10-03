Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6012C9FE9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfJCNyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfJCNyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 09:54:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E953E20865;
        Thu,  3 Oct 2019 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570110883;
        bh=uxGETtiNRiejHOUgGfK8i24qmr0VDthxEixlWwjg6V0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uHLOxaMP4bGNwCQ8MvP2OUGqzgn0FAnPC14iWDbqUL9QRG+/jKz+VRA58Uat6dzHH
         VpQLP4yRiDM12dA73RuHZgoP6eD1C87EvVivmSKeD9SyRT5kamiJE0DDxxc0K1mcNe
         +kYUrAIZ604C0wKUverSQ2nl2jZ2fPUrulNRPu90=
Date:   Thu, 3 Oct 2019 09:54:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lorenzo@kernel.org, kvalo@codeaurora.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mt76: mt7615: fix mt7615 firmware path
 definitions" failed to apply to 5.3-stable tree
Message-ID: <20191003135441.GA17454@sasha-vm>
References: <157010284795216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157010284795216@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 01:40:47PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 9d4d0d06bbf9f7e576b0ebbb2f77672d0fc7f503 Mon Sep 17 00:00:00 2001
>From: Lorenzo Bianconi <lorenzo@kernel.org>
>Date: Sun, 22 Sep 2019 15:36:03 +0200
>Subject: [PATCH] mt76: mt7615: fix mt7615 firmware path definitions
>
>mt7615 patch/n9/cr4 firmwares are available in mediatek folder in
>linux-firmware repository. Because of this mt7615 won't work on regular
>distributions like Ubuntu. Fix path definitions.  Moreover remove useless
>firmware name pointers and use definitions directly
>
>Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
>Cc: stable@vger.kernel.org
>Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I've resolved this by also taking 2fc446487c364 ("mt76: mt7615: always
release sem in mt7615_load_patch"). Queued up both for 5.3 and 5.2, not
needed on older kernels.

-- 
Thanks,
Sasha
