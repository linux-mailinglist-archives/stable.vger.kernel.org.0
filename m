Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58331E01AB
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 21:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388009AbgEXTEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 15:04:41 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:53135 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388085AbgEXTEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 15:04:39 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id F3086240004;
        Sun, 24 May 2020 19:04:37 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 48/62] mtd: rawnand: sharpsl: Fix the probe error path
Date:   Sun, 24 May 2020 21:04:36 +0200
Message-Id: <20200524190436.9655-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519130035.1883-49-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 91fbdcef8c19f18d1616ab4f7ab3a79a0cde12d1
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-19 at 13:00:21 UTC, Miquel Raynal wrote:
> nand_release() is supposed be called after MTD device registration.
> Here, only nand_scan() happened, so use nand_cleanup() instead.
> 
> There is no Fixes tag applying here as the use of nand_release()
> in this driver predates by far the introduction of nand_cleanup() in
> commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> which makes this change possible. However, pointing this commit as the
> culprit for backporting purposes makes sense.
> 
> Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
