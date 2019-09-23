Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706DBBBA96
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 19:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440190AbfIWReq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 13:34:46 -0400
Received: from muru.com ([72.249.23.125]:34244 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389167AbfIWReq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 13:34:46 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C7A37809F;
        Mon, 23 Sep 2019 17:35:16 +0000 (UTC)
Date:   Mon, 23 Sep 2019 10:34:41 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, broonie@kernel.org,
        linus.walleij@linaro.org, stable@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: [PATCH v2] DTS: ARM: gta04: introduce legacy spi-cs-high to make
 display work again
Message-ID: <20190923173441.GV5610@atomide.com>
References: <c031340840daba810bb2a612c35eea7fab307e56.1568995874.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c031340840daba810bb2a612c35eea7fab307e56.1568995874.git.hns@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [190920 09:12]:
> commit 6953c57ab172 "gpio: of: Handle SPI chipselect legacy bindings"
> 
> did introduce logic to centrally handle the legacy spi-cs-high property
> in combination with cs-gpios. This assumes that the polarity
> of the CS has to be inverted if spi-cs-high is missing, even
> and especially if non-legacy GPIO_ACTIVE_HIGH is specified.
> 
> The DTS for the GTA04 was orginally introduced under the assumption
> that there is no need for spi-cs-high if the gpio is defined with
> proper polarity GPIO_ACTIVE_HIGH.
> 
> This was not a problem until gpiolib changed the interpretation of
> GPIO_ACTIVE_HIGH and missing spi-cs-high.
> 
> The effect is that the missing spi-cs-high is now interpreted as CS being
> low (despite GPIO_ACTIVE_HIGH) which turns off the SPI interface when the
> panel is to be programmed by the panel driver.
> 
> Therefore, we have to add the redundant and legacy spi-cs-high property
> to properly activate CS.

Thanks applying into fixes.

Tony
