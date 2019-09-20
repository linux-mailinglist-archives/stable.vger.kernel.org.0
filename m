Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1A9B918D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbfITOVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:21:03 -0400
Received: from muru.com ([72.249.23.125]:33990 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387817AbfITOVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 10:21:03 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D36A980AA;
        Fri, 20 Sep 2019 14:21:33 +0000 (UTC)
Date:   Fri, 20 Sep 2019 07:20:59 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>
Subject: Re: [Letux-kernel] [PATCH 2/2] DTS: ARM: gta04: introduce legacy
 spi-cs-high to make display work again
Message-ID: <20190920142059.GO5610@atomide.com>
References: <20190724194259.GA25847@bogus>
 <2EA06398-E45B-481B-9A26-4DD2E043BF9C@goldelico.com>
 <CAL_JsqLe_Y9Z6MRt7ojgSVKAb9n95S8j=eGidSVNz2T83j-zPQ@mail.gmail.com>
 <CACRpkdY0AVnkRa8sV_Z54qfX9SYufvaYYhU0k2+LitXo0sLx2w@mail.gmail.com>
 <20190831084852.5e726cfa@aktux>
 <ED6A6797-D1F9-473B-ABFF-B6951A924BC1@goldelico.com>
 <CACRpkdZQgPVvB=78vOFsHe5n45Vwe4N6JJOcm1_vz5FbAw9CYA@mail.gmail.com>
 <1624298A-C51B-418A-96C3-EA09367A010D@goldelico.com>
 <CACRpkdZvpPOM1Ug-=GHf7Z-2VEbJz3Cuo7+0yDFuNm5ShXK8=Q@mail.gmail.com>
 <7DF102BC-C818-4D27-988F-150C7527E6CC@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7DF102BC-C818-4D27-988F-150C7527E6CC@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [190920 09:19]:
> > Am 20.09.2019 um 10:55 schrieb Linus Walleij <linus.walleij@linaro.org>:
> > I suggest to go both way:
> > apply this oneliner and tag for stable so that GTA04 works
> > again.
> > 
> > Then for the next kernel think about a possible more abitious
> > whitelist solution and after adding that remove *all* "spi-cs-high"
> > flags from all device trees in the kernel after fixing them
> > all up.
> 
> Ok, that looks like a viable path.

Please repost the oneline so people can ack easily. At least
I've already lost track of this thread.

Regards,

Tony
