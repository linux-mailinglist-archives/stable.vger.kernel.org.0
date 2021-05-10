Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926B377EFE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhEJJKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:10:20 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:37695 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhEJJKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:10:19 -0400
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 49E3720001D;
        Mon, 10 May 2021 09:09:14 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 6/7] mtd: rawnand: tmio: Fix external use of SW Hamming ECC helper
Date:   Mon, 10 May 2021 11:09:13 +0200
Message-Id: <20210510090913.3456-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210413161840.345208-7-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'9f97340b95aca810980b95f63b1d0ee2483a4173'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-04-13 at 16:18:39 UTC, Miquel Raynal wrote:
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
