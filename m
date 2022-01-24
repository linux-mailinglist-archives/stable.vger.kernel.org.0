Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD45497C53
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiAXJoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbiAXJoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB02C061747
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 01:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD158B80EE0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1108FC340E9;
        Mon, 24 Jan 2022 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643017458;
        bh=MhvkCDsrCFu5KioAbgFiUb8cMoQfFQ5geEUB8EvPlNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkAlyc3177Ca6X5hGdUATK/koFHQ3epa9RBDFifQ4WwA26/Ks39YgMzpxUOSEu5n+
         aq/7xOugb0fqF29VI+0XpcUD3f3XoLp5YXg6sJ5l2g0Fa9VIeORVFH5WOo/dlNFOc0
         6IGI2VDj9ngyDetpZFx4aaNhVqF5ZiQRFDzAECAw=
Date:   Mon, 24 Jan 2022 10:44:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andre Kalb <andre.kalb@sma.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Let boot-on regulators be powered off
Message-ID: <Ye5077LSDQ9j8qmq@kroah.com>
References: <YetC7/ZaUwd68hGi@pc6682>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YetC7/ZaUwd68hGi@pc6682>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 22, 2022 at 12:34:07AM +0100, Andre Kalb wrote:
> [ Upstream commit 089b3f61ecfc43ca4ea26d595e1d31ead6de3f7b ]
> 
> Boot-on regulators are always kept on because their use_count value
> is now incremented at boot time and never cleaned.
> 
> Only increment count value for alway-on regulators.
> regulator_late_cleanup() is now able to power off boot-on regulators
> when unused.
> 
> Fixes: 45f9c1b2e57c ("regulator: core: Clean enabling always-on regulators + their supplies")
> Signed-off-by: Pascal Paillet <p.paillet@st.com>
> Link: https://lore.kernel.org/r/20191113102737.27831-1-p.paillet@st.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Acked-by: Andre Kalb <andre.kalb@sma.de>
> # 4.19.x
> ---
>  drivers/regulator/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
