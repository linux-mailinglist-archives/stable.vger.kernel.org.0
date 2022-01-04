Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24D6483CF7
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 08:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiADHdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 02:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiADHdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 02:33:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E9CC061761;
        Mon,  3 Jan 2022 23:33:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82856612C3;
        Tue,  4 Jan 2022 07:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB38C36AE9;
        Tue,  4 Jan 2022 07:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641281621;
        bh=+UAlUDdALq3FTAHTc3ld5ewqx0HoAHpUI+1dT9wN3xE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y5R3IRLwt35TZgDJVERX3IKnTkJC/dqxFOA6oF6amOfWNDcIifKW23poyLyz+CaQR
         drHztf01bSxS69iaqN/vWtaqnjxyj9kr6TjOomWMlMsrRuxHXDIYt0ZkAZiB7dzAbX
         89ekOz7+Wh/JA9I3FgUM32PJZ/Oz3qRLbMQHpAKg=
Date:   Tue, 4 Jan 2022 08:33:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 28/73] net: phy: fixed_phy: Fix NULL vs IS_ERR()
 checking in __fixed_phy_register
Message-ID: <YdP4UpzF99+bOAoF@kroah.com>
References: <20220103142056.911344037@linuxfoundation.org>
 <20220103142057.816768294@linuxfoundation.org>
 <61f06784-722e-cbf3-aab3-009d300e236f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f06784-722e-cbf3-aab3-009d300e236f@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 11:47:34AM -0800, Florian Fainelli wrote:
> 
> 
> On 1/3/2022 6:23 AM, Greg Kroah-Hartman wrote:
> > From: Miaoqian Lin <linmq006@gmail.com>
> > 
> > [ Upstream commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ]
> > 
> > The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
> > pointers, using NULL checking to fix this.i
> > 
> > Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
> > Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> > Link: https://lore.kernel.org/r/20211224021500.10362-1-linmq006@gmail.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Same as 5.4 and 5.10, this patch causes a regression on 5.15 as well and
> should be dropped. Since this is also affecting Linus' master a revert of
> that changes has been submitted to the net/master tree and should reach
> Linus' tree shortly assuming it gets applied:
> 
> https://lore.kernel.org/lkml/20220103193453.1214961-1-f.fainelli@gmail.com/

Thanks, I have dropped this from all 3 stable queues now.

greg k-h
