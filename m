Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5995734BD76
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhC1ROa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 13:14:30 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36913 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC1ROV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 13:14:21 -0400
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 0A878E0007;
        Sun, 28 Mar 2021 17:14:16 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 mtd/fixes] mtd: spinand: core: add missing MODULE_DEVICE_TABLE()
Date:   Sun, 28 Mar 2021 19:14:16 +0200
Message-Id: <20210328171416.7322-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210323173714.317884-1-alobakin@pm.me>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'25fefc88c71f47db0466570335e3f75f10952e7a'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-03-23 at 17:37:19 UTC, Alexander Lobakin wrote:
> The module misses MODULE_DEVICE_TABLE() for both SPI and OF ID tables
> and thus never autoloads on ID matches.
> Add the missing declarations.
> Present since day-0 of spinand framework introduction.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org # 4.19+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
