Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84112E7734
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 09:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgL3ItP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 03:49:15 -0500
Received: from muru.com ([72.249.23.125]:40560 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL3ItP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 03:49:15 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 6407780BA;
        Wed, 30 Dec 2020 08:48:47 +0000 (UTC)
Date:   Wed, 30 Dec 2020 10:48:30 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org,
        Andreas Kemnade <andreas@kemnade.info>,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: Re: [PATCH] DTS: ARM: gta04: SPI panel chip select is active low
Message-ID: <20201230084830.GG26857@atomide.com>
References: <a539758e798631b54a85df102a1c6635e1f70b37.1608719420.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a539758e798631b54a85df102a1c6635e1f70b37.1608719420.git.hns@goldelico.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [201223 12:33]:
> With the arrival of
> 
> commit 2fee9583198eb9 ("spi: dt-bindings: clarify CS behavior for spi-cs-high and gpio descriptors")
> 
> it was clarified what the proper state for cs-gpios should be, even if the
> flag is ignored. The driver code is doing the right thing since
> 
> 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
> 
> The chip-select of the td028ttec1 panel is active-low, so we must omit spi-cs-high;
> attribute (already removed by separate patch) and should now use GPIO_ACTIVE_LOW for
> the client device description to be fully consistent.

Applying into fixes thanks.

Tony
