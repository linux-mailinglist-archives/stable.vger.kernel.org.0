Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C0A1E01BD
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 21:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbgEXTIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 15:08:11 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45915 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387744AbgEXTIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 15:08:11 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id EB39920006;
        Sun, 24 May 2020 19:08:09 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 12/62] mtd: rawnand: diskonchip: Fix the probe error path
Date:   Sun, 24 May 2020 21:08:08 +0200
Message-Id: <20200524190809.3669-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519130035.1883-13-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 745944a1d8a2bd53876f9464d2c9cd4e12f86312
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-19 at 12:59:45 UTC, Miquel Raynal wrote:
> Not sure nand_cleanup() is the right function to call here but in any
> case it is not nand_release(). Indeed, even a comment says that
> calling nand_release() is a bit of a hack as there is no MTD device to
> unregister. So switch to nand_cleanup() for now and drop this
> comment.
> 
> There is no Fixes tag applying here as the use of nand_release()
> in this driver predates by far the introduction of nand_cleanup() in
> commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> which makes this change possible. However, pointing this commit as the
> culprit for backporting purposes makes sense even if it did not intruce
> any bug.
> 
> Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
