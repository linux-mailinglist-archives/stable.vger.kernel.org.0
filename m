Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C642D0EC7
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 12:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgLGLQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 06:16:35 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:51957 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgLGLQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 06:16:35 -0500
Received: from localhost.localdomain (lfbn-tou-1-1617-103.w109-220.abo.wanadoo.fr [109.220.208.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 874FB200004;
        Mon,  7 Dec 2020 11:15:52 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>, miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org, vigneshr@ti.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: core: Fix refcounting for unpartitioned MTDs
Date:   Mon,  7 Dec 2020 12:15:51 +0100
Message-Id: <20201207111551.8949-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201206202220.27290-1-richard@nod.at>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: 8dcc7e856823be53ec07ea945a5356ffad34b278
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-12-06 at 20:22:20 UTC, Richard Weinberger wrote:
> Apply changes to usecount also the the master partition.
> Otherwise we have no refcounting at all if an MTD has no partitions.
> 
> Cc: stable@vger.kernel.org
> Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
> Signed-off-by: Richard Weinberger <richard@nod.at>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
