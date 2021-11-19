Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B074576A1
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhKSSrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:47:15 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57111 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbhKSSrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:47:15 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 7BD491C0002;
        Fri, 19 Nov 2021 18:44:10 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mtd: rawnand/davinci: Don't calculate ECC when reading page
Date:   Fri, 19 Nov 2021 19:44:09 +0100
Message-Id: <20211119184410.1404619-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211016132228.40254-1-paul@crapouillou.net>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'71e89591502d737c10db2bd4d8fcfaa352552afb'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-10-16 at 13:22:24 UTC, Paul Cercueil wrote:
> The function nand_davinci_read_page_hwecc_oob_first() does read the ECC
> data from the OOB area. Therefore it does not need to calculate the ECC
> as it is already available.
> 
> Cc: <stable@vger.kernel.org> # v5.2
> Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
