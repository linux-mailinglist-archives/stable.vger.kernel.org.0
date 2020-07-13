Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D74021CF11
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 07:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgGMF4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 01:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgGMF4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 01:56:03 -0400
Received: from localhost (unknown [122.182.251.219])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217812073A;
        Mon, 13 Jul 2020 05:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594619762;
        bh=gXFwq43ohUgKZA8gAkhAymCG+JyohqjJf0fM3HTHIZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=paFGk7uJF66m93nyveVPcYNj/dGkVDvY1u8K9A/2rvKSlO0MBabNq/m+/4CmMR6Ff
         L3J6QduoGk6i58NoIF1rhO3v2QX4kAL49CKLIzXdfBbn9rvtWgf4FJh/EgiUXlZ+sg
         Df7mie1gP/c+V3+RqnTFL0MqOir01L2jDMVQjrns=
Date:   Mon, 13 Jul 2020 11:25:58 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Sivaprakash Murugesan <sivaprak@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, bhelgaas@google.com,
        robh+dt@kernel.org, kishon@ti.com, mturquette@baylibre.com,
        sboyd@kernel.org, svarbanov@mm-sol.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, mgautam@codeaurora.org,
        smuthayy@codeaurora.org, varada@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org,
        Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Subject: Re: [PATCH 5/9] phy: qcom-qmp: use correct values for ipq8074 gen2
 pcie phy init
Message-ID: <20200713055558.GB34333@vkoul-mobl>
References: <1593940680-2363-1-git-send-email-sivaprak@codeaurora.org>
 <1593940680-2363-6-git-send-email-sivaprak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593940680-2363-6-git-send-email-sivaprak@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05-07-20, 14:47, Sivaprakash Murugesan wrote:
> There were some problem in ipq8074 gen2 pcie phy init sequence, fix

Can you please describe these problems, it would help review to
understand the issues and also for future reference to you

> these to make gen2 pcie port on ipq8074 to work.
> 
> Fixes: eef243d04b2b6 ("phy: qcom-qmp: Add support for IPQ8074")
> 
> Cc: stable@vger.kernel.org
> Co-developed-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
> Signed-off-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
> Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp.c | 16 +++++++++-------
>  drivers/phy/qualcomm/phy-qcom-qmp.h |  2 ++
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> index e91040af3394..ba277136f52b 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> @@ -504,8 +504,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
>  	QMP_PHY_INIT_CFG(QSERDES_COM_BG_TRIM, 0xf),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_LOCK_CMP_EN, 0x1),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_MAP, 0x0),
> -	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER1, 0x1f),
> -	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER2, 0x3f),
> +	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER1, 0xff),
> +	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER2, 0x1f),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_CMN_CONFIG, 0x6),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_PLL_IVCO, 0xf),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_HSCLK_SEL, 0x0),
> @@ -531,7 +531,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
>  	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN1_MODE0, 0x0),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN0_MODE0, 0x80),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_BIAS_EN_CTRL_BY_PSM, 0x1),
> -	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_CTRL, 0xa),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_EN_CENTER, 0x1),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER1, 0x31),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER2, 0x1),
> @@ -540,7 +539,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
>  	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE1, 0x2f),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE2, 0x19),
>  	QMP_PHY_INIT_CFG(QSERDES_COM_CLK_EP_DIV, 0x19),
> -	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_CNTRL, 0x7),
>  };
>  
>  static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
> @@ -548,6 +546,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
>  	QMP_PHY_INIT_CFG(QSERDES_TX_LANE_MODE, 0x6),
>  	QMP_PHY_INIT_CFG(QSERDES_TX_RES_CODE_LANE_OFFSET, 0x2),
>  	QMP_PHY_INIT_CFG(QSERDES_TX_RCV_DETECT_LVL_2, 0x12),
> +	QMP_PHY_INIT_CFG(QSERDES_TX_EMP_POST1_LVL, 0x36),
> +	QMP_PHY_INIT_CFG(QSERDES_TX_SLEW_CNTL, 0x0a),
>  };
>  
>  static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
> @@ -558,7 +558,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
>  	QMP_PHY_INIT_CFG(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL4, 0xdb),
>  	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE, 0x4b),
>  	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN, 0x4),
> -	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN_HALF, 0x4),
>  };
>  
>  static const struct qmp_phy_init_tbl ipq8074_pcie_pcs_tbl[] = {
> @@ -1673,6 +1672,9 @@ static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
>  	.pwrdn_ctrl		= SW_PWRDN,
>  };
>  
> +static const char * const ipq8074_pciephy_clk_l[] = {
> +	"aux", "cfg_ahb",
> +};
>  /* list of resets */
>  static const char * const ipq8074_pciephy_reset_l[] = {
>  	"phy", "common",
> @@ -1690,8 +1692,8 @@ static const struct qmp_phy_cfg ipq8074_pciephy_cfg = {
>  	.rx_tbl_num		= ARRAY_SIZE(ipq8074_pcie_rx_tbl),
>  	.pcs_tbl		= ipq8074_pcie_pcs_tbl,
>  	.pcs_tbl_num		= ARRAY_SIZE(ipq8074_pcie_pcs_tbl),
> -	.clk_list		= NULL,
> -	.num_clks		= 0,
> +	.clk_list		= ipq8074_pciephy_clk_l,
> +	.num_clks		= ARRAY_SIZE(ipq8074_pciephy_clk_l),

I see patch is modifying some register values and then adding clks, in
the absence of proper patch description it is extremely hard to
understand what is going on..

>  	.reset_list		= ipq8074_pciephy_reset_l,
>  	.num_resets		= ARRAY_SIZE(ipq8074_pciephy_reset_l),
>  	.vreg_list		= NULL,
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.h b/drivers/phy/qualcomm/phy-qcom-qmp.h
> index 6d017a0c0c8d..832b3d098403 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp.h
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
> @@ -77,6 +77,8 @@
>  #define QSERDES_COM_CORECLK_DIV_MODE1			0x1bc
>  
>  /* Only for QMP V2 PHY - TX registers */
> +#define QSERDES_TX_EMP_POST1_LVL			0x018
> +#define QSERDES_TX_SLEW_CNTL				0x040
>  #define QSERDES_TX_RES_CODE_LANE_OFFSET			0x054
>  #define QSERDES_TX_DEBUG_BUS_SEL			0x064
>  #define QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_DRVR_EN	0x068
> -- 
> 2.7.4

-- 
~Vinod
