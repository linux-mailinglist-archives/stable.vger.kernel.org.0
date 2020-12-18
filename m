Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8462DDEE4
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 08:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgLRHNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 02:13:40 -0500
Received: from muru.com ([72.249.23.125]:39372 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgLRHNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Dec 2020 02:13:40 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 32D73809F;
        Fri, 18 Dec 2020 07:13:01 +0000 (UTC)
Date:   Fri, 18 Dec 2020 09:12:55 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org,
        Andreas Kemnade <andreas@kemnade.info>, stable@vger.kernel.org
Subject: Re: [PATCH] DTS: ARM: gta04: remove legacy spi-cs-high to make
 display work again
Message-ID: <20201218071255.GD26857@atomide.com>
References: <de8774e44a8f6402435e64034b8e7122157f5b52.1607766924.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de8774e44a8f6402435e64034b8e7122157f5b52.1607766924.git.hns@goldelico.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [201212 11:59]:
> This reverts
> 
> commit f1f028ff89cb ("DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again")
> 
> which had to be intruduced after
> 
> commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")
> 
> broke the GTA04 display. This contradicted the data sheet but was the only
> way to get it as an spi client operational again.
> 
> The panel data sheet defines the chip-select to be active low.
> 
> Now, with the arrival of
> 
> commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
> 
> the logic of interaction between spi-cs-high and the gpio descriptor flags
> has been changed a second time, making the display broken again. So we have
> to remove the original fix which in retrospect was a workaround of a bug in
> the spi subsystem and not a feature of the panel or bug in the device tree.
> 
> With this fix the device tree is back in sync with the data sheet and
> spi subsystem code.

Thanks applying into fixes.

Tony
