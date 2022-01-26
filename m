Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B049C80B
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbiAZKwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:52:53 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:33915 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbiAZKww (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 05:52:52 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EC803FF80C;
        Wed, 26 Jan 2022 10:52:47 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        linux-mtd@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org
Cc:     Julien Su <juliensu@mxic.com.tw>,
        Jaime Liao <jaimeliao@mxic.com.tw>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
        stable@vger.kernel.org, Mason Yang <masonccyang@mxic.com.tw>,
        Zhengxun Li <zhengxunli@mxic.com.tw>
Subject: Re: [PATCH v9 09/13] spi: mxic: Fix the transmit path
Date:   Wed, 26 Jan 2022 11:52:47 +0100
Message-Id: <20220126105247.882740-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220104083631.40776-10-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'397d9ce0bdd47e2bf51ada69fe0933951f6d176e'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-04 at 08:36:27 UTC, Miquel Raynal wrote:
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

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git spi-mem-ecc.

Miquel
