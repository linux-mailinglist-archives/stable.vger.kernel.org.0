Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0445FB2B0
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 14:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiJKMyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 08:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJKMyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 08:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79CE6AA3E;
        Tue, 11 Oct 2022 05:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731056118B;
        Tue, 11 Oct 2022 12:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD79C433D6;
        Tue, 11 Oct 2022 12:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665492846;
        bh=nh65NVKv0f/DCts1WL21izVNMZRkVYtBQtPfD3HlRy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SLmbr4qtja7crhjbRR+UprzGTbAjLxtTWlZM+NmKJZt5pfW1FwGqtTe9b71cQJBby
         ygsrz3MmzE3UjfbdO/fOPTtZDHgVznjjSXxQXxjp0lNBoPVbqGAbkVQE3m94Xgp6wo
         iH9L0l/qWEVJOcuJlWGnk1MC+Q1/SuD26HCy1vJEKAB5ZcBm9VJ2aRVtC+PslGFoTP
         48oniDRVXdyeOhaGkqoE5+oyskCkNLfBkmDTek8tHqCiKgjckLkBWX5HSY8u2gfb2a
         ztSSpEINz19kcXycB2Ay76BTrz+CUXraoSBizfWsgDZxox88d1NwAxSqIeI6YGUpGt
         mAIZMzRUcurZA==
Date:   Tue, 11 Oct 2022 08:54:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Tony Lindgren <tony@atomide.com>, Stephen Boyd <sboyd@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: stable-rc/linux-5.10.y bisection: baseline.login on panda
Message-ID: <Y0VnbVAyHng7KHI4@sashalap>
References: <6341c30d.170a0220.2bfa7.6117@mx.google.com>
 <Y0QB/9dmTwd1tx11@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0QB/9dmTwd1tx11@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 12:29:03PM +0100, Mark Brown wrote:
>The KernelCI bisection bot bisected a boot failure on the 5.10-rc stable
>tree on Panda to d86c6447ee250 ("clk: ti: Stop using legacy clkctrl names
>for omap4") in the v5.10 stable tree.  There's a lot of clock related
>warnings/errors including:

I'll revert it, thanks!

-- 
Thanks,
Sasha
