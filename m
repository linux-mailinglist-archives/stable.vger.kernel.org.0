Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62682E9372
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbhADKgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:36:43 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45945 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbhADKgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 05:36:42 -0500
X-Originating-IP: 90.89.98.255
Received: from localhost.localdomain (lfbn-tou-1-1535-bdcst.w90-89.abo.wanadoo.fr [90.89.98.255])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 195A36003C;
        Mon,  4 Jan 2021 10:35:59 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sean Nyekjaer <sean@geanix.com>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     =?utf-8?q?Martin_Hundeb=C3=B8ll?= <martin@geanix.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: fix dst bit offset when extracting raw payload
Date:   Mon,  4 Jan 2021 11:35:58 +0100
Message-Id: <20210104103558.9035-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201221100013.2715675-1-sean@geanix.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: d1879af7ce7618e3580fbd89bf4f2fefe4175e6d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-12-21 at 10:00:13 UTC, Sean Nyekjaer wrote:
> Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
> when extracting the data payload in gpmi_ecc_read_page_raw().
> 
> Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
> Cc: stable@vger.kernel.org
> Reported-by: Martin Hundebøll <martin@geanix.com>
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
