Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630F42A0C6D
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgJ3R1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 13:27:43 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55615 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgJ3R1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 13:27:42 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8AB1360004;
        Fri, 30 Oct 2020 17:27:39 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Praveenkumar I <ipkumar@codeaurora.org>, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, sivaprak@codeaurora.org,
        peter.ujfalusi@ti.com, boris.brezillon@collabora.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kathirav@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read
Date:   Fri, 30 Oct 2020 18:27:38 +0100
Message-Id: <20201030172738.29290-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1602230872-25616-1-git-send-email-ipkumar@codeaurora.org>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: e6ad7a4080245f2e3ff674786f0c8371804718c3
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-10-09 at 08:07:52 UTC, Praveenkumar I wrote:
> After each codeword NAND_FLASH_STATUS is read for possible operational
> failures. But there is no DMA sync for CPU operation before reading it
> and this leads to incorrect or older copy of DMA buffer in reg_read_buf.
> 
> This patch adds the DMA sync on reg_read_buf for CPU before reading it.
> 
> Fixes: 5bc36b2bf6e2 ("mtd: rawnand: qcom: check for operation errors in case of raw read")
> Signed-off-by: Praveenkumar I <ipkumar@codeaurora.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
