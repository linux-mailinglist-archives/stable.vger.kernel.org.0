Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86B9156BF1
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBISDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbgBISDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:03:35 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7C020715;
        Sun,  9 Feb 2020 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581271414;
        bh=Fd9drsSJCJsLfVtfO5ODldy0aeShvBqz9d/zpX0lHDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lb9Ri1cTukEpkUX9sYS+bBGw+Ep5oZb5Hrjmv6J7PZvzWzQfgKCjI7183RAkCy/g/
         4P2lhLrZw7pb3RLVNOr9KQRT6bTyyAVQ/oSURJeEjJtdX7Jqeaf8N1OqtLoowcJTOy
         b2nEfHMT2CSnMyu60dTk9a55Ye998KkpcRPSPSzY=
Date:   Sun, 9 Feb 2020 13:03:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     claudiu.beznea@microchip.com, boris.brezillon@free-electrons.com,
        sam@ravnborg.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm: atmel-hlcdc: enable clock before
 configuring timing" failed to apply to 4.19-stable tree
Message-ID: <20200209180333.GJ3584@sasha-vm>
References: <158124842070142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124842070142@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:40:20PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 2c1fb9d86f6820abbfaa38a6836157c76ccb4e7b Mon Sep 17 00:00:00 2001
>From: Claudiu Beznea <claudiu.beznea@microchip.com>
>Date: Wed, 18 Dec 2019 14:28:25 +0200
>Subject: [PATCH] drm: atmel-hlcdc: enable clock before configuring timing
> engine
>
>Changing pixel clock source without having this clock source enabled
>will block the timing engine and the next operations after (in this case
>setting ATMEL_HLCDC_CFG(5) settings in atmel_hlcdc_crtc_mode_set_nofb()
>will fail). It is recomended (although in datasheet this is not present)
>to actually enabled pixel clock source before doing any changes on timing
>enginge (only SAM9X60 datasheet specifies that the peripheral clock and
>pixel clock must be enabled before using LCD controller).
>
>Fixes: 1a396789f65a ("drm: add Atmel HLCDC Display Controller support")
>Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
>Cc: <stable@vger.kernel.org> # v4.0+
>Link: https://patchwork.freedesktop.org/patch/msgid/1576672109-22707-3-git-send-email-claudiu.beznea@microchip.com

I've adjusted context because we don't have:

a6eca2abdd42 ("drm: atmel-hlcdc: add config option for clock selection")
319711f98208 ("drm/atmel-hlcdc: prefer a higher rate clock as pixel-clock base")

and queued it for 4.19-4.4.

-- 
Thanks,
Sasha
