Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A224657025
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 22:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiL0V6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 16:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiL0V6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 16:58:21 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B77EBCBC;
        Tue, 27 Dec 2022 13:58:21 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8C5643200313;
        Tue, 27 Dec 2022 16:58:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 27 Dec 2022 16:58:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1672178299; x=
        1672264699; bh=BRYkKv/63HiIvCeR/wRha/7QdCIEwDTvI6f+NoGdd6k=; b=o
        VjHtJUy7H7tWsCvDxBCu5xZMwmGTBvKmAbWMoSGX1AIWA1vffPHWiiQD2iMoq2p3
        5cNG6c2xLbqZHus8UAXy/jx7DizH29zmk3P5fDqZfVRyeVUG1a6YFHjbHFkvmITI
        d0WJ46U5Wp9eYhQX15eBpcqRIOEweKJJPH33KxLDVB97w5FfC0JsLP+yxViQON05
        4fWk7m3vzrm99RyRA34LTO0Q3V4H5rHF4WV48Yk1zwKX4d1yodN5t6eaXf9M7NqS
        DshOm7VR60jKGNeIi/fCFsI3GVxuUh2awZzjZXCeI8APcXcXwt/WIOqvJxgmVwbi
        OyACSyDcmNgJWmEali2Vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1672178299; x=
        1672264699; bh=BRYkKv/63HiIvCeR/wRha/7QdCIEwDTvI6f+NoGdd6k=; b=Q
        1t/X1jOEk+0gkiUDEfEIqFT4X2QJT+nIKCXGul1N3HRoEtVhCLTGL4pgZurOcjDd
        XAZ9NZnoIbixOEDxdniOjzxFpdsAo7lI7cT5m1qMohxjldXylv5Reb+DZOr4L+4x
        omOQaXg3OMzunH0u7rf5CpofWqpFzvHEgSVvSusjQSW/sQRXYUJvzsE6vq9XschU
        nVy74o1ZBA0JgktijnbFp49grQ+XAi8gLphUslAv9Yd3yfngaUu2S3X5Y+TyFTSK
        zLNiQuBwImjUhK+azu2Oau/7jcVmkfzXysnKd34LV6npnQlioRvaNCd24SH8BQlH
        9l9C+OS3rRH5KckRO0gRQ==
X-ME-Sender: <xms:emqrYzkVrv77Ll1omVRPLV3vAJwHOVHaNjO8C90pw34RvvYhPyXTQg>
    <xme:emqrY21bsh3ND9valVNr2fbXnwbCdZVu1A9QV-YNOadCbRBI4CzlFiafTKIssqTpk
    a52eGaPVeYfhnGw1Q>
X-ME-Received: <xmr:emqrY5oz8ahQi_p4bexMUl8YuzddKe5wwqwC9g8B_OzxPlhlu6MzQAQ9g4Mz8F9jzhjEqy49Aeplp8t46Pn2R208IC_cBiGnvTeS8K5hv1OlMCIgDFlKtRWKJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedriedtgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfvfevfhfhufgjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghm
    uhgvlhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeehtedtfeegueduledvffeljeehjeeuleduudeivdekffegteeu
    vedvledvteefjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhl
    rghnugdrohhrgh
X-ME-Proxy: <xmx:emqrY7nA6gUSMyaWpoH0eyHcbekcNYtTQIcnpxf3wNmWi2ILXNLzZg>
    <xmx:emqrYx0J6sLGWZX5xtq-aan4YzHjLYL-UwNTNeNRXZb74TjZIws-og>
    <xmx:emqrY6uLeE8ZkDiLHDF15NKqfS78NK6rqYtpNTnPmLwqnS9Zvj0Z5w>
    <xmx:e2qrY6scCeOYAhHVPh3PtjdhGoNIW9x2o_zHcjIsTK2b_fHjm0bLQw>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Dec 2022 16:58:17 -0500 (EST)
Message-ID: <530561e9-9ef8-7c8c-8e73-838c86a92266@sholland.org>
Date:   Tue, 27 Dec 2022 15:58:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux ppc64le; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Vinod Koul <vkoul@kernel.org>, kishon@kernel.org,
        wens@csie.org, jernej.skrabec@gmail.com,
        wsa+renesas@sang-engineering.com, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20221227203512.1214527-1-sashal@kernel.org>
From:   Samuel Holland <samuel@sholland.org>
Subject: Re: [PATCH AUTOSEL 5.10 1/7] phy: sun4i-usb: Add support for the H616
 USB PHY
In-Reply-To: <20221227203512.1214527-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 12/27/22 14:35, Sasha Levin wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> [ Upstream commit 0f607406525d25019dd9c498bcc0b42734fc59d5 ]
> 
> The USB PHY used in the Allwinner H616 SoC inherits some traits from its
> various predecessors: it has four full PHYs like the H3, needs some
> extra bits to be set like the H6, and puts SIDDQ on a different bit like
> the A100. Plus it needs this weird PHY2 quirk.
> 
> Name all those properties in a new config struct and assign a new
> compatible name to it.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Samuel Holland <samuel@sholland.org>
> Link: https://lore.kernel.org/r/20221031111358.3387297-5-andre.przywara@arm.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/phy/allwinner/phy-sun4i-usb.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
> index 651d5e2a25ce..230987e55ece 100644
> --- a/drivers/phy/allwinner/phy-sun4i-usb.c
> +++ b/drivers/phy/allwinner/phy-sun4i-usb.c
> @@ -974,6 +974,17 @@ static const struct sun4i_usb_phy_cfg sun50i_h6_cfg = {
>  	.missing_phys = BIT(1) | BIT(2),
>  };
>  
> +static const struct sun4i_usb_phy_cfg sun50i_h616_cfg = {
> +	.num_phys = 4,
> +	.type = sun50i_h6_phy,
> +	.disc_thresh = 3,
> +	.phyctl_offset = REG_PHYCTL_A33,
> +	.dedicated_clocks = true,
> +	.phy0_dual_route = true,
> +	.hci_phy_ctl_clear = PHY_CTL_SIDDQ,
> +	.needs_phy2_siddq = true,

This will fail to compile without b45c6d80325b ("phy: sun4i-usb:
Introduce port2 SIDDQ quirk"). However, like Andre mentioned in
reference to the devicetree updates[1], we were not expecting any of
these patches to be backported. Since you already dropped the DT
portion, there is no need to bother with these two patches either.

Regards,
Samuel

[1]: https://lore.kernel.org/lkml/20221220000115.19c152fe@slackpad.lan/

> +};
> +
>  static const struct of_device_id sun4i_usb_phy_of_match[] = {
>  	{ .compatible = "allwinner,sun4i-a10-usb-phy", .data = &sun4i_a10_cfg },
>  	{ .compatible = "allwinner,sun5i-a13-usb-phy", .data = &sun5i_a13_cfg },
> @@ -988,6 +999,7 @@ static const struct of_device_id sun4i_usb_phy_of_match[] = {
>  	{ .compatible = "allwinner,sun50i-a64-usb-phy",
>  	  .data = &sun50i_a64_cfg},
>  	{ .compatible = "allwinner,sun50i-h6-usb-phy", .data = &sun50i_h6_cfg },
> +	{ .compatible = "allwinner,sun50i-h616-usb-phy", .data = &sun50i_h616_cfg },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, sun4i_usb_phy_of_match);

