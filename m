Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8488C18EC7D
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 22:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCVVOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 17:14:40 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:46069 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCVVOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Mar 2020 17:14:40 -0400
X-Originating-IP: 86.202.105.35
Received: from localhost (lfbn-lyo-1-9-35.w86-202.abo.wanadoo.fr [86.202.105.35])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 010E6FF80D;
        Sun, 22 Mar 2020 21:14:37 +0000 (UTC)
Date:   Sun, 22 Mar 2020 22:14:37 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     a.zummo@towertech.it, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtc: max8907: add missing select REGMAP_IRQ
Message-ID: <20200322211437.GE221863@piout.net>
References: <1584545209-20433-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584545209-20433-1-git-send-email-clabbe@baylibre.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/03/2020 15:26:49+0000, Corentin Labbe wrote:
> I have hit the following build error:
> armv7a-hardfloat-linux-gnueabi-ld: drivers/rtc/rtc-max8907.o: in function `max8907_rtc_probe':
> rtc-max8907.c:(.text+0x400): undefined reference to `regmap_irq_get_virq'
> 
> max8907 should select REGMAP_IRQ
> 
> Fixes: 94c01ab6d7544 ("rtc: add MAX8907 RTC driver")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/rtc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
Applied, thanks.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
