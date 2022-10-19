Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD77360401E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiJSJmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiJSJkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C26F0194;
        Wed, 19 Oct 2022 02:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4143D61820;
        Wed, 19 Oct 2022 09:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CC5C43470;
        Wed, 19 Oct 2022 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666170943;
        bh=wGhGFvPXeu6TKdOmijz1r6FBNDIhbNxh8icrTgpThXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W7ph51a0d+0vFwfqJJvHvkut2rN0so1Z3epRqGBuGmgAR07AGHKW+IGaL+BOjQC4e
         eVnutcd2JqAzKEoTryDyNOUjc1G7dtvmxWW2ofm1YI44c7nxIajewB6lF5DZg16kVE
         wagACZmBfwPaD/HijBYHBmbFCaQ/thu2ipdh2L+wIJvsX4VhfbJjIUbDObvWG1jEN7
         Bi4nKi/aMvfNlZdjU0vR59vlrqKBc8Az1HuAUWnq6FO275YU7sFo00YOSZu0sfTss9
         zv5YjwLJDHFbdVq7irA/jovXPe+AMAsWBRCf8n1TDfJ+yvZrB3GHdTTyA6OaqIAZCn
         FF42Z3fulCAhQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5Ah-000551-GH; Wed, 19 Oct 2022 11:15:31 +0200
Date:   Wed, 19 Oct 2022 11:15:31 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 523/862] phy: qcom-qmp-pcie: add pcs_misc sanity check
Message-ID: <Y0/AM9F1CmAykhGI@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.087411998@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083313.087411998@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:30:10AM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit ecd5507e72ea03659dc2cc3e4393fbf8f4e2e02a ]
> 
> Make sure that the (otherwise) optional pcs_misc IO region has been
> provided in case the configuration specifies a corresponding
> initialisation table to avoid crashing with malformed device trees.
> 
> Note that the related debug message is now superfluous as the region is
> only used when the configuration has a pcs_misc table.
> 
> Fixes: 421c9a0e9731 ("phy: qcom: qmp: Add SDM845 PCIe QMP PHY support")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-2-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This was added to prevent future bugs when adding support for new
platforms and did not have a stable tag. Please drop.

> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
> index 2d65e1f56bfc..0e0f2482827a 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
> @@ -2371,8 +2371,10 @@ int qcom_qmp_phy_pcie_create(struct device *dev, struct device_node *np, int id,
>  	    of_device_is_compatible(dev->of_node, "qcom,ipq6018-qmp-pcie-phy"))
>  		qphy->pcs_misc = qphy->pcs + 0x400;
>  
> -	if (!qphy->pcs_misc)
> -		dev_vdbg(dev, "PHY pcs_misc-reg not used\n");
> +	if (!qphy->pcs_misc) {
> +		if (cfg->pcs_misc_tbl || cfg->pcs_misc_tbl_sec)
> +			return -EINVAL;
> +	}
>  
>  	snprintf(prop_name, sizeof(prop_name), "pipe%d", id);
>  	qphy->pipe_clk = devm_get_clk_from_child(dev, np, prop_name);

Johan
