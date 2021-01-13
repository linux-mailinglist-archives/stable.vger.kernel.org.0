Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EED2F4CA5
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 15:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbhAMOAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 09:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbhAMOAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 09:00:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E402339D;
        Wed, 13 Jan 2021 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610546365;
        bh=CTYl4sS6a0mRlAEUPoEll2y1cYD+IgIiBe33/Vyl5Ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dyu9mEbYkqVUGH/WaJUSTYK6+wbiZcu2Q0nN3u8M9IU8im1zoqU8c00BUlL6wAozL
         UAwB8A3YLRlgU8NFrJ24NVVkxQZVi/A6g8rTjHDz+RpRQkN+kjQMdsPHnoZNlhUiyD
         BsCSYEekp6bGU0gmowTPLOmlXFUegkYGewOjvRpIEFScpvOpYw9Y/imZB7Skm6p45u
         TUlZyG176ZTRNGi5rPaa0+C22ov6o8nAPBG4W2jarS5bdFN1NPT2DmGx3gL9Dhxe40
         nbqEPATSreZ9uNTq5U+t/xUv61IDPnBmMr7QBHdjXKlf7Wgs8rpX5yfXdY6Fj0WJOX
         Z9zTDhka8Z3KA==
Date:   Wed, 13 Jan 2021 19:29:19 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Mathias Kresin <dev@kresin.me>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, stable@vger.kernel.org
Subject: Re: [PATCH] phy: lantiq: rcu-usb2: wait after clock enable
Message-ID: <20210113135919.GO2771@vkoul-mobl>
References: <20210107224901.2102479-1-dev@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107224901.2102479-1-dev@kresin.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07-01-21, 23:49, Mathias Kresin wrote:
> Commit 65dc2e725286 ("usb: dwc2: Update Core Reset programming flow.")
> revealed that the phy isn't ready immediately after enabling it's
> clocks. The dwc2_check_core_version() fails and the dwc2 usb driver
> errors out.
> 
> Add a short delay to let the phy get up and running. There isn't any
> documentation how much time is required, the value was chosen based on
> tests.

Applied, thanks

-- 
~Vinod
