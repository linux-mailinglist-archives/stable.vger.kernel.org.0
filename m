Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7663CE16BF
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 11:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390920AbfJWJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 05:55:58 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:38444 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390384AbfJWJz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 05:55:58 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 811B73C04C1;
        Wed, 23 Oct 2019 11:55:55 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gK48FXrscP2K; Wed, 23 Oct 2019 11:55:48 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id EA0613C009D;
        Wed, 23 Oct 2019 11:55:48 +0200 (CEST)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Wed, 23 Oct
 2019 11:55:48 +0200
Date:   Wed, 23 Oct 2019 11:55:45 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        <stable@vger.kernel.org>
Subject: Re: [RESEND PATCH] ASoC: rsnd: dma: fix SSI9 4/5/6/7 busif dma
 address
Message-ID: <20191023095545.GA20748@vmlxhi-102.adit-jv.com>
References: <20191022185429.12769-1-erosca@de.adit-jv.com>
 <87h840z3l3.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87h840z3l3.wl-kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.12.1+40 (7f8642d4ee82) (2019-06-28)
X-Originating-IP: [10.72.93.184]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Morimoto-san,

On Wed, Oct 23, 2019 at 09:51:36AM +0900, Kuninori Morimoto wrote:
> 
> Hi
> 
> > From: Jiada Wang <jiada_wang@mentor.com>
> > 
> > Currently each SSI unit's busif dma address is calculated by
> > following calculation formula:
> > 0xec540000 + 0x1000 * id + busif / 4 * 0xA000 + busif % 4 * 0x400
> > 
> > But according to R-Car3 HW manual 41.1.4 Register Configuration,
> > ssi9 4/5/6/7 busif data register address
> > (SSI9_4_BUSIF/SSI9_5_BUSIF/SSI9_6_BUSIF/SSI9_7_BUSIF)
> > are out of this rule.
> > 
> > This patch updates the calculation formula to correct
> > ssi9 4/5/6/7 busif data register address.
> > 
> > Fixes: 5e45a6fab3b9 ("ASoc: rsnd: dma: Calculate dma address with consider of BUSIF")
> > Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
> > Signed-off-by: Timo Wischer <twischer@de.adit-jv.com>
> > [erosca: minor improvements in commit description]
> > Cc: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> > Cc: stable@vger.kernel.org # v4.20+
> > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > ---
> 
> Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Many thanks for the prompt responses.

-- 
Best Regards,
Eugeniu
