Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EE56DC84A
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDJPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDJPSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:18:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A73D1FEF;
        Mon, 10 Apr 2023 08:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 078DA60ED3;
        Mon, 10 Apr 2023 15:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8869FC433EF;
        Mon, 10 Apr 2023 15:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681139896;
        bh=4oKWMUZZqk5mhvrj1wuIzkoAcWiExU4ic+wHY5xzIrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JhAhl6Lhn6Z8gLAY51eGZv5HfN7kWs7gAGyHVVVRnWFdVRwSusxaWTEiLLDU1l78n
         osHTW+NkItR3buqlaqeYHbMkFCcXnju95KGd+MrdNrAIbI6o1XzK1XhyBeEkRamzsw
         /T8NKNbWUbOM3RqDMCLQlkdVDzBBCi7dcf+A0pmp0mLq7QszAWDA7shlDfKAnxmOUZ
         L+3xpLF04hQkycR27jwOes+VjNwzbHaPm7tghD5AyKWLMI8R5pm39aEpVOCTV4aKTn
         UjZNiRPaaUcT3xfb7WY41X7kGli1dtnIcB+1hfpTAM1I+xx15Oqzw/9U4P6r50cH3N
         FiNgdcDbanbUw==
Date:   Mon, 10 Apr 2023 20:48:11 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/2] phy: qcom-qmp-pcie: sc8180x PCIe PHY has 2
 lanes
Message-ID: <ZDQos70LsnoKVic4@matsya>
References: <20230331151250.4049-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331151250.4049-1-dmitry.baryshkov@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-03-23, 18:12, Dmitry Baryshkov wrote:
> All PCIe PHYs on sc8180x platform have 2 lanes, so change the number of
> lanes to 2.

Applied both, thanks

-- 
~Vinod
