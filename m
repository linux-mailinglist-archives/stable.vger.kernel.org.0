Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F80DD9A0
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfJSQXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 12:23:00 -0400
Received: from muru.com ([72.249.23.125]:38240 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfJSQXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Oct 2019 12:23:00 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 265D880E2;
        Sat, 19 Oct 2019 16:23:33 +0000 (UTC)
Date:   Sat, 19 Oct 2019 09:22:55 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        kernel@pyra-handheld.com,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [PATCH 5/9] omap: pdata-quirks: remove openpandora quirks for
 mmc3 and wl1251
Message-ID: <20191019162255.GR5610@atomide.com>
References: <63f59daa6b6e079905ff128b88282cf2c72e3540.1571430329.git.hns@goldelico.com>
 <20191019133621.C1CE421897@mail.kernel.org>
 <A0434659-A282-44AA-90E9-D234ADF8A04A@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A0434659-A282-44AA-90E9-D234ADF8A04A@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [191019 15:18]:
> 
> > Am 19.10.2019 um 15:36 schrieb Sasha Levin <sashal@kernel.org>:
> > 
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: 81eef6ca92014 mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel.
> > 
> > The bot has tested the following trees: v5.3.6, v4.19.79, v4.14.149, v4.9.196.
> > 
> > v5.3.6: Build OK!
> > v4.19.79: Failed to apply! Possible dependencies:
> >    Unable to calculate
> > 
> > v4.14.149: Failed to apply! Possible dependencies:
> >    0486738928bf0 ("ARM: OMAP1: ams-delta: add GPIO lookup tables")
> >    0920ca103f8d8 ("ARM: sa1100: provide infrastructure to support generic CF sockets")
> >    29786e9b6551b ("ARM: sa1100/assabet: convert to generic CF sockets")
> >    2bcb1be092370 ("Input: ams_delta_serio: Replace power GPIO with regulator")
> >    56de7570b3264 ("Input: ams_delta_serio: use private structure")
> >    7be893aa2d6a1 ("pcmcia: sa1100: provide generic CF support")
> >    b51af86559d4b ("ARM: sa1100/shannon: convert to generic CF sockets")
> >    b955153bfa68d ("ARM: sa1100/assabet: add BCR/BSR GPIO driver")
> >    c2f9b05fd5c12 ("media: arch: sh: ecovec: Use new renesas-ceu camera driver")
> >    df88c57689278 ("Input: ams_delta_serio: convert to platform driver")
> >    efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
> 
> ^^^ this is the relevant one.
> 
> > 
> > v4.9.196: Failed to apply! Possible dependencies:
> >    0486738928bf0 ("ARM: OMAP1: ams-delta: add GPIO lookup tables")
> >    072f58af1dfbc ("ARM: dts: Add devicetree for the Raspberry Pi 3, for arm32 (v6)")
> >    1aa1d858f582c ("ARM: dts: bcm283x: Add dtsi for OTG mode")
> >    29786e9b6551b ("ARM: sa1100/assabet: convert to generic CF sockets")
> >    2bcb1be092370 ("Input: ams_delta_serio: Replace power GPIO with regulator")
> >    3bfe25fa9f8a5 ("ARM: dts: bcm283x: Move the BCM2837 DT contents from arm64 to arm.")
> >    56de7570b3264 ("Input: ams_delta_serio: use private structure")
> >    6c1b417adc8fa ("ARM: pxa: ezx: use the new pxa_camera platform_data")
> >    7ade445c26269 ("ARM: pxa: magician: Add support for ADS7846 touchscreen")
> >    8f9bafbb92c03 ("ARM: dts: aspeed: Add Romulus BMC platform")
> >    b24413180f560 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
> >    b5478c1b67bcd ("alpha: add asm/extable.h")
> >    b955153bfa68d ("ARM: sa1100/assabet: add BCR/BSR GPIO driver")
> >    d9fa04725f27f ("ARM: pxa: em-x270: use the new pxa_camera platform_data")
> >    df88c57689278 ("Input: ams_delta_serio: convert to platform driver")
> >    efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
> >    fe7bf9dcfff5b ("ARM: dts: add a devicetree for Raidsonic NAS IB-4220-B")
> > 
> > 
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> > 
> > How should we proceed with this patch?
> 
> I have checked and the reason is that 
> 
> efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
> 
> was introduced after v.4.19 which was also partially reverted by this patch
> if based on mainline.
> 
> I have split it up into the partial revert of efdfeb079cc3b  for mainline
> and the real patch which now applies to all relevant stable trees.
> 
> So I'll sent a v2 asap.

Please also remove arch/arm/mach-omap2/hsmmc.[ch] as I think that
can be now done :)

Regards,

Tony
