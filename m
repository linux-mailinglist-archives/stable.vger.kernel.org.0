Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A938575C49
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 09:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiGOH0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 03:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGOH0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 03:26:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF3479EE5
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 00:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB7B2B82AB2
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A96C34115;
        Fri, 15 Jul 2022 07:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657869963;
        bh=21LpKQfZKkgDVq8J3Rpv90LJOOVNdlYnrPCj2N4YjiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ruvqgOGMXNXGZcqOcKiv0JIrAMg5fCefaKhaerM3odafy0pQDz2kLIqKBdezgIzCP
         6fFHyHIJZmZ0GR+RtrRX1hljxcgWHLSeZgeWrtoYSh9OEJ7QY9Z5L9q5g3j5Vx+w7U
         lK5WwL7W9qIAyBzRewFjY2cXHAETM0wy1jzJl4IA=
Date:   Fri, 15 Jul 2022 09:26:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc:     horatiu.vultur@microchip.com, madhuri.sripada@microchip.com,
        stable@vger.kernel.org
Subject: Re: [Internal PATCH 6/8] spi: atmel-quadspi.c: Fix the buswidth
 adjustment between spi-mem and controller
Message-ID: <YtEWiAIQHwLzKrx4@kroah.com>
References: <20220715070940.540335-1-kavyasree.kotagiri@microchip.com>
 <20220715070940.540335-7-kavyasree.kotagiri@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715070940.540335-7-kavyasree.kotagiri@microchip.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 05:09:38AM -0200, Kavyasree Kotagiri wrote:
> From: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> Use the spi_mem_default_supports_op() core helper in order to take into
> account the buswidth specified by the user in device tree.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 0e6aae08e9ae ("spi: Add QuadSPI driver for Atmel SAMA5D2")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> (cherry picked from commit 41ddc39b3d13273648b9aa34075a085a31ce6031)

This is not a commit id in Linus's tree :(

> ---
>  drivers/spi/atmel-quadspi.c | 3 +++
>  1 file changed, 3 insertions(+)

What does "Internal PATCH" mean?

What stable branch(s) are you wanting this to be applied to?

thanks,

greg k-h
