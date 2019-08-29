Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB925A293C
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfH2Vxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 17:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfH2Vxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 17:53:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C351C22CEA;
        Thu, 29 Aug 2019 21:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567115633;
        bh=R3aXZaqEyC9alGN5Bs1uwfdT5AnWDpDWnT9c05yJZz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GKpGL+HcaRP8Gu5OaUhhGtv+yvh9ePxDitauBgKKAsKD04m7RJ3JOM0394xjHn5Ic
         yQH5zFLgC1PovloHoaNqXTuCiYmdrwoDMChyxrT9SmQb3ZjwHKErhFcswNhiLfpQDq
         NBJYy1kjzYgzsA5Se78hsMQxEYBqyMRE23mvp07c=
Date:   Thu, 29 Aug 2019 17:53:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     stable@vger.kernel.org, Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] watchdog: bcm2835_wdt: Fix module autoload
Message-ID: <20190829215351.GO5281@sasha-vm>
References: <1567010414-3518-1-git-send-email-wahrenst@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1567010414-3518-1-git-send-email-wahrenst@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 06:40:14PM +0200, Stefan Wahren wrote:
>commit 215e06f0d18d5d653d6ea269e4dfc684854d48bf upstream.
>
>The commit 5e6acc3e678e ("bcm2835-pm: Move bcm2835-watchdog's DT probe
>to an MFD.") broke module autoloading on Raspberry Pi. So add a
>module alias this fix this.
>
>Fixes: 5e6acc3e678e ("bcm2835-pm: Move bcm2835-watchdog's DT probe to an MFD.")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
>---
> drivers/watchdog/bcm2835_wdt.c | 1 +
> 1 file changed, 1 insertion(+)
>
>Hi Greg,
>please apply to the Linux 5.2 stable branch, because without this patch
>the Raspberry Pi might not be able to reboot.

I've queued it for all stable trees, thanks!

--
Thanks,
Sasha
