Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9B524E90
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbiELNqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354583AbiELNqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:46:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6789D47AE9;
        Thu, 12 May 2022 06:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28702B82824;
        Thu, 12 May 2022 13:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019F6C385B8;
        Thu, 12 May 2022 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652363171;
        bh=vZ6/OZIkEWwSIxrSHgS+8wTTvNq6uLtF+yp8x0ESdYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H+/8uvWcJ+9/rKwYFkE4RsPxrm3PwYfEipReFn+jMCCEKK0Udm49dgJtfDXUMTDPa
         +2Pzbu6vB8GqdoHWp/Ypt6ybmRlny9sh8lNIj5abUms6HRlv05DsCKixpKvEFqAZUa
         nBkLQAzBN3ZUL7KEp1ynrEJJVOswj4EPABsDH8tE=
Date:   Thu, 12 May 2022 15:45:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andreas Larsson <andreas@gaisler.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH 5.4 1/2] can: grcan: grcan_probe(): fix broken system id
 check for errata workaround needs
Message-ID: <Yn0Pi0WtLcChqjZt@kroah.com>
References: <20220511093503.14117-1-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511093503.14117-1-andreas@gaisler.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 11, 2022 at 11:35:02AM +0200, Andreas Larsson wrote:
> backport of commit 1e93ed26acf03fe6c97c6d573a10178596aadd43 upstream.
> 
> The systemid property was checked for in the wrong place of the device
> tree and compared to the wrong value.
> 
> Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
> Link: https://lore.kernel.org/all/20220429084656.29788-3-andreas@gaisler.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/grcan.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)

All backports now queued up, thanks.

greg k-h
