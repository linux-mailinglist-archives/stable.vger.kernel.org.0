Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C72A0CD8
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 18:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgJ3Rt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 13:49:59 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:40234 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgJ3Rt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 13:49:59 -0400
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 3A6A03A2C80
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 17:28:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7A47A200010;
        Fri, 30 Oct 2020 17:27:57 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org
Cc:     Julien Su <juliensu@mxic.com.tw>, ycllin@mxic.com.tw,
        stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 5/6] mtd: spinand: Fix OOB read
Date:   Fri, 30 Oct 2020 18:27:56 +0100
Message-Id: <20201030172756.29480-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001102014.20100-6-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 6260f3b349bb37a93404e681c8df75e104284696
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-10-01 at 10:20:13 UTC, Miquel Raynal wrote:
> So far OOB have never been used in SPI-NAND, add the missing memcpy to
> make it work properly.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
