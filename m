Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD5B9489
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404595AbfITPxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 11:53:12 -0400
Received: from muru.com ([72.249.23.125]:34078 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404366AbfITPxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 11:53:11 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C93FF80AA;
        Fri, 20 Sep 2019 15:53:40 +0000 (UTC)
Date:   Fri, 20 Sep 2019 08:53:06 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>
Subject: Re: [Letux-kernel] [PATCH 2/2] DTS: ARM: gta04: introduce legacy
 spi-cs-high to make display work again
Message-ID: <20190920155306.GT5610@atomide.com>
References: <20190831084852.5e726cfa@aktux>
 <ED6A6797-D1F9-473B-ABFF-B6951A924BC1@goldelico.com>
 <CACRpkdZQgPVvB=78vOFsHe5n45Vwe4N6JJOcm1_vz5FbAw9CYA@mail.gmail.com>
 <1624298A-C51B-418A-96C3-EA09367A010D@goldelico.com>
 <CACRpkdZvpPOM1Ug-=GHf7Z-2VEbJz3Cuo7+0yDFuNm5ShXK8=Q@mail.gmail.com>
 <7DF102BC-C818-4D27-988F-150C7527E6CC@goldelico.com>
 <20190920142059.GO5610@atomide.com>
 <633E7AD9-A909-4619-BBD7-8CFD965FDFF7@goldelico.com>
 <20190920172947.51c1fdec@aktux>
 <96E62EC2-2A3E-4722-A9DE-3F320B0A98B0@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96E62EC2-2A3E-4722-A9DE-3F320B0A98B0@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [190920 15:50]:
> 
> > Am 20.09.2019 um 17:29 schrieb Andreas Kemnade <andreas@kemnade.info>:
> > 
> > On Fri, 20 Sep 2019 16:54:18 +0200
> > "H. Nikolaus Schaller" <hns@goldelico.com> wrote:
> > 
> >>> Am 20.09.2019 um 16:20 schrieb Tony Lindgren <tony@atomide.com>:
> >>> 
> >>> * H. Nikolaus Schaller <hns@goldelico.com> [190920 09:19]:  
> >>>>> Am 20.09.2019 um 10:55 schrieb Linus Walleij <linus.walleij@linaro.org>:
> >>>>> I suggest to go both way:
> >>>>> apply this oneliner and tag for stable so that GTA04 works
> >>>>> again.
> >>>>> 
> >>>>> Then for the next kernel think about a possible more abitious
> >>>>> whitelist solution and after adding that remove *all* "spi-cs-high"
> >>>>> flags from all device trees in the kernel after fixing them
> >>>>> all up.  
> >>>> 
> >>>> Ok, that looks like a viable path.  
> >>> 
> >>> Please repost the oneline so people can ack easily. At least
> >>> I've already lost track of this thread.  
> >> 
> >> It is all here:
> >> 
> >> https://patchwork.kernel.org/patch/11035253/
> >> 
> > It is the full one (incl. documentation), not the oneline and does not
> > apply.
> 
> Looks as if it was sitting too long in the queue and linux-next has changed
> the basis in the meantime, while v5.3 has not yet.
> 
> Documentation/devicetree/bindings/spi/spi-bus.txt -> spi-controller.yaml
> 
> So it should still apply for v5.3.1 and earlier and we need both versions.
> One for stable and one for linux-next. I don't know how to handle such cases.

Please just repost a minimal dts one line fix. Then a separate
patch for the documentation changes.

Regards,

Tony
