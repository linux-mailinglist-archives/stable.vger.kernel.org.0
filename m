Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB53EF06B
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 18:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhHQQuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 12:50:10 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:61115 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhHQQuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 12:50:09 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id ED0D7240002;
        Tue, 17 Aug 2021 16:49:32 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Evgeny Novikov <novikov@ispras.ru>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ramuthevar Vadivel Murugan 
        <vadivel.muruganx.ramuthevar@linux.intel.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Anton Vasilyev <vasilyev@ispras.ru>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mtd: rawnand: intel: Fix error handling in probe
Date:   Tue, 17 Aug 2021 18:49:32 +0200
Message-Id: <20210817164932.109519-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210817092930.23040-1-novikov@ispras.ru>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'0792ec82175ec45a0f45af6e0f2d3cb49c527cd4'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-08-17 at 09:29:30 UTC, Evgeny Novikov wrote:
> ebu_nand_probe() did not invoke ebu_dma_cleanup() and
> clk_disable_unprepare() on some error handling paths. The patch fixes
> that.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Fixes: 0b1039f016e8 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
> Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
> Co-developed-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
> Signed-off-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
> Co-developed-by: Anton Vasilyev <vasilyev@ispras.ru>
> Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
