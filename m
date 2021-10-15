Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D30B42EEEB
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 12:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238160AbhJOKfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 06:35:43 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55525 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbhJOKf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 06:35:27 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 473811C0005;
        Fri, 15 Oct 2021 10:33:19 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] mtd: rawnand: fsmc: Fix use of SM ORDER
Date:   Fri, 15 Oct 2021 12:33:18 +0200
Message-Id: <20211015103318.950418-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210928221507.199198-2-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'9be1446ece291a1f08164bd056bed3d698681f8b'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-09-28 at 22:15:00 UTC, Miquel Raynal wrote:
> The introduction of the generic ECC engine API lead to a number of
> changes in various drivers which broke some of them. Here is a typical
> example: I expected the SM_ORDER option to be handled by the Hamming ECC
> engine internals. Problem: the fsmc driver does not instantiate (yet) a
> real ECC engine object so we had to use a 'bare' ECC helper instead of
> the shiny rawnand functions. However, when not intializing this engine
> properly and using the bare helpers, we do not get the SM ORDER feature
> handled automatically. It looks like this was lost in the process so
> let's ensure we use the right SM ORDER now.
> 
> Fixes: ad9ffdce4539 ("mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
