Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727483C23F5
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhGINIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:08:55 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39555 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231285AbhGINIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 09:08:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D90E2580353;
        Fri,  9 Jul 2021 09:06:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 09 Jul 2021 09:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=+RooWhsOcXdFOl/u1lTFG0xSbo6
        biVNCTWoOqJLKN54=; b=p7XMXDd6NxZTnscQSZ5jCtQJsdmBMD+uaOS3LJD/F4g
        8iPqgU8r0465AXOI9ePEnkHcD5GKLTiCvmFF2pnEPlqpe6gl8pqly+kUtUMQXUtZ
        z6+HAHqDaoK7vBqv21i0f/m8VX4cJs8MJgqnPR9P9nsspXLL82WmDPrVMclf9pq3
        2mvPLvABMtNSw9uZ/Vuwlxr6BnEaGjpYQl0YzFRvQRWwAu6wbEFCBydm+u/SQlzF
        O6B6mx5z5MBilQ0H/x3WDDkQ07FBklKqg1uJX/T6kegxjiK2CV9+TvawR8fCjYee
        CN+uEiKzG0aWSAKgnj1vuaQGfSq3c/hiThh8ecKzxEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+RooWh
        sOcXdFOl/u1lTFG0xSbo6biVNCTWoOqJLKN54=; b=Qpd1djZGSXnlCNjHdeNCuM
        3fb1hk5lqEgU/iCxh4jFBUwdffICPznBMMnn0ZxMBLUJW9wqLNucIAIZuqpeSWqg
        B08mXpUizzKU+DvOdkgqxo/i+7nRgd9jKaPJ/W556wG91qpV8NAOKLP6G/QyIHVt
        ALbEtCFCeXhez3Bx3UUpyUxlcSz5VRZ1J43rJvq8+2CU8mXXPJ6NWH/UT9k0iOao
        hgrkMHLOaJo+cbFEls/LbSZ3q1hsu+/ZSeJRvXqvfOSl4KtRANX/obeFc5OtMFd9
        OKs3i7gDDfpC6fhb6XaW3zLMZgrIKRuhPQebtzf0Se3ciZ0DxWFO5NrAKerrM2YQ
        ==
X-ME-Sender: <xms:wknoYKTefwXfDFBvTtoVGJ1iuCL00niiHJ6Es1g8FHIz7-IEJ7fyyQ>
    <xme:wknoYPw_n_i3JlQ3_p7EPQT88s_TpW2Jayh9EvZNP64ERk9BhLPO-LhX7oF4XalXL
    fakT-Uuc-zP8w>
X-ME-Received: <xmr:wknoYH3--mrPPzjSHRC7WWMZ0z0qtELcoqASpwdmEBfl4xVTs7Q4uTbFjAYmEgtHJi9u59x9Jy9JdBzcHoQ0fj9hyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeigdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wknoYGAVolMbizhRGbWnqsXMLHWw3GWG3Iw0zb7oFMNfwrD6pQN59A>
    <xmx:wknoYDge-2tvhm73J4TvC5blgzUZ28Cfe5OsPr4RHKRmlLYKfNcLfQ>
    <xmx:wknoYCrKmIP0LRn9SBXgRPqPL5Kit9Lm7zwqC_ZJvjy194E1u2hx7g>
    <xmx:wknoYIauxaK_K9eMBOVHkTvaMWyHmZeElw2beCQ6EGuk0bTdzkTWsQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Jul 2021 09:06:09 -0400 (EDT)
Date:   Fri, 9 Jul 2021 15:06:06 +0200
From:   Greg KH <greg@kroah.com>
To:     Deren Wu <Deren.Wu@mediatek.com>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH 1/1] mt76: mt7921: get rid of mcu_reset function pointer
Message-ID: <YOhJvlIIipesC0sF@kroah.com>
References: <cover.1625806023.git.deren.wu@mediatek.com>
 <05ba0c23ecacf740942f62b12fe2f39ed31be106.1625806023.git.deren.wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05ba0c23ecacf740942f62b12fe2f39ed31be106.1625806023.git.deren.wu@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:07:19PM +0800, Deren Wu wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [ Upstream commit d43b3257621dfe57c71d875afd3f624b9a042fc5 ]
> 
> since mcu_reset it used only by mt7921, move the reset callback to
> mt7921_mcu_parse_response routine and get rid of the function pointer.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Link: https://lore.kernel.org/linux-wireless/364293ec8609dd254067d8173c1599526ffd662c.1619000828.git.lorenzo@kernel.org/
> Signed-off-by: Deren Wu <deren.wu@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.12: f92f81d35ac2 mt76: mt7921: check mcu returned values in mt7921_start
> Cc: <stable@vger.kernel.org> # 5.12: d32464e68ffc mt76: mt7921: introduce mt7921_run_firmware utility routine.
> Cc: <stable@vger.kernel.org> # 5.12: 1f7396acfef4 mt76: mt7921: introduce __mt7921_start utility routine
> Cc: <stable@vger.kernel.org> # 5.12: 3990465db682 mt76: dma: introduce mt76_dma_queue_reset routine
> Cc: <stable@vger.kernel.org> # 5.12: c001df978e4c mt76: dma: export mt76_dma_rx_cleanup routine
> Cc: <stable@vger.kernel.org> # 5.12: 0c1ce9884607 mt76: mt7921: add wifi reset support
> Cc: <stable@vger.kernel.org> # 5.12: e513ae49088b mt76: mt7921: abort uncompleted scan by wifi reset
> Cc: <stable@vger.kernel.org> # 5.12
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

All now queued up, thanks.

greg k-h
