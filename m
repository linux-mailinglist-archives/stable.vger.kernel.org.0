Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527FA6D2153
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 15:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCaNQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 09:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjCaNQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 09:16:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECB81A46E;
        Fri, 31 Mar 2023 06:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DE9062709;
        Fri, 31 Mar 2023 13:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF3AC433EF;
        Fri, 31 Mar 2023 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680268609;
        bh=2MPdnUHGU0aIs3VfxSa6Dd5lcSVZ7IsUdIpMm+VnV4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZJDDcYnep4pq7w27lu75r8wKD/9Ku5cpain6oQhP58hf2yok49Gumqo2E0Da9GJjh
         jfuGYk34KrKbJZ249S9JYgSxpMqyqo/d1wBI7teQRH8kAG9Iree2Ncuft9VwcF3xwS
         qCelkEOSavL7K9bRZ8n81Etf1tAlVesSxk/Vkd+Q=
Date:   Fri, 31 Mar 2023 15:16:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
Message-ID: <ZCbdP11nqQinOQNe@kroah.com>
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
 <20230331121054.112758-3-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331121054.112758-3-s.hauer@pengutronix.de>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 02:10:54PM +0200, Sascha Hauer wrote:
> On my RTW8821CU chipset rfe_option reads as 0x22. Looking at the
> downstream driver suggests that the field width of rfe_option is 5 bit,
> so rfe_option should be masked with 0x1f.
> 
> Without this the rfe_option comparisons with 2 further down the
> driver evaluate as false when they should really evaluate as true.
> The effect is that 2G channels do not work.
> 
> rfe_option is also used as an array index into rtw8821c_rfe_defs[].
> rtw8821c_rfe_defs[34] (0x22) was added as part of adding USB support,
> likely because rfe_option reads as 0x22. As this now becomes 0x2,
> rtw8821c_rfe_defs[34] is no longer used and can be removed.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
