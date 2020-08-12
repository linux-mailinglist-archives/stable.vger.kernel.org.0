Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F92242A40
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHLNZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:25:26 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:47113 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgHLNZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:25:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 846665803D8;
        Wed, 12 Aug 2020 09:25:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 Aug 2020 09:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=RMHVXbkkQR++heuoiM+MhmJ5JCS
        XfwoEAJZmcGdv5E0=; b=sHdXFrpsqDivqXytN+mzcwAC3wK/gl+f3WcRAdi4PaB
        sjBoxrF9Boeho/UE8NeaElNM904QP2qfQ4bmZWXB/Qp30yvvbgrA+EPaIq+FTnDK
        wt5pIW3mc9j5tKdVfxRQuC9x1qnlESsQ8iRw8T/JSNtJklXaoxnr2lcry2E1Pyf6
        v9ZlJYuCygryjOncMiv5ayI6NuEKb3ptP4Irv+fLDrvMksC0+9ggJ/ltFC+9nB2q
        pR28PmWbdx5WkeVOkBeA2B/09xFDjwcXb3OwhZhTlp7BjlDOtcyEsXU4iM0gI7+t
        bvN7fqncVQAN84gy38LQoJRHpibad+9a8/DZyeJURiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RMHVXb
        kkQR++heuoiM+MhmJ5JCSXfwoEAJZmcGdv5E0=; b=nnd9aDAe3uRQZt9RpaQ3Yu
        wXsVSELMVioDXhKTOICCCFPEO7GsjChFyug1hRhArcNR+ZCXW7oQv9wxJtxWzOwG
        KIBkmiHjcDm17hbNGxTXkjXPi1qz+F4TpEnZHB6hVmUIgRAAR+K+c7YSc3oL2R0g
        Xw7yiXKH9+XgDS5DGUlhRsp9s99FpYNx4UIsTNxQ+vm+ByeXOCLrwD/VJB6nJKKN
        WSWyO3jMLXV9cgou1hCG9wYMpxeibTuDqaj5mjNH0A5EHeLjjjY3287LqQaBKASG
        //nrliteazYATIz15qc3lU5d7lnVR5tSrQfA5hfk7y1MwLjafSdcqtjS5Ft+nHXA
        ==
X-ME-Sender: <xms:w-0zXytFvE8q2H6PMYuY_EqkoCHuNVtkGcK9x_YovuSpVRhHJjfITw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrledvgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:w-0zX3cx6G6iRvRDAbPdS5a1hZVce8CKcQNLbhWnX2z2wWyZGkgw-w>
    <xmx:w-0zX9xRYphP1JT1ZNcglcxX468swkKT88cgkP81AJNnxJXMgdZyqg>
    <xmx:w-0zX9PuG7srrDgRJ2e-MbIoGN5MdAFrsGnXoRy3yA6jvTmvtXVvWA>
    <xmx:xO0zX1Zqpi7Juq1WK7UB5WMHyl88blX6ITnH77B8nyMCgvEPIe4VQA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9C0D328005E;
        Wed, 12 Aug 2020 09:25:22 -0400 (EDT)
Date:   Wed, 12 Aug 2020 15:25:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Wenbin Mei <wenbin.mei@mediatek.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, srv_heupstream@mediatek.com
Subject: Re: [v2,0/3] add optional reset property arm64: dts: mt7622: add
 reset node for mmc device  mmc: mediatek: add optional module reset property
 Documentation/devicetree/bindings/mmc/mtk-sd.txt |  2 ++
 arch/arm64/boot/dts/mediatek/mt7622.dtsi         |  2 ++
 drivers/mmc/host/mtk-sd.c                        | 13 +++++++++++++ 3 files
 changed, 17 insertions(+)
Message-ID: <20200812132532.GA2489711@kroah.com>
References: <20200812130129.13519-1-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812130129.13519-1-wenbin.mei@mediatek.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 09:01:26PM +0800, Wenbin Mei wrote:
> --
> 2.18.0

I think something is wrong with your subject line :(
