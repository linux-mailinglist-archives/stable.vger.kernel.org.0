Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C90814139D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 22:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAQVrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 16:47:42 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:60667 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQVrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 16:47:42 -0500
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id C9210C000A;
        Fri, 17 Jan 2020 21:47:38 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Esben Haabendal <esben@geanix.com>, linux-mtd@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mtd: rawnand: gpmi: Fix suspend/resume problem
Date:   Fri, 17 Jan 2020 22:47:38 +0100
Message-Id: <20200117214738.21546-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200117200537.9279-2-esben@geanix.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 5bc6bb603b4d0c8802af75e4932232683ab2d761
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-01-17 at 20:05:36 UTC, Esben Haabendal wrote:
> On system resume, the gpmi clock must be enabled before accessing gpmi
> block.  Without this, resume causes something like
> 
> [  661.348790] gpmi_reset_block(5cbb0f7e): module reset timeout
> [  661.348889] gpmi-nand 1806000.gpmi-nand: Error setting GPMI : -110
> [  661.348928] PM: dpm_run_callback(): platform_pm_resume+0x0/0x44 returns -110
> [  661.348961] PM: Device 1806000.gpmi-nand failed to resume: error -110
> 
> Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
> Cc: stable@vger.kernel.org
> Signed-off-by: Esben Haabendal <esben@geanix.com>
> Acked-by: Han Xu <han.xu@nxp.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
