Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1735234BD79
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhC1RPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 13:15:02 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59073 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhC1ROc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 13:14:32 -0400
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id E3950E0009;
        Sun, 28 Mar 2021 17:14:29 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com
Cc:     nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, bbrezillon@kernel.org,
        linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Kai Stuhlemmer (ebee Engineering)" <kai.stuhlemmer@ebee.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: atmel: Update ecc_stats.corrected counter
Date:   Sun, 28 Mar 2021 19:14:29 +0200
Message-Id: <20210328171429.7450-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210322150714.101585-1-tudor.ambarus@microchip.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'33cebf701e98dd12b01d39d1c644387b27c1a627'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-03-22 at 15:07:14 UTC, Tudor Ambarus wrote:
> From: "Kai Stuhlemmer (ebee Engineering)" <kai.stuhlemmer@ebee.de>
> 
> Update MTD ECC statistics with the number of corrected bits.
> 
> Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
