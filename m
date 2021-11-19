Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2FE4576BF
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbhKSS4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:56:04 -0500
Received: from mslow1.mail.gandi.net ([217.70.178.240]:36709 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhKSS4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:56:03 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A8D92C526D;
        Fri, 19 Nov 2021 18:44:14 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id E4E21FF805;
        Fri, 19 Nov 2021 18:43:51 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/5] mtd: rawnand/ingenic: JZ4740 needs 'oob_first' read page function
Date:   Fri, 19 Nov 2021 19:43:51 +0100
Message-Id: <20211119184351.1404360-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211016132228.40254-5-paul@crapouillou.net>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'0171480007d64f663aae9226303f1b1e4621229e'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-10-16 at 13:22:28 UTC, Paul Cercueil wrote:
> The ECC engine on the JZ4740 SoC requires the ECC data to be read before
> the page; using the default page reading function does not work. Indeed,
> the old JZ4740 NAND driver (removed in 5.4) did use the 'OOB first' flag
> that existed back then.
> 
> Use the newly created nand_read_page_hwecc_oob_first() to address this
> issue.
> 
> This issue was not found when the new ingenic-nand driver was developed,
> most likely because the Device Tree used had the nand-ecc-mode set to
> "hw_oob_first", which seems to not be supported anymore.
> 
> Cc: <stable@vger.kernel.org> # v5.2
> Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
