Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF38F15002B
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 01:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgBCAtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 19:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgBCAtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Feb 2020 19:49:19 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AD3206E6;
        Mon,  3 Feb 2020 00:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580690958;
        bh=8yjXnjR4QbOcABDzs+mAXuXOfMLqcicuxYQ9mxJfUjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKFqDVoX7m/g6sZ/M2Zclxq9JiepAOdaITY71l1UK7/hC2wSumH2HG42y1FB7d0/n
         yexcwXG2lRV/AOj9WSSECfW4hcJxOXYJcjC9cGzdYnnOSDlEpgsJUTdD+g4J7tXeLA
         KKcI9j7G9fYVvZHhhXISQI3C3MTysX3MBhX6fj9I=
Date:   Sun, 2 Feb 2020 19:49:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     b-liu@ti.com, balbi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: turn off VBUS when leaving
 host mode" failed to apply to 4.9-stable tree
Message-ID: <20200203004917.GG1732@sasha-vm>
References: <1580378816222208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1580378816222208@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 11:06:56AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From 09ed259fac621634d51cd986aa8d65f035662658 Mon Sep 17 00:00:00 2001
>From: Bin Liu <b-liu@ti.com>
>Date: Wed, 11 Dec 2019 10:10:03 -0600
>Subject: [PATCH] usb: dwc3: turn off VBUS when leaving host mode
>
>VBUS should be turned off when leaving the host mode.
>Set GCTL_PRTCAP to device mode in teardown to de-assert DRVVBUS pin to
>turn off VBUS power.
>
>Fixes: 5f94adfeed97 ("usb: dwc3: core: refactor mode initialization to its own function")
>Cc: stable@vger.kernel.org
>Signed-off-by: Bin Liu <b-liu@ti.com>
>Signed-off-by: Felipe Balbi <balbi@kernel.org>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

That piece of code just moved around a bit, fixed up and queued for 4.9.

-- 
Thanks,
Sasha
