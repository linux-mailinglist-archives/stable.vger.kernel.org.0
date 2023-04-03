Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C8A6D4CEF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjDCP7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbjDCP7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:59:34 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBBA198C;
        Mon,  3 Apr 2023 08:59:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AAD21E0005;
        Mon,  3 Apr 2023 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680537566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPOb2oJsLReltUpfhtCHFxjUhpwGqcY6PIdWLBKJAPE=;
        b=NIGQ37EycIDn6wmQSD51ITrZrfmKW/tzuF8bQQk6WmEmjSZec7Rtbhd0rjAZJrDnOHvY+M
        jQjKqI1Gi9AQ43sGVz0+MABRB6w6DMOmJTHmMiUwcaeWcWLRzwW1i3nGzsdq/nEfQOfNAt
        MyBbb+O3VvMgyFCcUqJBNPSi2C3DNXxnuJLSl4kXkIR9PgKfUv8Ugx27rjq7FzE+AXHWmo
        CpdQGR91MUB4NMpshreFaf7MmcnmO6kSNCPH+gJFnDArDxCcSDnRgc+Ly9/Ar1vkBssmiu
        svnrJs4gbnWPBnzrNinXymR3lZwsf50dvSFWgcCd9+ED1/XU3FUAOXugdlFbRQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christophe Kerello <christophe.kerello@foss.st.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: Re: [PATCH v3 2/2] mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min
Date:   Mon,  3 Apr 2023 17:59:21 +0200
Message-Id: <20230403155921.137622-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328155819.225521-3-christophe.kerello@foss.st.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'ddbb664b6ab8de7dffa388ae0c88cd18616494e5'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-03-28 at 15:58:19 UTC, Christophe Kerello wrote:
> Use timings.mode value instead of checking tRC_min timing
> for EDO mode support.
> 
> Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
> Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
> Cc: stable@vger.kernel.org #v5.10+
> Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
