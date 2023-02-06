Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A090668BC7F
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 13:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjBFMK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 07:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjBFMKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 07:10:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E2E4EF8;
        Mon,  6 Feb 2023 04:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 422D260EBC;
        Mon,  6 Feb 2023 12:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6F3C433D2;
        Mon,  6 Feb 2023 12:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675685453;
        bh=MhW4f27C98PgGme9ON5ZgsCE3bB8QMRFivqHw0Wod5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sniiiH5oHDcUIqxuALv9KJlhS0cJPFwQ3ntn1pYZZX1DmxLjRBzKV9J/XoYkVMg3H
         RWYDqEfatDv/UBeXAlYQ/jWW6qMbzkAgDTb7Kkl485iVzI/nyCOzBT4FprdqARdivp
         ucotwMxXWEaY6aDAxjcOWvGFA8kRNH+YPNLi9JP+9z4ZWuqENBm2XjMaUnFo2+mikg
         5tZZ+6D6TRMbe3W/SEo2fKrZu3WBKdfnA8DehIiMdF1+IWU07URooHpo0BFtDWpnXo
         YyvS/AZ1IG1pV2gc4DBGU+q4jFP6LGBRbVUvMVMpgtkGcOrPjGv4kNQYquZrhR87oH
         M+Hmmq9MgwtTg==
Date:   Mon, 6 Feb 2023 17:40:49 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Georgi Djakov <djakov@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Artur =?utf-8?B?xZp3aWdvxYQ=?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 12/23] interconnect: qcom: sm8450: fix registration race
Message-ID: <Y+DuSd1NdWswskyx@matsya>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-13-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201101559.15529-13-johan+linaro@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-02-23, 11:15, Johan Hovold wrote:
> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to fail.
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.

Reviewed-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
