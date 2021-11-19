Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9387F457678
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhKSSie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:38:34 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41045 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbhKSSie (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:38:34 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id D3EA71C0003;
        Fri, 19 Nov 2021 18:35:29 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Andreas Oetken <ennoerlangen@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andreas Oetken <andreas.oetken@siemens-energy.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] drivers: mtd: Fixed breaking list in __mtd_del_partition.
Date:   Fri, 19 Nov 2021 19:35:29 +0100
Message-Id: <20211119183529.1330052-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211102172604.2921065-1-andreas.oetken@siemens-energy.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'cd6727626290d4abd37d92dfee24be36eb57ba82'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-11-02 at 17:26:04 UTC, Andreas Oetken wrote:
> Not the child partition should be removed from the partition list
> but the partition itself. Otherwise the partition list gets broken
> and any subsequent remove operations leads to a kernel panic.
> 
> Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
