Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC08B93FD
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 17:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbfITP3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 11:29:55 -0400
Received: from mail.andi.de1.cc ([85.214.55.253]:50946 "EHLO mail.andi.de1.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403864AbfITP3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 11:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kemnade.info; s=20180802; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qh3P5/SZMYKeIWLUA96JzcgTyGmu9FuvTbiIGrMfEvc=; b=UGc1aAATcQvu8kew+5z5uUDMos
        FJ+EtD7qYHgZb1Ambevwl5xKBLP8y5kq8J6gM8hGDKTizffhMUE3XNGZjBZ+UN4QQAmNEAAg0x5Xc
        94xQszMY6rh/l/Tb5Sy3jIvfScKQgniVncqOby3wkaTdj4La844i9y0iKqMtX+DXZDQs=;
Received: from p5dcc3979.dip0.t-ipconnect.de ([93.204.57.121] helo=aktux)
        by mail.andi.de1.cc with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1iBKqy-0000hs-PO; Fri, 20 Sep 2019 17:29:49 +0200
Date:   Fri, 20 Sep 2019 17:29:47 +0200
From:   Andreas Kemnade <andreas@kemnade.info>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?QmVub8OudA==?= Cousson <bcousson@baylibre.com>
Subject: Re: [Letux-kernel] [PATCH 2/2] DTS: ARM: gta04: introduce legacy
 spi-cs-high to make display work again
Message-ID: <20190920172947.51c1fdec@aktux>
In-Reply-To: <633E7AD9-A909-4619-BBD7-8CFD965FDFF7@goldelico.com>
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
        <20190920142059.GO5610@atomide.com>
        <633E7AD9-A909-4619-BBD7-8CFD965FDFF7@goldelico.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Sep 2019 16:54:18 +0200
"H. Nikolaus Schaller" <hns@goldelico.com> wrote:

> > Am 20.09.2019 um 16:20 schrieb Tony Lindgren <tony@atomide.com>:
> > 
> > * H. Nikolaus Schaller <hns@goldelico.com> [190920 09:19]:  
> >>> Am 20.09.2019 um 10:55 schrieb Linus Walleij <linus.walleij@linaro.org>:
> >>> I suggest to go both way:
> >>> apply this oneliner and tag for stable so that GTA04 works
> >>> again.
> >>> 
> >>> Then for the next kernel think about a possible more abitious
> >>> whitelist solution and after adding that remove *all* "spi-cs-high"
> >>> flags from all device trees in the kernel after fixing them
> >>> all up.  
> >> 
> >> Ok, that looks like a viable path.  
> > 
> > Please repost the oneline so people can ack easily. At least
> > I've already lost track of this thread.  
> 
> It is all here:
> 
> https://patchwork.kernel.org/patch/11035253/
> 
It is the full one (incl. documentation), not the oneline and does not
apply. Now lets not discuss whether it is well documented or not. First
get it fixed. 

Regards,
Andreas
