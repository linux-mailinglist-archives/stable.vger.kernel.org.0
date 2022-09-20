Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B95BDF72
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiITINP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 04:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiITIMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 04:12:51 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B5A61D6C;
        Tue, 20 Sep 2022 01:10:58 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 518D34000A;
        Tue, 20 Sep 2022 08:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663661456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5qD6zAA466UgjuEnk9mGMzuomEV4pr6kH+NFdqWMZA=;
        b=Rk9GSBxs4RNRvtWALvLdb+rRqzYClM8TfhIuBnVxxeoxW8f1EpYVSeNP6sOhpTIzze4O1t
        hvOvNSJp8BmFUIpAwgjNOxXbKqfrKWeAmU46oXNP1Dbc2dN0P8gziskCHQXrN07JZXmVun
        4r3foNSpGPhFvJgODD7wcF7YkxHq5JDZ9YsNizuw84bZ/4QluLfUZjy9yc4DQkpUuwm3a1
        3GVS/2bCWKCR3fhDo2dDvUBlhCbO7zwDyuCTilattLeHKBX6JSJj0bWkHWtTLxa/jV6+rv
        3DzaZUC9miz+bKAjM4qn9FdMQ0Xf+NpIJ0a9Fe4YTiAJ4QqJjaYu6oqcchYCRw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        peda@axentia.se
Cc:     nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.beznea@microchip.com, bbrezillon@kernel.org,
        linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Date:   Tue, 20 Sep 2022 10:10:53 +0200
Message-Id: <20220920081053.597303-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728074014.145406-1-tudor.ambarus@microchip.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'52d0997b6bb062fed06d12d31c2c2851ffde8d45'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-07-28 at 07:40:14 UTC, Tudor Ambarus wrote:
> Every dma_map_single() call should have its dma_unmap_single() counterpart,
> because the DMA address space is a shared resource and one could render the
> machine unusable by consuming all DMA addresses.
> 
> Cc: stable@vger.kernel.org
> Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Acked-by: Alexander Dahl <ada@thorsis.com>
> Reported-by: Peter Rosin <peda@axentia.se>
> Tested-by: Alexander Dahl <ada@thorsis.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Tested-by: Peter Rosin <peda@axentia.se>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
