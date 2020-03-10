Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC17180669
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgCJSbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:31:39 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:50955 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgCJSbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:31:39 -0400
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C6FAD200004;
        Tue, 10 Mar 2020 18:31:36 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] mtd: spinand: Do not erase the block before writing a bad block marker
Date:   Tue, 10 Mar 2020 19:31:35 +0100
Message-Id: <20200310183135.18715-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218100432.32433-4-frieder.schrempf@kontron.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 5645f0332370783604813455c7157a5c73a770d3
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-02-18 at 10:05:35 UTC, Schrempf Frieder wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Currently when marking a block, we use spinand_erase_op() to erase
> the block before writing the marker to the OOB area. Doing so without
> waiting for the operation to finish can lead to the marking failing
> silently and no bad block marker being written to the flash.
> 
> In fact we don't need to do an erase at all before writing the BBM.
> The ECC is disabled for raw accesses to the OOB data and we don't
> need to work around any issues with chips reporting ECC errors as it
> is known to be the case for raw NAND.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
