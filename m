Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0C74B7260
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiBOQVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 11:21:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiBOQVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 11:21:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF66BDE73;
        Tue, 15 Feb 2022 08:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D8F6617BF;
        Tue, 15 Feb 2022 16:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE0DC340EB;
        Tue, 15 Feb 2022 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644942080;
        bh=6MeCX5n6vxfuO90hTY0X9RyPSUCRNFFayrn7BSsgECc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rGAbU5fDzsl8gpOvFM6erp2AkW2Y9MnkhmB0sc2JnsMBTCGQk9eYrV/Xxd19W3X+6
         DSqwn65xytNhSufu+kfnhpX5FSq2kNa8XsbrEA7/tnrLYIO+JyWeIlEn9oUxSXijow
         SuxN9LT4nSf5MBTHQrIveIMHMGh47VdwQ/9v0YuI=
Date:   Tue, 15 Feb 2022 17:21:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tommaso Merciai <tomm.merciai@gmail.com>,
        Richard Leitner <richard.leitner@linux.dev>,
        richard.leitner@skidata.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 06/34] usb: usb251xb: add boost-up property
 support
Message-ID: <YgvS/f/iq00UCsUI@kroah.com>
References: <20220215152657.580200-1-sashal@kernel.org>
 <20220215152657.580200-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215152657.580200-6-sashal@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 10:26:29AM -0500, Sasha Levin wrote:
> From: Tommaso Merciai <tomm.merciai@gmail.com>
> 
> [ Upstream commit 5c2b9c61ae5d8ad0a196d33b66ce44543be22281 ]
> 
> Add support for boost-up register of usb251xb hub.
> boost-up property control USB electrical drive strength
> This register can be set:
> 
>  - Normal mode -> 0x00
>  - Low         -> 0x01
>  - Medium      -> 0x10
>  - High        -> 0x11
> 
> (Normal Default)
> 
> References:
>  - http://www.mouser.com/catalog/specsheets/2514.pdf p29
> 
> Reviewed-by: Richard Leitner <richard.leitner@linux.dev>
> Signed-off-by: Tommaso Merciai <tomm.merciai@gmail.com>
> Link: https://lore.kernel.org/r/20220128181713.96856-1-tomm.merciai@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/misc/usb251xb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

This isn't needed in any stable tree, please drop it from all AUTOSEL
branches.

thanks,

greg k-h
