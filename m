Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBECD377F03
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 11:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhEJJKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:10:41 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40659 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhEJJKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:10:40 -0400
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 06DC41BF220;
        Mon, 10 May 2021 09:09:34 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 2/7] mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper
Date:   Mon, 10 May 2021 11:09:34 +0200
Message-Id: <20210510090934.3713-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210413161840.345208-3-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'71cdf48dd349e3ed4f50194371ffc78e27fabd6f'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-04-13 at 16:18:35 UTC, Miquel Raynal wrote:
> Since the Hamming software ECC engine has been updated to become a
> proper and independent ECC engine, it is now mandatory to either
> initialize the engine before using any one of his functions or use one
> of the bare helpers which only perform the calculations. As there is no
> actual need for a proper ECC initialization, let's just use the bare
> helper instead of the rawnand one.
> 
> Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes.

Miquel
