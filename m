Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43CE1232E0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 17:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfLQQqp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 17 Dec 2019 11:46:45 -0500
Received: from muru.com ([72.249.23.125]:48958 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbfLQQqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 11:46:44 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 6275E8116;
        Tue, 17 Dec 2019 16:47:22 +0000 (UTC)
Date:   Tue, 17 Dec 2019 08:46:40 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, sre@kernel.org, nekit1000@gmail.com,
        mpartap@gmx.net, merlijn@wizzup.org, martin_rysavy@centrum.cz,
        Sekhar Nori <nsekhar@ti.com>, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Lechner <david@lechnology.com>
Subject: Re: TI omap compile problem in 5.5-rc1? was Re: [PATCH] ARM:
 davinci: select CONFIG_RESET_CONTROLLER
Message-ID: <20191217164640.GX35479@atomide.com>
References: <20191210195202.622734-1-arnd@arndb.de>
 <20191217104520.GA6812@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191217104520.GA6812@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [191217 10:46]:
> Hi!
> 
> > Selecting RESET_CONTROLLER is actually required, otherwise we
> > can get a link failure in the clock driver:
> > 
> > drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
> > psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_register'
> > drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
> > psc-da850.c:(.text+0x24): undefined reference to
> > `reset_controller_add_lookup'
> 
> Does omap need similar handing in 5.5-rc1?
> 
>   LD      .tmp_vmlinux1
>   drivers/soc/ti/omap_prm.o: In function `omap_prm_probe':
>   omap_prm.c:(.text+0x4d0): undefined reference to
>   `devm_reset_controller_register'
>   /data/fast/l/k/Makefile:1077: recipe for target 'vmlinux' failed
>   make[1]: *** [vmlinux] Error 1
> 
> Enabling reset controller seems to help::
> 
> Reset Controller Support (RESET_CONTROLLER) [Y/n/?] (NEW)
>   TI SYSCON Reset Driver (RESET_TI_SYSCON) [N/m/y/?] (NEW)

Yes see the patch Arnd recently posted to do that.

Regards,

Tony


