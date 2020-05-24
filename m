Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6671E01CA
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387992AbgEXTKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 15:10:24 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:36013 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387747AbgEXTKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 15:10:23 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 74E9D240005;
        Sun, 24 May 2020 19:10:21 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH] mtd: rawnand: Fix nand_gpio_waitrdy()
Date:   Sun, 24 May 2020 21:10:20 +0200
Message-Id: <20200524191020.18380-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200518155237.297549-1-boris.brezillon@collabora.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: e45a4b652dbd2f8b5a3b8e97e89f602a58cb28aa
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-05-18 at 15:52:37 UTC, Boris Brezillon wrote:
> Mimic what's done in nand_soft_waitrdy() and add one to the jiffies
> timeout so we don't end up waiting less than actually required.
> 
> Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Fixes: b0e137ad24b6c ("mtd: rawnand: Provide helper for polling GPIO R/B pin")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
