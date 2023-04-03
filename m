Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF78F6D4CF3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjDCQAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjDCP7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:59:47 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A9DC4;
        Mon,  3 Apr 2023 08:59:34 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6CAD2FF808;
        Mon,  3 Apr 2023 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680537573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxzAESz2itDatQ0g4Gg/O8O4nZ6xBxSu0J0zCMfdfVI=;
        b=UEulIjSPWvrG4xKO+EsYpQG7wm/RETkk/NF4U9FqG5BeatPS1smcKB4ReIS4Cr80SuJsQz
        jQsNlPtcEnHgZKp/eQjpEdJdX6R/1x3Gq93kD9xPuGoUelcom2n9nsh3R6dvfrb3YJULNA
        L39IunvtJK2lKoqJe48mv6X1k7Orwh/WOlHi8LwNMjwBHIcfiLifNOoznjWsmQD62r8wV0
        XYOidDqFnvIZtubqH0TjsGAkCaFkXSssElf2WHGdm+R5pyWouLJyCppYi/4tGF4GZcxMUR
        mlkqIFQCMdecXXOxbW1ecIDMjubAIChU3DfbsbJrZbb2fZImxD+J7NJEx38DYQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christophe Kerello <christophe.kerello@foss.st.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: Re: [PATCH v3 1/2] mtd: rawnand: stm32_fmc2: remove unsupported EDO mode
Date:   Mon,  3 Apr 2023 17:59:29 +0200
Message-Id: <20230403155929.137657-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328155819.225521-2-christophe.kerello@foss.st.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'f71e0e329c152c7f11ddfd97ffc62aba152fad3f'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-03-28 at 15:58:18 UTC, Christophe Kerello wrote:
> Remove the EDO mode support from as the FMC2 controller does not
> support the feature.
> 
> Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
> Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
> Cc: stable@vger.kernel.org #v5.4+
> Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
