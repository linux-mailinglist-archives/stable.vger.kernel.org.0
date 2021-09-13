Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A83408A04
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhIMLVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:21:54 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:55536 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239504AbhIMLVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:21:53 -0400
Received: from [10.1.22.96] (unknown [10.1.22.96])
        by uho.ysoft.cz (Postfix) with ESMTP id AFDC3A6393;
        Mon, 13 Sep 2021 13:20:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1631532033;
        bh=VTfjBwSA+tm/qkHHH9rdmUMTuQmZ5GRrsz/L/qmkADc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kll25NEqXmVe/0eE/fNDEyF7osI3IhaYElCM4xvUT4/phe+dUYWZnSeP3YBDZSMzV
         wgKMGXobUIsayWFHhb0+Y8kOOBmo53Mc7prcD7GedBphxaKFKIKomjziTyFWn0ZlS0
         Pzo6h9ORzHh51atSPUKHOsXe3zHhzxoUKr7wOEZ0=
Subject: Re: [PATCH 1/2] ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-leds@vger.kernel.org
References: <20210818070209.1540451-1-michal.vokac@ysoft.com>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <19c8bb7d-6fe5-3b7d-a8b5-785ba93f7265@ysoft.com>
Date:   Mon, 13 Sep 2021 13:20:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818070209.1540451-1-michal.vokac@ysoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18. 08. 21 9:02, Michal Vokáč wrote:
> Since the LED multicolor framework support was added in commit
> 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> LEDs on this platform stopped working.
> 
> Author of the framework attempted to accommodate this DT to the
> framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property
> to the lp5562 channel node") but that is not sufficient. A color property
> is now required even if the multicolor framework is not used, otherwise
> the driver probe fails:
> 
>    lp5562: probe of 1-0030 failed with error -22
> 
> Add the color property to fix this.
> 
> Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> Cc: <stable@vger.kernel.org>
> Cc: linux-leds@vger.kernel.org
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Hi Shawn,
gentle ping on this little series.

Thank you,
Michal
