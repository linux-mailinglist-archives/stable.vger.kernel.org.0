Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA924CE50B
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiCENqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:46:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32023B3EA
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D4261299
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FC1C004E1;
        Sat,  5 Mar 2022 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646487959;
        bh=PAQzJUgmBm518mKctyGRDgj1hH8F8AbzdXJt9cDfh/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9we0dUiYKkdhF9rL7Kvnb+VpAqxrqVIZvnbtfm2yNDNsiYffhR5jQ7Id4jLUlBN7
         fdFN6iTr0mMfg6+qjLgeCHTzPpPZLcmPdXaexrHS+WnnQ/H+5Im1zs7PGQH5oKC2el
         fVZDlRLkyy//SJ8+03YlEMuQAnqfgvViu7VLNrlU=
Date:   Sat, 5 Mar 2022 14:45:49 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Svenning =?iso-8859-1?Q?S=F8rensen?= <sss@secomea.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Resend: "[PATCH] net: dsa: microchip: fix bridging with more
 than two member" for 5.16-stable tree
Message-ID: <YiNpjT9zP+8IzZQ6@kroah.com>
References: <DB7PR08MB3867B6632107AB7449591CDEB5039@DB7PR08MB3867.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB7PR08MB3867B6632107AB7449591CDEB5039@DB7PR08MB3867.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 10:40:20AM +0000, Svenning Sørensen wrote:
> Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> plugged a packet leak between ports that were members of different bridges.
> Unfortunately, this broke another use case, namely that of more than two
> ports that are members of the same bridge.
> 
> After that commit, when a port is added to a bridge, hardware bridging
> between other member ports of that bridge will be cleared, preventing
> packet exchange between them.
> 
> Fix by ensuring that the Port VLAN Membership bitmap includes any existing
> ports in the bridge, not just the port being added.
> 
> Upstream commit 3d00827a90db6f79abc7cdc553887f89a2e0a184, backported to 5.16.
> 
> Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> Signed-off-by: Svenning Sørensen <sss@secomea.com>
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
