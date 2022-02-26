Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBFD4C5473
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 08:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiBZHj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Feb 2022 02:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiBZHjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Feb 2022 02:39:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388CB5AA60
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 23:38:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6B8160EAD
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 07:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F835C340E9;
        Sat, 26 Feb 2022 07:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645861129;
        bh=p6TIsTJg7B9+x5GHTnzUE+dw+vXslvz3nuglM5HtcXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bfPMkdosP09LmyUWBj0nfiO7XyGKGIZ0gOsDxpIUHKhCFCeFcgkB4u0YiadxT1P9E
         Ptb/wEADmejKMvBiiKnFC74HtMg/AzvMQV7p/w98lcSJgOyQGNhWafT+7d/uPnldF6
         PvSbxUgbFAld6OMI7zH2pmLaapWGoDaZO1zkQe5M=
Date:   Sat, 26 Feb 2022 08:38:45 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Svenning =?iso-8859-1?Q?S=F8rensen?= <sss@secomea.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with
 more than two member" failed to apply to 5.16-stable tree
Message-ID: <YhnZBVVezubGkecl@kroah.com>
References: <164580577118139@kroah.com>
 <AM0PR08MB38593B3E0E9B6A861479A7F4B53E9@AM0PR08MB3859.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR08MB38593B3E0E9B6A861479A7F4B53E9@AM0PR08MB3859.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 05:14:13PM +0000, Svenning Sørensen wrote:
> gregkh@linuxfoundation wrote: 
> 
> >> The patch below does not apply to the 5.16-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commit
> >> id to <stable@vger.kernel.org>.
> ...
> >> ------------------ original commit in Linus's tree ------------------
> >>>From 3d00827a90db6f79abc7cdc553887f89a2e0a184 Mon Sep 17 00:00:00 2001
> 
> Hi Greg,
> 
> That's strange - it applies just fine without errors here:
> 
> --- snip ---
> $ git log --oneline -n 1
> f40e0f7a433b (HEAD -> linux-5.16.y, tag: v5.16.11, stable/linux-5.16.y) Linux 5.16.11
> $ git cherry-pick -x 3d00827a90db6f79abc7cdc553887f89a2e0a184
> [linux-5.16.y e1e17aca71a0] net: dsa: microchip: fix bridging with more than two member ports
>  Date: Fri Feb 18 11:27:01 2022 +0000
>  1 file changed, 23 insertions(+), 3 deletions(-)
> --- snip ---
> 
> So I'm not sure what's needed for backporting?

Try building it :)
