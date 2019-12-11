Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAA211A876
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 11:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfLKKA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 05:00:59 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47455 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKKA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 05:00:58 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ieynh-0002xu-4L; Wed, 11 Dec 2019 11:00:57 +0100
Message-ID: <c5fcb87bb36831776d17101e0e6e0e99b86f434c.camel@pengutronix.de>
Subject: Re: [PATCH] ARM: davinci: select CONFIG_RESET_CONTROLLER
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Sekhar Nori <nsekhar@ti.com>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>,
        David Lechner <david@lechnology.com>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 11 Dec 2019 11:00:56 +0100
In-Reply-To: <CAMpxmJX0jAa4-52pT0rutPz9naRHb4nnZ=cDdvCMLxGh=3m_=A@mail.gmail.com>
References: <20191210195202.622734-1-arnd@arndb.de>
         <CAMpxmJX0jAa4-52pT0rutPz9naRHb4nnZ=cDdvCMLxGh=3m_=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-12-11 at 10:14 +0100, Bartosz Golaszewski wrote:
> wt., 10 gru 2019 o 20:52 Arnd Bergmann <arnd@arndb.de> napisał(a):
> > Selecting RESET_CONTROLLER is actually required, otherwise we
> > can get a link failure in the clock driver:
> > 
> > drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
> > psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_register'
> > drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
> > psc-da850.c:(.text+0x24): undefined reference to `reset_controller_add_lookup'
> > 
> > Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
> > Cc: <stable@vger.kernel.org> # v5.4
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  arch/arm/mach-davinci/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> 
> Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

