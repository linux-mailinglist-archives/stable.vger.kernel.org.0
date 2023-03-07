Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156806AF5D1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjCGTgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbjCGTgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:36:22 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708025290F;
        Tue,  7 Mar 2023 11:23:28 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2B305240009;
        Tue,  7 Mar 2023 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678217007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3ZPM5aLplYh/kEODDg7vzDSr4zlPL9PxCOr+/6vGAo=;
        b=QQ2FI11L7CqHLN2au9ZPmyogKIh0kIYrWF7v0RS25Mtb224Acm+ZthS5D+no78nlLqOOLv
        R3MBGKa1Qb3cthAenTB6NE6D1hBCrvNBvuZYdMvuel/D/TO0xlCiuaoX8fb9mYfJEXSNgb
        yvlGRs0IC5P8OpjGJFhiI5Js7cyvnfCPaJscCHUX5dRP9KxyhUNGpjDU3jzaTrP80JJWzT
        1r7bMTCVtb5A2L+pC68kOS4aO85HoRxPUK7IlbPJDWM0D1pQwj3aKY5pFzvd76t/LNrzN5
        iYzayoHXp+raKSQ8LnYMbkzXCJQV6DDRZOI3+J9eItEdgB0d8OPhXkIPfgRlfg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mtd: core: provide unique name for nvmem device, take two
Date:   Tue,  7 Mar 2023 20:23:25 +0100
Message-Id: <20230307192325.353662-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306125805.678668-1-michael@walle.cc>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'7edfc9143c90f627aa9697d7a82d83e749a82237'
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

On Mon, 2023-03-06 at 12:58:02 UTC, Michael Walle wrote:
> Commit c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
> tries to give the nvmem device a unique name, but fails badly if the mtd
> device doesn't have a "struct device" associated with it, i.e. if
> CONFIG_MTD_PARTITIONED_MASTER is not set. This will result in the name
> "(null)-user-otp", which is not unique. It seems the best we can do is
> to use the compatible name together with a unique identifier added by
> the nvmem subsystem by using NVMEM_DEVID_AUTO.
> 
> Fixes: c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
