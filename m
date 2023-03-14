Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737406B87A5
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 02:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCNBhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 21:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCNBhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 21:37:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273278F711;
        Mon, 13 Mar 2023 18:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCE90B81642;
        Tue, 14 Mar 2023 01:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1190C4339B;
        Tue, 14 Mar 2023 01:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678757869;
        bh=kaYAeX10da0Sz0xHoCN9cJauQS/JO4mb6Wf+gicdZJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVjVOSWMh+PBT16fPVp4RJ9G9DiYYg6DwbZou4wn3iEiA/sLMyB6pG8U49dmymdn2
         xUwVUp89GJWZNbdE8xNU+jKUQnn7pluUdw0VO83jAUK28TmqHehiq40UZmaBhaPaNX
         7rEysvNpiTaLaU6puYNjitJistu52DKFc8Dao7dVDi4YGlAVGRPDZVvZjdZOi6hUkU
         3RgOfMcpW1PPbxFMUWD+n3Ng2zUk0jgzXtQdn60wbZKKPjWKTuZ1AXS3oVGByDsCcz
         WwkntzK3shLzilMZKQ2yTMevr5JgGRHuFPHcKBdsKxX4ZPJpVw1BWRgltZWiSe81LM
         JT3hW28jlBORA==
Date:   Tue, 14 Mar 2023 09:37:41 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        - <patches@opensource.cirrus.com>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Randy Li <ayaka@soulik.info>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64: dts: imx8mm-nitrogen-r2: fix WM8960 clock name
Message-ID: <20230314013741.GB143566@dragon>
References: <20230217150627.779764-1-krzysztof.kozlowski@linaro.org>
 <20230217150627.779764-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217150627.779764-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 04:06:26PM +0100, Krzysztof Kozlowski wrote:
> The WM8960 Linux driver expects the clock to be named "mclk".  Otherwise
> the clock will be ignored and not prepared/enabled by the driver.
> 
> Fixes: 40ba2eda0a7b ("arm64: dts: imx8mm-nitrogen-r2: add audio")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Applied, thanks!
