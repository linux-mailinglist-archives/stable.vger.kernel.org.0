Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AE16C1378
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCTNd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjCTNdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECC922029;
        Mon, 20 Mar 2023 06:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BB1AB80E8A;
        Mon, 20 Mar 2023 13:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53FBC433D2;
        Mon, 20 Mar 2023 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679319193;
        bh=PHgxmKVBuw8bEVTejodtImXPSO6GlN9rWZrf4VYdvsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0oCFxGlOJ5wWKNTguHbv+Y7pTYDNjDH7+uIZ5dRezPXYzoY2R52wuQTtrfUvdCJL
         pAZftfWBkjbdUlH8KUhQMsyKrYg/pYkGR42vWWbQsK5TVbodraSJjx87RUnogqta3e
         +lsk9+04rM1zhDijeomUSRCxfA3Bjhv5F7E/sHNo=
Date:   Mon, 20 Mar 2023 14:33:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_em: Fix UART port type
Message-ID: <ZBhglhuXBlSPVRVx@kroah.com>
References: <20230320122225.414976-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320122225.414976-1-biju.das.jz@bp.renesas.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 12:22:25PM +0000, Biju Das wrote:
> commit 32e293be736b853f168cd065d9cbc1b0c69f545d upstream.
> 
> As per HW manual for  EMEV2 "R19UH0040EJ0400 Rev.4.00", the UART
> IP found on EMMA mobile SoC is Register-compatible with the
> general-purpose 16750 UART chip. Fix UART port type as 16750 and
> enable 64-bytes fifo support.
> 
> Fixes: 22886ee96895 ("serial8250-em: Emma Mobile UART driver V2")
> Cc: stable@vger.kernel.org # 4.19.y
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Link: https://lore.kernel.org/r/20230227114152.22265-2-biju.das.jz@bp.renesas.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [biju: manually fixed the conflicts]
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> Resending to 4.19 with confilcts [1] fixed.
> [1] https://lore.kernel.org/stable/1679303539169236@kroah.com/

Both now queued up, thanks.

greg k-h
