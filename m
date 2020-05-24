Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D40F1E01A5
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 21:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbgEXTEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 15:04:02 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34091 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388025AbgEXTEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 15:04:02 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 2187EC0003;
        Sun, 24 May 2020 19:04:01 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 56/62] mtd: rawnand: tmio: Fix the probe error path
Date:   Sun, 24 May 2020 21:04:00 +0200
Message-Id: <20200524190400.5199-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519130035.1883-57-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 073c506ed568e9b1bfe89c9b318d9c46ed0e9d6f
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-19 at 13:00:29 UTC, Miquel Raynal wrote:
> nand_release() is supposed be called after MTD device registration.
> Here, only nand_scan() happened, so use nand_cleanup() instead.
> 
> There is no real Fixes tag applying here as the use of nand_release()
> in this driver predates by far the introduction of nand_cleanup() in
> commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> which makes this change possible. However, pointing this commit as the
> culprit for backporting purposes makes sense even if this commit is not
> introducing any bug.
> 
> Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
