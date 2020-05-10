Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA4A1CCD70
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 22:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgEJUF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 16:05:28 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:50965 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgEJUF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 16:05:28 -0400
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 360AF240006;
        Sun, 10 May 2020 20:05:26 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 3/9] mtd: rawnand: onfi: Fix redundancy detection check
Date:   Sun, 10 May 2020 22:05:25 +0200
Message-Id: <20200510200525.1892-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428094302.14624-4-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: d4cbe5a9903bb5844a140e72631950dccb47db89
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-04-28 at 09:42:56 UTC, Miquel Raynal wrote:
> During ONFI detection, the CRC derived from the parameter page and the
> CRC supposed to be at the end of the parameter page are compared. If
> they do not match, the second then the third copies of the page are
> tried.
> 
> The current implementation compares the newly derived CRC with the CRC
> contained in the first page only. So if this particular CRC area has
> been corrupted, then the detection will fail for a wrong reason.
> 
> Fix this issue by checking the derived CRC against the right one.
> 
> Fixes: 39138c1f4a31 ("mtd: rawnand: use bit-wise majority to recover the ONFI param page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
