Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF0D1189EA
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfLJNeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 08:34:04 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:37603 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfLJNeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 08:34:04 -0500
X-Originating-IP: 90.182.112.136
Received: from localhost (136.112.broadband15.iol.cz [90.182.112.136])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id B67AC40011;
        Tue, 10 Dec 2019 13:34:01 +0000 (UTC)
Date:   Tue, 10 Dec 2019 14:33:52 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Alessandro Zummo <a.zummo@towertech.it>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-rtc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] rtc: sun6i: Add support for RTC clocks on R40
Message-ID: <20191210133352.GM1463890@piout.net>
References: <20191205085054.6049-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205085054.6049-1-wens@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/12/2019 16:50:54+0800, Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> When support for the R40 in the rtc-sun6i driver was split out for a
> separate compatible string, only the RTC half was covered, and not the
> clock half. Unfortunately this results in the whole driver not working,
> as the RTC half expects the clock half to have been initialized.
> 
> Add support for the clock part as well. The clock part is like the H3,
> but does not need to export the internal oscillator, nor does it have
> a gateable LOSC external output.
> 
> This fixes issues with WiFi and Bluetooth not working on the BPI M2U.
> 
> Fixes: d6624cc75021 ("rtc: sun6i: Add R40 compatible")
> Cc: <stable@vger.kernel.org> # 5.3.x
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
> 
> Please merge this for fixes.
> 
> ---
>  drivers/rtc/rtc-sun6i.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
Applied, thanks.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
