Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85D76000CB
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJPPnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiJPPnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320792FFD6;
        Sun, 16 Oct 2022 08:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0496B80CC3;
        Sun, 16 Oct 2022 15:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A4FC43470;
        Sun, 16 Oct 2022 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665934979;
        bh=8AMWIVg5VeOjwNuU1+nywGZDf3ly2NEg7OOLUhkkutc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FaL7D3Q59TVd+EgIBxytA/Vv6++aOb5JlgPFOKXTIkbq/7Vfx9PNeRp6laJwV5AHU
         r/oN/mlGX/QFEeTr5dk2y4VBcw1uNVIj1G6XsHAvIo9vk1gvwGpt38njhn2e5nsUCG
         PFo5KUcQnGV58TBBDXFHoU31nUVkuOL+AsI2zSNM=
Date:   Sun, 16 Oct 2022 17:43:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siarhei Volkau <lis8215@gmail.com>
Cc:     stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: Ingenic: JZ4755 bug fixes
Message-ID: <Y0wmsuJsMhKnAjGC@kroah.com>
References: <20221016153548.3024209-1-lis8215@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016153548.3024209-1-lis8215@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 06:35:48PM +0300, Siarhei Volkau wrote:
> Fixes UART1 function bits and MMC groups typo.
> 
> For pins 0x97,0x99 function 0 is designated to PWM3/PWM5
> respectively, function is 1 designated to the UART1.
> 
> Diff from v1:
>  - sent separately
>  - added tag Fixes
> 
> Fixes: b582b5a434d3 ("pinctrl: Ingenic: Add pinctrl driver for JZ4755.")
> Tested-by: Siarhei Volkau <lis8215@gmail.com>
> Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
> ---
>  drivers/pinctrl/pinctrl-ingenic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
