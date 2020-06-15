Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2661F9268
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgFOJAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 05:00:02 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59877 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgFOJAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 05:00:02 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id E44591C0011;
        Mon, 15 Jun 2020 08:59:58 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sivaprakash Murugesan <sivaprak@codeaurora.org>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        peter.ujfalusi@ti.com, boris.brezillon@collabora.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V4 1/2] mtd: rawnand: qcom: avoid write to unavailable register
Date:   Mon, 15 Jun 2020 10:59:57 +0200
Message-Id: <20200615085957.22454-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1591948696-16015-2-git-send-email-sivaprak@codeaurora.org>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: d8b6e4b4414e4c72e0d7a9964ef79bd9cd5ae046
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-06-12 at 07:58:15 UTC, Sivaprakash Murugesan wrote:
> SFLASHC_BURST_CFG is only available on older ipq nand platforms, this
> register has been removed when the NAND controller is moved as part of qpic
> controller.
> 
> Avoid writing this register on devices which are based on qpic NAND
> controller.
> 
> Fixes: dce84760 (mtd: nand: qcom: Support for IPQ8074 QPIC NAND controller)
> Cc: stable@vger.kernel.org
> Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
