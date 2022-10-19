Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC7604058
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiJSJsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiJSJs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F249DCE8D;
        Wed, 19 Oct 2022 02:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 785A2617EF;
        Wed, 19 Oct 2022 09:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6583C433D6;
        Wed, 19 Oct 2022 09:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666171128;
        bh=vlyz9Xz2UDhp9eEW+u9A/wTMJBJFYUzkXdYKryBDaQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ccvxLeXGpc5K1Bg1xTCs6g2aWOP5TJ0rOp0tASc7qJmE3grLYwuzA9mFduRUaBgPX
         T+5qr4LvuAU7yruULlaPCPixSSmIqi4d3/Lg2PHHaDDsCWli0SvLKL+6n/z5bdm3ER
         YlLjEJGuxia1U/LtTqTiV0mUToFMT8kxZHzQ9SBC9Z0kviN55A32afFeh9ulz8T7uq
         DuIMobxhK8kE3gJX28yeFNPhDz+jF7X/AATtaO1wDxpYyZjsawrNvgIv7NBE1435AA
         XfDtdMyibgArWA/AQ7ciMOS/8Q/+NTNDInepLD4upJdr+taoQRyOT6Vlc4A7uvgzFJ
         PTqn/85MkF3Ig==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5Dg-000589-Q1; Wed, 19 Oct 2022 11:18:36 +0200
Date:   Wed, 19 Oct 2022 11:18:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 526/862] phy: qcom-qmp-combo: fix memleak on probe
 deferral
Message-ID: <Y0/A7GHKSDsBU5Ym@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.221255789@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083313.221255789@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:30:13AM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit 2de8a325b1084330ae500380cc27edc39f488c30 ]
> 
> Switch to using the device-managed of_iomap helper to avoid leaking
> memory on probe deferral and driver unbind.
> 
> Note that this helper checks for already reserved regions and may fail
> if there are multiple devices claiming the same memory.

Again, because of the above, this should not be backported. Please drop.

> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-5-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Johan
