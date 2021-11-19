Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806804576C7
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhKSS43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:56:29 -0500
Received: from mslow1.mail.gandi.net ([217.70.178.240]:58517 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhKSS42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:56:28 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 7353FC79EC;
        Fri, 19 Nov 2021 18:44:19 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 97BE4FF80C;
        Fri, 19 Nov 2021 18:43:56 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mtd: rawnand: Export nand_read_page_hwecc_oob_first()
Date:   Fri, 19 Nov 2021 19:43:56 +0100
Message-Id: <20211119184356.1404424-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211016132228.40254-4-paul@crapouillou.net>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'd8466f73010faf71effb21228ae1cbf577dab130'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-10-16 at 13:22:27 UTC, Paul Cercueil wrote:
> Move the function nand_read_page_hwecc_oob_first() (previously
> nand_davinci_read_page_hwecc_oob_first()) to nand_base.c, and export it
> as a GPL symbol, so that it can be used by more modules.
> 
> Cc: <stable@vger.kernel.org> # v5.2
> Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
