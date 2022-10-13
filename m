Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890AB5FD43F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 07:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJMF3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 01:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJMF3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 01:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F2C326CC;
        Wed, 12 Oct 2022 22:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F176166E;
        Thu, 13 Oct 2022 05:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A04C433D6;
        Thu, 13 Oct 2022 05:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665638947;
        bh=u1aE7Guz757GpnzspBVuVfnvD43VfUWIebYhD99jq48=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=c2V70Kmoy/YkP9WxvptKHSrsS9DV22ct28HFRE5FnT9AdLPN/Pb1qZWgom48/rYDw
         uvNuM1c4I5hP04XlVHzAArZPeKhw9LtyR+n3GvlSuv6bGFOCXOeEcOD68asy9331XR
         lF3eZhMGH2LCJ+T4AfaQmtUmU9x9hev5PqIG2kXPWzN8WpzWur79+TbgOgMAxyZjoK
         MrwYShI5wXoKCf2t9LUVsWCM5DtLQcMMG3o0bHV35LEFzJsBIiLkBINAEbVl6h/ZQP
         bDpd0frHdLbRnoDVmoOlKDZrnodiC6ZBnKTgaaiYG6k2oAQ45fNQKHD8I9C9e1xtc5
         hH4WBRln9NybQ==
Date:   Thu, 13 Oct 2022 06:29:03 +0100
From:   Conor Dooley <conor@kernel.org>
To:     linux-riscv@lists.infradead.org, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     Conor Dooley <conor.dooley@microchip.com>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-clk@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_AUTOSEL_6=2E0_20/67=5D_clk=3A_microc?= =?US-ASCII?Q?hip=3A_mpfs=3A_add_MSS_pll=27s_set_=26_round_rate?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20221013001554.1892206-20-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org> <20221013001554.1892206-20-sashal@kernel.org>
Message-ID: <93982EAD-5EE5-4096-9AD6-BFA76905F1BB@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not a fix, NAK=2E Same for 5=2E19=2E

On 13 October 2022 01:15:01 IST, Sasha Levin <sashal@kernel=2Eorg> wrote:
>From: Conor Dooley <conor=2Edooley@microchip=2Ecom>
>
>[ Upstream commit 14016e4aafc5f157c10fb1a386fa3b3bd9c30e9a ]
>
>The MSS pll is not a fixed frequency clock, so add set() & round_rate()
>support=2E
>Control is limited to a 7 bit output divider as other devices on the
>FPGA occupy the other three outputs of the PLL & prevent changing
>the multiplier=2E
>
>Reviewed-by: Daire McNamara <daire=2Emcnamara@microchip=2Ecom>
>Signed-off-by: Conor Dooley <conor=2Edooley@microchip=2Ecom>
>Reviewed-by: Claudiu Beznea <claudiu=2Ebeznea@microchip=2Ecom>
>Signed-off-by: Claudiu Beznea <claudiu=2Ebeznea@microchip=2Ecom>
>Link: https://lore=2Ekernel=2Eorg/r/20220909123123=2E2699583-9-conor=2Edo=
oley@microchip=2Ecom
>Signed-off-by: Sasha Levin <sashal@kernel=2Eorg>
>---
> drivers/clk/microchip/clk-mpfs=2Ec | 54 ++++++++++++++++++++++++++++++++
> 1 file changed, 54 insertions(+)
>
>diff --git a/drivers/clk/microchip/clk-mpfs=2Ec b/drivers/clk/microchip/c=
lk-mpfs=2Ec
>index b6b89413e090=2E=2Ecb4ec4749279 100644
>--- a/drivers/clk/microchip/clk-mpfs=2Ec
>+++ b/drivers/clk/microchip/clk-mpfs=2Ec
>@@ -126,8 +126,62 @@ static unsigned long mpfs_clk_msspll_recalc_rate(str=
uct clk_hw *hw, unsigned lon
> 	return prate * mult / (ref_div * MSSPLL_FIXED_DIV * postdiv);
> }
>=20
>+static long mpfs_clk_msspll_round_rate(struct clk_hw *hw, unsigned long =
rate, unsigned long *prate)
>+{
>+	struct mpfs_msspll_hw_clock *msspll_hw =3D to_mpfs_msspll_clk(hw);
>+	void __iomem *mult_addr =3D msspll_hw->base + msspll_hw->reg_offset;
>+	void __iomem *ref_div_addr =3D msspll_hw->base + REG_MSSPLL_REF_CR;
>+	u32 mult, ref_div;
>+	unsigned long rate_before_ctrl;
>+
>+	mult =3D readl_relaxed(mult_addr) >> MSSPLL_FBDIV_SHIFT;
>+	mult &=3D clk_div_mask(MSSPLL_FBDIV_WIDTH);
>+	ref_div =3D readl_relaxed(ref_div_addr) >> MSSPLL_REFDIV_SHIFT;
>+	ref_div &=3D clk_div_mask(MSSPLL_REFDIV_WIDTH);
>+
>+	rate_before_ctrl =3D rate * (ref_div * MSSPLL_FIXED_DIV) / mult;
>+
>+	return divider_round_rate(hw, rate_before_ctrl, prate, NULL, MSSPLL_POS=
TDIV_WIDTH,
>+				  msspll_hw->flags);
>+}
>+
>+static int mpfs_clk_msspll_set_rate(struct clk_hw *hw, unsigned long rat=
e, unsigned long prate)
>+{
>+	struct mpfs_msspll_hw_clock *msspll_hw =3D to_mpfs_msspll_clk(hw);
>+	void __iomem *mult_addr =3D msspll_hw->base + msspll_hw->reg_offset;
>+	void __iomem *ref_div_addr =3D msspll_hw->base + REG_MSSPLL_REF_CR;
>+	void __iomem *postdiv_addr =3D msspll_hw->base + REG_MSSPLL_POSTDIV_CR;
>+	u32 mult, ref_div, postdiv;
>+	int divider_setting;
>+	unsigned long rate_before_ctrl, flags;
>+
>+	mult =3D readl_relaxed(mult_addr) >> MSSPLL_FBDIV_SHIFT;
>+	mult &=3D clk_div_mask(MSSPLL_FBDIV_WIDTH);
>+	ref_div =3D readl_relaxed(ref_div_addr) >> MSSPLL_REFDIV_SHIFT;
>+	ref_div &=3D clk_div_mask(MSSPLL_REFDIV_WIDTH);
>+
>+	rate_before_ctrl =3D rate * (ref_div * MSSPLL_FIXED_DIV) / mult;
>+	divider_setting =3D divider_get_val(rate_before_ctrl, prate, NULL, MSSP=
LL_POSTDIV_WIDTH,
>+					  msspll_hw->flags);
>+
>+	if (divider_setting < 0)
>+		return divider_setting;
>+
>+	spin_lock_irqsave(&mpfs_clk_lock, flags);
>+
>+	postdiv =3D readl_relaxed(postdiv_addr);
>+	postdiv &=3D ~(clk_div_mask(MSSPLL_POSTDIV_WIDTH) << MSSPLL_POSTDIV_SHI=
FT);
>+	writel_relaxed(postdiv, postdiv_addr);
>+
>+	spin_unlock_irqrestore(&mpfs_clk_lock, flags);
>+
>+	return 0;
>+}
>+
> static const struct clk_ops mpfs_clk_msspll_ops =3D {
> 	=2Erecalc_rate =3D mpfs_clk_msspll_recalc_rate,
>+	=2Eround_rate =3D mpfs_clk_msspll_round_rate,
>+	=2Eset_rate =3D mpfs_clk_msspll_set_rate,
> };
>=20
> #define CLK_PLL(_id, _name, _parent, _shift, _width, _flags, _offset) {	=
		\
