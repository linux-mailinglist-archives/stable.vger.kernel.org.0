Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF5E12E16A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 01:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgABA5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 19:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgABA5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 19:57:21 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5134C20672;
        Thu,  2 Jan 2020 00:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577926640;
        bh=WvzMDsgBBL97l9M7axZ+GB/VGO1S/q+EGqayt5YA8Ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dca4qPnPxaDLtIw3ql5ep68a/GI9kQqw5XMxfdByEDC0xOl1X+ZCt95cMG8rkohDk
         +pSNnJFY8otmrQOFyrcEUm9k1Din8a/NEVuKhyUwayy+VDdFyGON4fi9hWz54ly8sz
         8TDwBvKSvW2vMBR8qmHSjDmv/JByfPGWfUUKVdfw=
Date:   Wed, 1 Jan 2020 19:57:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     yonghan.ye@unisoc.com, baolin.wang7@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] serial: sprd: Add clearing break
 interrupt operation" failed to apply to 4.19-stable tree
Message-ID: <20200102005719.GC16372@sasha-vm>
References: <157763438810028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157763438810028@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 04:46:28PM +0100, gregkh@linuxfoundation.org wrote:
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
>From abeb2e9414d7e3a0d8417bc3b13d7172513ea8a0 Mon Sep 17 00:00:00 2001
>From: Yonghan Ye <yonghan.ye@unisoc.com>
>Date: Wed, 4 Dec 2019 20:00:07 +0800
>Subject: [PATCH] serial: sprd: Add clearing break interrupt operation
>
>A break interrupt will be generated if the RX line was pulled low, which
>means some abnomal behaviors occurred of the UART. In this case, we still
>need to clear this break interrupt status, otherwise it will cause irq
>storm to crash the whole system.
>
>Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
>Signed-off-by: Yonghan Ye <yonghan.ye@unisoc.com>
>Cc: stable <stable@vger.kernel.org>
>Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
>Link: https://lore.kernel.org/r/925e51b73099c90158e080b8f5bed9b3b38c4548.1575460601.git.baolin.wang7@gmail.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Context conflicts due to indentation fixes in the file, fixed up and
queued up for all branches.

-- 
Thanks,
Sasha
