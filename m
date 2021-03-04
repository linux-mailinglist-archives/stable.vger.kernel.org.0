Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F7A32D218
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 12:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbhCDL5h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 4 Mar 2021 06:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbhCDL5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 06:57:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D8EC06175F
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 03:56:52 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lHmaw-0002CJ-Ip; Thu, 04 Mar 2021 12:56:42 +0100
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lHmav-0005GO-NI; Thu, 04 Mar 2021 12:56:41 +0100
Message-ID: <04122d95be5489a9a2b7de1e36d3744538cc3c30.camel@pengutronix.de>
Subject: Re: [PATCH v4 01/13] phy: cadence: Sierra: Fix PHY power_on sequence
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Swapnil Jakhade <sjakhade@cadence.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Lokesh Vutla <lokeshvutla@ti.com>, stable@vger.kernel.org
Date:   Thu, 04 Mar 2021 12:56:41 +0100
In-Reply-To: <20210304044122.15166-2-kishon@ti.com>
References: <20210304044122.15166-1-kishon@ti.com>
         <20210304044122.15166-2-kishon@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-03-04 at 10:11 +0530, Kishon Vijay Abraham I wrote:
> Commit 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
> de-asserts PHY_RESET even before the configurations are loaded in
> phy_init(). However PHY_RESET should be de-asserted only after
> all the configurations has been initialized, instead of de-asserting
> in probe. Fix it here.
> 
> Fixes: 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: <stable@vger.kernel.org> # v5.4+

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
