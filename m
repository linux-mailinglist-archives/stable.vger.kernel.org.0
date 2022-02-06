Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F324AAF22
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiBFMJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2434BC06173B;
        Sun,  6 Feb 2022 04:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D3E160F9D;
        Sun,  6 Feb 2022 12:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4294C340E9;
        Sun,  6 Feb 2022 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644149382;
        bh=1tjtCxGDwbqw9ixahReK/ueXFMVBs0fTu97Pu4ohV7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuRHhDjCZpF3o85hV2koVqYWJ3WfeA2jwsyjf+T2F7rpnL3zvZIcIPW8/na/K8dEa
         Eo4jvX02AGM8R05s+EbzYMKz6IkWRKrQ15YMihnO5XV/hpuDejQ6Vh7kklPQ7lXVJ6
         mwcGcv80l0E0poywsTAeUaHMgujcrGhFv8P02kVw=
Date:   Sun, 6 Feb 2022 13:09:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH 5.15 05/32] drm/vc4: hdmi: Make sure the device is
 powered with CEC
Message-ID: <Yf+6gxmQnlbngqwm@kroah.com>
References: <20220204091915.247906930@linuxfoundation.org>
 <20220204091915.421812582@linuxfoundation.org>
 <20220205171238.GA3073350@roeck-us.net>
 <Yf66Y2/N0nh9tMxT@kroah.com>
 <20220205184108.GA3084817@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205184108.GA3084817@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 10:41:08AM -0800, Guenter Roeck wrote:
> Hi Greg,
> 
> On Sat, Feb 05, 2022 at 06:56:51PM +0100, Greg Kroah-Hartman wrote:
> [ ... ]
> > 
> > Yeah, something is really wrong here.  I'm going to go revert this for
> > now and push out a new set of releases with that fixed.
> 
> If you pull a release for that, can you possibly revert 9de2b9286a6
> ("ASoC: mediatek: Check for error clk pointer") as well ? It does not
> realy fix anything but breaks pretty much all Mediatek systems using
> the mtk-scpsys driver. I sent a revert request
> 	https://lore.kernel.org/lkml/20220205014755.699603-1-linux@roeck-us.net/
> but the it looks like the submitter keeps defending their patch. In the
> current state, pretty much all stable release starting with v4.19.y won't
> work for affected systems due to this patch.

I don't see anyone objecting to the revert in that thread (or any
responses at all.)  I'll queue up a revert for the next round of
releases until this all gets worked out.

thanks,

greg k-h
