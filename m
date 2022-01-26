Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A5849C7FF
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiAZKwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:52:14 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39009 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240245AbiAZKwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 05:52:14 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6D2086000E;
        Wed, 26 Jan 2022 10:52:09 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christian Eggers <ceggers@arri.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: don't leak PM reference in error path
Date:   Wed, 26 Jan 2022 11:52:08 +0100
Message-Id: <20220126105208.882283-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125081619.6286-1-ceggers@arri.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'9161f365c91614e5a3f5c6dcc44c3b1b33bc59c0'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-25 at 08:16:19 UTC, Christian Eggers wrote:
> If gpmi_nfc_apply_timings() fails, the PM runtime usage counter must be
> dropped.
> 
> Reported-by: Pavel Machek <pavel@denx.de>
> Fixes: f53d4c109a66 ("mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
