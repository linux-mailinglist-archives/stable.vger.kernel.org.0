Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71472538502
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiE3Pf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242712AbiE3PfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:35:23 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C9614916D;
        Mon, 30 May 2022 07:42:04 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 903513200645;
        Mon, 30 May 2022 10:42:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 30 May 2022 10:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1653921722; x=
        1654008122; bh=I5n0iZMhvRYtVlqNaE5gXodeWKpPzOtBBF09/N8SYdo=; b=u
        nCiFpukoiLLGljwmlJqGAHNyALbBXAsnzoSGPWQlTQ1fB+Glsl54gEspnxjnffNm
        76aH6MNrNn1KPUtIyVwdUlsWXByhi041izCSeA3m34cGnsYOTF+jaYOx8Pl+0YZt
        WkIOEkjK5IP+ui3p0arns2qGz0tKXyGjbdwDJ2PTu/i6KpQbsLJwpmcT+ln4oGKD
        PNMKdfOJq1py85vL8rUaMbsc1CoO5jlgdnZhdd1mLELn/iMaGctEwdmsMpH5yS0v
        acUh4v49x0WL4q/1H6GG1fqKVxH/AkpFowg3HlXKgp1tM9mK3CArwWUh8KIcM3yD
        MAiuipejo7nGrc4fX1Ssg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1653921722; x=
        1654008122; bh=I5n0iZMhvRYtVlqNaE5gXodeWKpPzOtBBF09/N8SYdo=; b=S
        h/4vnGUiQadEwLFHt+V4mM8ql7zAOxHwJZOyk0d4Wa1PtM/lYQYN3XbvF2ScpM4N
        0ko1X02PK9LbKwqAAugDY3Iwp0nR8iFn3NxJWN20VkfhJJGNLDjdTV/orSmysjeL
        ECodXYQwAKfAk/x8SFQsnhwEORtLDdJ8ZFIZWkcu1XceYMbk4ekqoTKKDhwAWbjt
        ZeGIeG+1stwpm3QPQeJT/gRN7153pbfZ1oSxIQhDw8DS1643CfiltPR5OjMWMEap
        b97iw5VF8zWOAIogcfT1nMJEfwOrLyOeyumC55aDj7HTYctHH8tsfBk0Q+KtDp1D
        Ro6/uPKdu1Yn0VeLV7xng==
X-ME-Sender: <xms:udeUYollbMzrIHtLnAUvc5LBky07XH1VNo-4-3xb0hciP04jf_reVg>
    <xme:udeUYn1toh2_-fbCxqgYD_nQGIOTfpDCWRyJQcxYgUMzoQ6cULMh7_lQ6keoNeFQC
    aqpbS5ku922f2PLUQ>
X-ME-Received: <xmr:udeUYmpEI9nXImBOVz1j26DT8Quxeb9y9Yz2bQYek4wEEL_i7DGvW64nUh9Mvzx3-WGCtZGk3Pylt7e7Bk7B5V2gEbhViuew9KR6HBbbAcjasQUt0KLG0Tg33A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrkeeigdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfevfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecugg
    ftrfgrthhtvghrnhepkeeiteejuedttdehgfelveevjedtkeehuedtteeiiefggffffefh
    ueegudekkeffnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehs
    hhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:udeUYknJFmbBs5-2XgJHL_PjLU_QvUeT9aowu62Em_GW_PrqT5WHmQ>
    <xmx:udeUYm0OGwq0Pc4vbfUJZKYiQXby3BptIr62O3UjADtDrBR8bolV2g>
    <xmx:udeUYruu3e9BvxDfjBO0QbWfjXUmwAyeLIbgJ_qa6z2U-qym0E7BOw>
    <xmx:uteUYvsVxsDDmQ5WyR-Mus3vOsM482qZhWDWeQNBHAqORY0cAz4EsA>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 May 2022 10:42:00 -0400 (EDT)
Subject: Re: [PATCH AUTOSEL 4.19 16/38] drm/sun4i: Add support for D1 TCONs
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>, mripard@kernel.org,
        wens@csie.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
References: <20220530134924.1936816-1-sashal@kernel.org>
 <20220530134924.1936816-16-sashal@kernel.org>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <0f81cfb5-de3c-02eb-8d6d-e5aa1b69c439@sholland.org>
Date:   Mon, 30 May 2022 09:41:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20220530134924.1936816-16-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 5/30/22 8:49 AM, Sasha Levin wrote:
> From: Samuel Holland <samuel@sholland.org>
> 
> [ Upstream commit b9b52d2f4aafa2bd637ace0f24615bdad8e49f01 ]
> 
> D1 has a TCON TOP, so its quirks are similar to those for the R40 TCONs.
> While there are some register changes, the part of the TCON TV supported
> by the driver matches the R40 quirks, so that quirks structure can be
> reused. D1 has the first supported TCON LCD with a TCON TOP, so the TCON
> LCD needs a new quirks structure.
> 
> D1's TCON LCD hardware supports LVDS; in fact it provides dual-link LVDS
> from a single TCON. However, it comes with a brand new LVDS PHY. Since
> this PHY has not been tested, leave out LVDS driver support for now.
> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220424162633.12369-14-samuel@sholland.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch adds support for hardware in a SoC that will not boot on earlier
kernel releases, so there is no benefit to backporting the patch (to any
previous release).

Regards,
Samuel

> ---
>  drivers/gpu/drm/sun4i/sun4i_tcon.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
> index 113c032a2720..0ebb7c1dfee6 100644
> --- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
> +++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
> @@ -1316,6 +1316,12 @@ static const struct sun4i_tcon_quirks sun9i_a80_tcon_tv_quirks = {
>  	.needs_edp_reset = true,
>  };
>  
> +static const struct sun4i_tcon_quirks sun20i_d1_lcd_quirks = {
> +	.has_channel_0		= true,
> +	.dclk_min_div		= 1,
> +	.set_mux		= sun8i_r40_tcon_tv_set_mux,
> +};
> +
>  /* sun4i_drv uses this list to check if a device node is a TCON */
>  const struct of_device_id sun4i_tcon_of_table[] = {
>  	{ .compatible = "allwinner,sun4i-a10-tcon", .data = &sun4i_a10_quirks },
> @@ -1329,6 +1335,8 @@ const struct of_device_id sun4i_tcon_of_table[] = {
>  	{ .compatible = "allwinner,sun8i-v3s-tcon", .data = &sun8i_v3s_quirks },
>  	{ .compatible = "allwinner,sun9i-a80-tcon-lcd", .data = &sun9i_a80_tcon_lcd_quirks },
>  	{ .compatible = "allwinner,sun9i-a80-tcon-tv", .data = &sun9i_a80_tcon_tv_quirks },
> +	{ .compatible = "allwinner,sun20i-d1-tcon-lcd", .data = &sun20i_d1_lcd_quirks },
> +	{ .compatible = "allwinner,sun20i-d1-tcon-tv", .data = &sun8i_r40_tv_quirks },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, sun4i_tcon_of_table);
> 

