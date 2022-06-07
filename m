Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B5B53FA90
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbiFGJ5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiFGJ4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806F2EABA8;
        Tue,  7 Jun 2022 02:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15A96131B;
        Tue,  7 Jun 2022 09:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2CBC34115;
        Tue,  7 Jun 2022 09:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654595791;
        bh=6spgyTbpIii4gmYFhWPeNPPcXX7gAjBVMayOdvFKAN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gp7ykAPcCpfdf7Z8jBK5QW+wQQmC4l7nqKVgRzepadB/UkhwdPcwwgWINrCoRRVgD
         T8qUzZQzQJFdtRxGOmEIhsU1MkDenbVEGnMS1GXxzVJ+KJyZrema/ZrXBgpM7feP/s
         A+X+ZJbWE8WFS1GHtopU4qa/OMnCTT4Hynk8pWyA=
Date:   Tue, 7 Jun 2022 11:56:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Alex Elder <elder@linaro.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: Re: [PATCH 5.15 0/2] Fix suspend on qcom sc7180 SoCs
Message-ID: <Yp8gycx3v2S6drG4@kroah.com>
References: <20220606235155.2437168-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606235155.2437168-1-swboyd@chromium.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 04:51:53PM -0700, Stephen Boyd wrote:
> These two patches fix suspend on sc7180 boards, i.e. Trogdor, on 5.15
> stable kernels. Without these two patches the IP0 interconnect is kept
> on forever, and suspend fails because XO shutdown can't be achieved.
> 
> Mike Tipton (1):
>   interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
> 
> Stephen Boyd (1):
>   interconnect: qcom: sc7180: Drop IP0 interconnects
> 
>  drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
>  drivers/interconnect/qcom/sc7180.c   | 21 ---------------------
>  drivers/interconnect/qcom/sm8150.c   |  1 -
>  drivers/interconnect/qcom/sm8250.c   |  1 -
>  drivers/interconnect/qcom/sm8350.c   |  1 -
>  5 files changed, 5 insertions(+), 29 deletions(-)
> 
> -- 
> https://chromeos.dev
>

Both now queued up, thanks.

greg k-h
