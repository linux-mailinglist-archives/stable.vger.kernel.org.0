Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A654A4BCE
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 17:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380315AbiAaQWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 11:22:35 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39847 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380292AbiAaQWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 11:22:10 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1E10B60011;
        Mon, 31 Jan 2022 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643646129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckYBW4QVjvNg2b0zvA71CQv3fW8uXEkP/szPey4KL3A=;
        b=hRdZ7snvTe/l55NDaJ54a0V4Ja6TRYLwnanJZauX0mCxizulfEQNcbEVol/ry21RYjn09S
        e8nP4r1UnZ2xV25jmeq7CAoKneARg2g8kFd2jn5tpKq2jOnSrLwca2mJA9BwctV74ZFUfn
        W9v0veujl5gmHJ+evAHMhUDNgbreSyr1ZEl+Ss6pkuKHsB9yHFfCX6pvViMaAZhjao1cpP
        zP0Merlyh0DNj7RrlgrdgJL6jpokBBZOqSGsHPxnrlP4kpw4tCgykrC/35hTtqYnIfUznP
        BIrUSzHv6m14FKChk94y0yOpyHQhLZwTJZIKBZf+YUyNiOesZ8NQUD7h1licYg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        linux-mtd@lists.infradead.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Julien Su <juliensu@mxic.com.tw>,
        Jaime Liao <jaimeliao@mxic.com.tw>, stable@vger.kernel.org,
        Mason Yang <masonccyang@mxic.com.tw>,
        Zhengxun Li <zhengxunli@mxic.com.tw>
Subject: Re: [PATCH v10 09/13] spi: mxic: Fix the transmit path
Date:   Mon, 31 Jan 2022 17:22:06 +0100
Message-Id: <20220131162206.23850-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091808.1043392-10-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'c2f816543ff9a4dec31cfde31ff889cd09ea6c1f'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-01-27 at 09:18:04 UTC, Miquel Raynal wrote:
> By working with external hardware ECC engines, we figured out that
> Under certain circumstances, it is needed for the SPI controller to
> check INT_TX_EMPTY and INT_RX_NOT_EMPTY in both receive and transmit
> path (not only in the receive path). The delay penalty being
> negligible, move this code in the common path.
> 
> Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
> Cc: stable@vger.kernel.org
> Suggested-by: Mason Yang <masonccyang@mxic.com.tw>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Reviewed-by: Zhengxun Li <zhengxunli@mxic.com.tw>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Link: https://lore.kernel.org/linux-mtd/20220104083631.40776-10-miquel.raynal@bootlin.com

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git spi-mem-ecc.

Miquel
