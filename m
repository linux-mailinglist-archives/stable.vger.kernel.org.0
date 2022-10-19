Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE18604A5A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJSPEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJSPC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:02:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B5915ECE6;
        Wed, 19 Oct 2022 07:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 797FAB8224C;
        Wed, 19 Oct 2022 14:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2560C433C1;
        Wed, 19 Oct 2022 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666191393;
        bh=TM4wgjfRG/tpZ3xsCpLkHBSysgXbD+pBzv+iwSUm6kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hlsw1Gwy1q7/79w+6D6j6HBbTG13TcCDZAYvv6gU5AroS8Z+SjnpAMdNs1Yuxv2FW
         WNUr++fT7x1cg0yRThZSaWWywiq3ROpZ+xnyobtCxDH7za5iLD8l2JHJNCtkoETgga
         oUAUYNhU4hgpb7jTpu7k2dS3oH9KmofD/O26Aus8=
Date:   Wed, 19 Oct 2022 16:56:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Quentin Schulz <foss+kernel@0leil.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: rockchip: lower rk3399-puma-haikou SD
 controller clock frequency
Message-ID: <Y1AQHqm+cOmrrveJ@kroah.com>
References: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 04:27:27PM +0200, Quentin Schulz wrote:
> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> 
> From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>

You can not have 2 authors :(

> 
> CRC errors (code -84 EILSEQ) have been observed for some SanDisk
> Ultra A1 cards when running at 50MHz.
> 
> Waveform analysis suggest that the level shifters that are used on the
> RK3399-Q7 module for voltage translation between 3.0 and 3.3V don't
> handle clock rates at or above 48MHz properly. Back off to 40MHz for
> some safety margin.
> 
> Cc: stable@vger.kernel.org
> Fixes: 60fd9f72ce8a ("arm64: dts: rockchip: add Haikou baseboard with RK3399-Q7 SoM")
> Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
> Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> ---
> We've been carrying this patch downstream for years and completely forgot to
> upstream it. This is now done.

It has to be accepted before you are done :)

thanks,

greg k-h
