Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B79377EFD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 11:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhEJJKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:10:15 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:41151 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhEJJKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:10:14 -0400
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 536A320001E;
        Mon, 10 May 2021 09:09:07 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mtd: rawnand: txx9ndfmc: Fix external use of SW Hamming ECC helper
Date:   Mon, 10 May 2021 11:09:07 +0200
Message-Id: <20210510090907.3392-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210413161840.345208-8-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'3f40801a2d1cc68324fe2c0ea147472b48b33866'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-04-13 at 16:18:40 UTC, Miquel Raynal wrote:
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
