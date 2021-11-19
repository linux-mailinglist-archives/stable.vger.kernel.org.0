Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43D4576BC
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhKSSzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:55:10 -0500
Received: from mslow1.mail.gandi.net ([217.70.178.240]:41557 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbhKSSzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:55:10 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A87A1C1B02
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 18:44:09 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 7EE91FF804;
        Fri, 19 Nov 2021 18:43:46 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christian Eggers <ceggers@arri.de>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Riedmueller <S.Riedmueller@phytec.de>,
        Han Xu <han.xu@nxp.com>, Greg Ungerer <gerg@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Christian Hemp <C.Hemp@phytec.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6
Date:   Fri, 19 Nov 2021 19:43:46 +0100
Message-Id: <20211119184346.1404296-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211102202022.15551-1-ceggers@arri.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'aa1baa0e6c1aa4872e481dce4fc7fd6f3dd8496b'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-11-02 at 20:20:21 UTC, Christian Eggers wrote:
> From: Stefan Riedmueller <s.riedmueller@phytec.de>
> 
> There is no need to explicitly set the default gpmi clock rate during
> boot for the i.MX 6 since this is done during nand_detect anyway.
> 
> Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
> Cc: stable@vger.kernel.org
> Acked-by: Han Xu <han.xu@nxp.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
