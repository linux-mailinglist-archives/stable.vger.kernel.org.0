Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3032911FA7C
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfLOSiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfLOSiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:38:11 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A92A24679;
        Sun, 15 Dec 2019 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576435090;
        bh=px1Gk4vroR3TqFZW5gDgvrfozRTggLwMtMW5vBV1vo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NskZYYBEjS+Nzi+W2BGnAluvbOmDjRj+hJNUIxk3uK0esJV1Hvi3USozPwWZgZrKn
         wtsB96s2QvbyP2SKGPyGxUlWL3QWWdn/I9v3lKU7C91dxRZ5+xv7qoSvd3Ho6evctY
         ErXcGFS/9d8VJxCEPZOmJjDCyl2/bP4fFhdCXWks=
Date:   Sun, 15 Dec 2019 13:38:09 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be,
        kishon@ti.com, pavel@denx.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs
 interface of "role"" failed to apply to 4.14-stable tree
Message-ID: <20191215183809.GM18043@sasha-vm>
References: <15764078564151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15764078564151@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 12:04:16PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 4bd5ead82d4b877ebe41daf95f28cda53205b039 Mon Sep 17 00:00:00 2001
>From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>Date: Mon, 7 Oct 2019 16:55:10 +0900
>Subject: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"
>
>Since the role_store() uses strncmp(), it's possible to refer
>out-of-memory if the sysfs data size is smaller than strlen("host").
>This patch fixes it by using sysfs_streq() instead of strncmp().
>
>Reported-by: Pavel Machek <pavel@denx.de>
>Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
>Cc: <stable@vger.kernel.org> # v4.10+
>Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Acked-by: Pavel Machek <pavel@denx.de>
>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Adjusted context and queued up for 4.14.

-- 
Thanks,
Sasha
