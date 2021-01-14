Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3572F6524
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 16:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbhANPsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 10:48:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54135 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbhANPsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 10:48:51 -0500
X-Originating-IP: 86.201.233.230
Received: from localhost.localdomain (lfbn-tou-1-151-230.w86-201.abo.wanadoo.fr [86.201.233.230])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id CE62160015;
        Thu, 14 Jan 2021 15:48:07 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: nandsim: Fix the logic when selecting Hamming soft ECC engine
Date:   Thu, 14 Jan 2021 16:48:06 +0100
Message-Id: <20210114154806.32093-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210104093057.31178-1-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 3c97be6982e689d7b2430187a11f8c78e573abdb
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-01-04 at 09:30:57 UTC, Miquel Raynal wrote:
> I have been fooled by the logic picking the right ECC engine which is
> spread across two functions: *init_module() and *_attach(). I thought
> this driver was not impacted by the recent changes around the ECC
> engines DT parsing logic but in fact it is.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: d7157ff49a5b ("mtd: rawnand: Use the ECC framework user input parsing bits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes.

Miquel
