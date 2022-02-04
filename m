Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F474A9517
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355872AbiBDI3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:29:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58576 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbiBDI3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:29:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06DBB83551;
        Fri,  4 Feb 2022 08:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16867C004E1;
        Fri,  4 Feb 2022 08:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963370;
        bh=hV0XVIpJv8RfsccFVgtd6nr6963RmT/8SgaEKOgrUGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CkacnUzIMgDRFphD+YHfn9mQpier5IfJsqoe/Ygn0PfYfp0gBV6K82RfCBDhpo6Yf
         jFMWFZUT0aez4ocdBJ8E1XmVV5KqFjpylE3tFFbmBR9NWg5qIny6U61rAl1sqHtTzR
         eJuabVpShJszWnFnRlPjlTWmMQJuv4chuWqlEs8k=
Date:   Fri, 4 Feb 2022 09:29:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        rafael@kernel.org, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 36/52] PM: wakeup: simplify the output logic
 of pm_show_wakelocks()
Message-ID: <Yfzj56RiMMd79M26@kroah.com>
References: <20220203202947.2304-1-sashal@kernel.org>
 <20220203202947.2304-36-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203202947.2304-36-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 03, 2022 at 03:29:30PM -0500, Sasha Levin wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [ Upstream commit c9d967b2ce40d71e968eb839f36c936b8a9cf1ea ]
> 
> The buffer handling in pm_show_wakelocks() is tricky, and hopefully
> correct.  Ensure it really is correct by using sysfs_emit_at() which
> handles all of the tricky string handling logic in a PAGE_SIZE buffer
> for us automatically as this is a sysfs file being read from.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/power/wakelock.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)

This is already in a stable release, so no need to add it again.

thanks,

greg k-h
