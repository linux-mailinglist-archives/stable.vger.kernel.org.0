Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608A8563816
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiGAQi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 12:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGAQi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 12:38:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B6B19036;
        Fri,  1 Jul 2022 09:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99922B830A4;
        Fri,  1 Jul 2022 16:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9678C3411E;
        Fri,  1 Jul 2022 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656693504;
        bh=/qdh/Lo2cMOZZEcNP2UucxtYfU1Sb4pBZ6Z3NUXWdqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uxzmEqWNvDa9Y6yRZts7Xz7tcAfNhpA9ft/t5uzNUjj4s2EmaJROEQEhJKrO1ccfI
         3W60bNFMuDqS+XOylpB8jDPZBLWTGs74wJLoQKuZymXtyg87LgZtKl3QyQm8V7G80I
         eWHdi+/PH5VjwWX7CqfaZ6S7n8IqVB02N7j1znwRF1y5OXW3dfjkqSDxd6wqluUd4n
         v/SM3lXK07qh0rvh26qGt0yVhO0fU8C3+sHcQW+dLUAKZP9+bBDKgMLhTHuCOaSWgo
         X3anBM8lqH1+0E0B/P2W5B8XMHG7QXxJAN0IQqOzAPk6VRcvgUEznXmIpVTmuu6U4X
         Nd+4IFwe6HQuQ==
Date:   Fri, 1 Jul 2022 22:08:20 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     dmaengine@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: imx-sdma: only restart cyclic channel when
 enabled
Message-ID: <Yr8i/ILoouWWZHtj@matsya>
References: <20220617115042.4004062-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617115042.4004062-1-s.hauer@pengutronix.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17-06-22, 13:50, Sascha Hauer wrote:
> An interrupt for a channel might be pending even after struct
> dma_device::device_terminate_all has been called. In that case the
> recently introduced warning message "restart cyclic channel..." triggers
> and the channel will be restarted. This is not desired as the channel
> has just been stopped. Only restart the channel when we still have a
> descriptor set for it (which will be set to NULL in
> sdma_terminate_all()).

Applied, thanks

-- 
~Vinod
