Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958B11E01AE
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 21:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbgEXTFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 15:05:31 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:55873 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387744AbgEXTFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 15:05:31 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id CB696FF803;
        Sun, 24 May 2020 19:05:29 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 40/62] mtd: rawnand: pasemi: Fix the probe error path
Date:   Sun, 24 May 2020 21:05:28 +0200
Message-Id: <20200524190528.19169-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519130035.1883-41-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 2e2b8a44d151675a7d0aaaaf5524c694f144cf36
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-19 at 13:00:13 UTC, Miquel Raynal wrote:
> nand_cleanup() is supposed to be called on error after a successful
> call to nand_scan() to free all NAND resources.
> 
> There is no real Fixes tag applying here as the use of nand_release()
> in this driver predates by far the introduction of nand_cleanup() in
> commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> which makes this change possible, hence pointing it as the commit to
> fix for backporting purposes, even if this commit is not introducing
> any bug.
> 
> Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
