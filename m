Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEDD4F74FA
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 06:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiDGEu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 00:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiDGEu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 00:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B16DEA347;
        Wed,  6 Apr 2022 21:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA36B824DF;
        Thu,  7 Apr 2022 04:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704D0C385A0;
        Thu,  7 Apr 2022 04:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649306936;
        bh=CahaGK6EvpjmCGxGUQXvahVErAR/YeJjSXUrcYsvo5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wU8mvLy4anKEd49yeYvX8FAsdUUnmWc/P/MqKNVSPcHewWAFA+XvVBjAg0p2F4U+J
         VzkQCCdae/cN6f9e0csZtqqMKygibwp6wpTPCsfZuzZ2djcZEDeULPzmqE9yxO0D8M
         Ss5FapduXwvGXDC+IyBMDrPaC4Vhz+sB//iOl4BY=
Date:   Thu, 7 Apr 2022 06:48:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurent Vivier <laurent@vivier.eu>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-m68k@lists.linux-m68k.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-rtc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>, stable@vger.kernel.org
Subject: Re: [PATCH v16 1/4] tty: goldfish: introduce
 gf_ioread32()/gf_iowrite32()
Message-ID: <Yk5tNOPE4b2QbHLG@kroah.com>
References: <20220406201523.243733-1-laurent@vivier.eu>
 <20220406201523.243733-2-laurent@vivier.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406201523.243733-2-laurent@vivier.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 10:15:20PM +0200, Laurent Vivier wrote:
> Revert
> commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> 
> and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> defined by the architecture.
> 
> Cc: stable@vger.kernel.org # v5.11+
> Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/tty/goldfish.c   | 20 ++++++++++----------
>  include/linux/goldfish.h | 15 +++++++++++----
>  2 files changed, 21 insertions(+), 14 deletions(-)
> 

Why is this a commit for the stable trees?  What bug does it fix?  You
did not describe the problem in the changelog text at all, this looks
like a housekeeping change only.

thanks,

greg k-h
