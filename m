Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45764F76C7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKKOoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfKKOoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:44:04 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B60DD21655;
        Mon, 11 Nov 2019 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573483444;
        bh=X7SG+tbgY0sJN0nODztzrxRc0XO7Oqb4PQoWRWATlqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wqn0TgsUbETeDo0/os7lfztGzXgKb9Z9TN9ioMMScBjrG5jilc96WmjRYghe1QF/s
         utDaTNvmfHiHZHGrq2lNlFw4DhiX5m8LCmdGO7AKcfzbK6mR67DsIO98ErQ9e75v5Z
         8AI/2+9Y1aGs8lG7mweqrJGU/JBBmr/nK/gl9qYo=
Date:   Mon, 11 Nov 2019 09:44:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     qiangqing.zhang@nxp.com, mkl@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: flexcan: disable completely the ECC
 mechanism" failed to apply to 4.14-stable tree
Message-ID: <20191111144401.GF8496@sasha-vm>
References: <157345390614177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157345390614177@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:31:46AM +0100, gregkh@linuxfoundation.org wrote:
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
>From 5e269324db5adb2f5f6ec9a93a9c7b0672932b47 Mon Sep 17 00:00:00 2001
>From: Joakim Zhang <qiangqing.zhang@nxp.com>
>Date: Thu, 15 Aug 2019 08:00:26 +0000
>Subject: [PATCH] can: flexcan: disable completely the ECC mechanism
>
>The ECC (memory error detection and correction) mechanism can be
>activated or not, controlled by the ECCDIS bit in CAN_MECR. When
>disabled, updates on indications and reporting registers are stopped.
>So if want to disable ECC completely, had better assert ECCDIS bit, not
>just mask the related interrupts.
>
>Fixes: cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
>Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>Cc: linux-stable <stable@vger.kernel.org>
>Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

I've adjusted the patch to work around missing 88462d2a7830 ("can:
flexcan: Remodel FlexCAN register r/w APIs for big endian FlexCAN
controllers.") and queued it for 4.14-4.4.

-- 
Thanks,
Sasha
