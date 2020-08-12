Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEBE242A4C
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgHLNZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:25:44 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37269 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728021AbgHLNZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:25:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id E19AB5803DD;
        Wed, 12 Aug 2020 09:25:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 12 Aug 2020 09:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=8E1y/NnvHjfdOcfGM816z3reqbY
        KZDOAgNdGXHxjGaw=; b=EBXQHQd4ryb+F9ZSaBv9Q4BavNlR/kSgNXRrWiDRI1M
        rxeNQQFxG65rc1Yo47lPFN8Jyaf6x3tQTN9x5PxHbMiI8CZYVqj5mj7SpNIZ1+/v
        i6JCDMCBxgm5UDsN0pRYM6PWGU4Pa6RXLBObLzVe8OSzopE/saG4c//y9c+OzA3/
        g18/6YPPjk63YYfX/XAqBaw+lgydli57DeWdQkQuWRZXS/2RBOZk5VYR5rye/h2w
        6kIhzTUVwyCw+EwEgwPLuKLwnP2WI7pJExI6SXmuj/+gc6vWIHlNOPnDZ1stzS+L
        iZxMDCLnoVLMQtnEEBl6nTkd4V3BEPvNFCKywTJnKug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8E1y/N
        nvHjfdOcfGM816z3reqbYKZDOAgNdGXHxjGaw=; b=DD3j5hLY3gCCHmltFjc/qD
        4XSow+h2EY4M35Ttu0HlDWYygxXfBUz6ovouBxVz8QShSE/jLsjnbpBnE9rAhngP
        m6d1gNp/PQhTe/AbC8cmC9ckDj1tIHwMQtJ2keG+TBowaNZ4DHZTQm0ch2JN0/E4
        lISnpo6kthmnm+I3Ptf80NM3gAEKw6td2qEDNzEqJRszc9ZKshmMRoVXpyyVreho
        Jz0kY/Fe3/fpI+G7f0Sn3SivkoIjRFBKVfZyXBF1ETnTRN19ML8GKx52ghO7FeMi
        goclXhwsQYFOUFVhvPve1YmedholFb6yPO/OzRUOBfBLpThaxMDm0TIrV56hF+TQ
        ==
X-ME-Sender: <xms:0u0zXyalJ6S-Oy_DwzV1_DLJBLdT8_moKz1CeSKyFv0w6Gvxce2_XQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrledvgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:0u0zX1aRP_6XWlm8ufBhncwcIEifV7fQNN0vpHh8Zp8w4l2X1Iv3Bw>
    <xmx:0u0zX899TOTDry5VHQUw8-EwbWyTN6zscayViVbfxj25jXWRDeP47w>
    <xmx:0u0zX0r3UK9LEkh89x2oBMqz5hVf5FYhbB0o4HcRSSg7G5yWRiB_Vw>
    <xmx:0u0zX41-GhDh1hDSkwwNTNcrmCmnfuvYrNMVBs-dNAq4868WjfJMJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BA133060717;
        Wed, 12 Aug 2020 09:25:38 -0400 (EDT)
Date:   Wed, 12 Aug 2020 15:25:49 +0200
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
Subject: Re: [v2,1/3] mmc: dt-bindings: Add resets/reset-names for Mediatek
 MMC bindings
Message-ID: <20200812132549.GC2489711@kroah.com>
References: <20200812130129.13519-1-wenbin.mei@mediatek.com>
 <20200812130129.13519-2-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812130129.13519-2-wenbin.mei@mediatek.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 09:01:27PM +0800, Wenbin Mei wrote:
> Add description for resets/reset-names.
> 
> Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
> ---
>  Documentation/devicetree/bindings/mmc/mtk-sd.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/mtk-sd.txt b/Documentation/devicetree/bindings/mmc/mtk-sd.txt
> index 8a532f4453f2..15d42595a3f3 100644
> --- a/Documentation/devicetree/bindings/mmc/mtk-sd.txt
> +++ b/Documentation/devicetree/bindings/mmc/mtk-sd.txt
> @@ -49,6 +49,8 @@ Optional properties:
>  		     error caused by stop clock(fifo full)
>  		     Valid range = [0:0x7]. if not present, default value is 0.
>  		     applied to compatible "mediatek,mt2701-mmc".
> +- resets: Phandle and reset specifier pair to softreset line of MSDC IP.
> +- reset-names: should be "hrst".
>  
>  Examples:
>  mmc0: mmc@11230000 {
> -- 
> 2.18.0

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
