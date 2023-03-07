Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9AE6AF5CE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCGTgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbjCGTgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:36:19 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BA885A40;
        Tue,  7 Mar 2023 11:23:24 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AE11D60008;
        Tue,  7 Mar 2023 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678217002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2N/abUanCxXFPJMOTJSIDunk7kfGYgL5y7ARujmw8YM=;
        b=iQWBdhNbb6ZtrxYjR54xdhW8CAGAHCTCto2d3goGMIl9SU9Qnls7/rH1nwptMaO/FBe8nA
        Iw5iqsOX4PMuxFY6+9lNB0zzc8Wgvd9sAlo4REdkpJJRBFqDYAO1yQzio3TqeQVyYnxLCE
        jUo76/oEiwV0j6gR+uZaSX9WqvrERWXJ7L/84/KU9CzZXPoTUgJULy4fEGvjbBpcwfJkSn
        YQXbhlXBiI7i2yoHmRcp7FvuTa52oK+3mNpNmq5Ekh054A8/H/hgtWj6j/L5BTip1OXC4S
        2PI5Gwqs50hj/fMmhGe095VbOyQ74I5Xl8AQzsCx/wsOZl1ZFWZZgDnl54SELg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mtd: core: fix nvmem error reporting
Date:   Tue,  7 Mar 2023 20:23:20 +0100
Message-Id: <20230307192320.353633-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306125805.678668-2-michael@walle.cc>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'e02b3f832618bb0f7d8868b2e73aabe7f61d2a28'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-03-06 at 12:58:03 UTC, Michael Walle wrote:
> The master MTD will only have an associated device if
> CONFIG_MTD_PARTITIONED_MASTER is set, thus we cannot use dev_err() on
> mtd->dev. Instead use the parent device which is the physical flash
> memory.
> 
> Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
