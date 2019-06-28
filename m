Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BDC5A42E
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfF1ShS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:37:18 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:59869 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfF1ShS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:37:18 -0400
X-Originating-IP: 81.185.164.234
Received: from localhost.localdomain (234.164.185.81.rev.sfr.net [81.185.164.234])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 27CB420006;
        Fri, 28 Jun 2019 18:37:06 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Frieder Schrempf <frieder.schrempf@exceet.de>,
        Peter Pan <peterpandong@micron.com>,
        Jeff Kletsky <git-commits@allycomm.com>,
        Schrempf Frieder <frieder.schrempf@kontron.De>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mtd: spinand: read return badly if the last page has bitflips
Date:   Fri, 28 Jun 2019 20:36:56 +0200
Message-Id: <20190628183656.18875-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <1561695286-19265-1-git-send-email-liaoweixiong@allwinnertech.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b83408b580eccf8d2797cd6cb9ae42c2a28656a7
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-06-28 at 04:14:46 UTC, liaoweixiong wrote:
> In case of the last page containing bitflips (ret > 0),
> spinand_mtd_read() will return that number of bitflips for the last
> page. But to me it looks like it should instead return max_bitflips like
> it does when the last page read returns with 0.
> 
> Signed-off-by: Weixiong Liao <liaoweixiong@allwinnertech.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Cc: stable@vger.kernel.org
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
