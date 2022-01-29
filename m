Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615174A3072
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 17:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiA2QM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 11:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiA2QM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 11:12:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22AC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64BE6B827C5
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 16:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAC0C340E5;
        Sat, 29 Jan 2022 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643472744;
        bh=Bs8Ze+45YHgy4vg/Znk8sA0Sj5GQXeKQO4269k5V3Lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wXDEb7oX1lGme2ksqbMTjBpPqp5SGB/ULyVCZgWr8PkPsQxOV9Fr5aJyUbUqi2Sot
         ewcmKuETGNFQWfNG6beUBRc+Y0G8egTSpup0uwtUKyxIodNnmUGOWjDuqhkYa68Duj
         K15pF/jcADYN2qKvGD/gJvg41DO1OtS/5ZsMsBTQ=
Date:   Sat, 29 Jan 2022 17:12:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     stable@vger.kernel.org, kabel@kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4] net: sfp: ignore disabled SFP node
Message-ID: <YfVnZVWeew+nC9EH@kroah.com>
References: <164345764948199@kroah.com>
 <20220129160947.11445-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220129160947.11445-1-marek.behun@nic.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 05:09:47PM +0100, Marek Behún wrote:
> From: Marek Behún <kabel@kernel.org>
> 
> commit 2148927e6ed43a1667baf7c2ae3e0e05a44b51a0 upstream.
> 
> Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
> and sfp cages") added code which finds SFP bus DT node even if the node
> is disabled with status = "disabled". Because of this, when phylink is
> created, it ends with non-null .sfp_bus member, even though the SFP
> module is not probed (because the node is disabled).
> 
> We need to ignore disabled SFP bus node.
> 
> Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: stable@vger.kernel.org # 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [ backport to 5.4 ]
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/phy/phylink.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 

All now queued up, thanks.

greg k-h
