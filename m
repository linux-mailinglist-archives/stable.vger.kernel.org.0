Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77C653BD8
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 06:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiLVFuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 00:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiLVFuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 00:50:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5581903A;
        Wed, 21 Dec 2022 21:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0118B81C5E;
        Thu, 22 Dec 2022 05:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA59C433D2;
        Thu, 22 Dec 2022 05:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671688213;
        bh=5V9ED/JzaBt/cMkwYVq6/4E5hG05GxzX6B4YQYjwXzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tVeiZ3HALwW9t+ntmd5NVcNRnVkxw5qx+2tHRM36o6Z1QXqiQzz9cgKfEDqEJI74b
         hx3+eD5kpwOHjGNX3/aFWK0Q3dmLOYdQf/IdMhwSyA1IhWzHAu8W+T+miZzbz7g/VT
         MolxtRPzf/UjgaZNJ7XlewjspUQE9ByQsXywpXj4=
Date:   Thu, 22 Dec 2022 06:50:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH v2 2/2] usb: misc: onboard_hub: Fail silently when there
 is no platform device
Message-ID: <Y6PwE6ukJFW0Skry@kroah.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <20221222022605.v2.2.I0c5ce35d591fa1f405f213c444522585be5601f0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222022605.v2.2.I0c5ce35d591fa1f405f213c444522585be5601f0@changeid>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 02:26:45AM +0000, Matthias Kaehlcke wrote:
> Some boards with an onboard USB hub supported by the onboard_hub
> driver have a device tree node for the hub, but the node doesn't
> specify all properties needed by the driver (which is not a DT
> error per se). For such a hub no onboard_hub platform device is
> created. However the USB portion of the onboard hub driver still
> probes and uses _find_onboard_hub() to find the platform device
> that corresponds to the hub. If the DT node of the hub doesn't
> have an associated platform device the function looks for a
> "peer-hub" node (to get the platform device from there), if
> that doesn't exist either it logs an error and returns -EINVAL.
> 
> The absence of a platform device is expected in some
> configurations, so drop the error log and fail silently with
> -ENODEV.
> 
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
> Changes in v2:
> - patch added to the series
> 
>  drivers/usb/misc/onboard_usb_hub.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
