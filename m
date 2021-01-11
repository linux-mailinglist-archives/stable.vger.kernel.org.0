Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB32F2112
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391215AbhAKUpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 15:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390791AbhAKUpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 15:45:49 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F947C061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:45:09 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m5so134056wrx.9
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DrCh6CjVqcxtLw3kGW7seTg6rb8L0rH8w5Pqdi/02Bk=;
        b=nhXjAlIr4SPyyNqLOoOPbA0ZUjquzOEqPMczr7WOyq7zPwkUCTJbY34E7duhDQHmYv
         2EQFUHPY4TO1x40W6WwYCOAzzpbRNEv0Un0LU6j7qgeWYKyFKLGaNzP2LZx0JDyZWFIw
         tdZxHsOuNLHT2U4cNUzrDzoO3TmDnxNar1oWE1l3zeCnY9IbCrFnKrCkjBqDZ3nHYGAS
         ZQoDpNpd4Cy9h/W7BeENyG3Ldj+nbRfFTvPU80peAozPvuHUrJi2MW8Pr9l7938nPqR+
         8gkm7z3lCkTlbayqqhaK3bweTxjm/zMT4r7uVMSI/EeWWSI20z8dvvhBMswzqjKepgD1
         9p/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DrCh6CjVqcxtLw3kGW7seTg6rb8L0rH8w5Pqdi/02Bk=;
        b=d3KfAO1r4d2TxQP7kUvMGT3s92hwwS7A7OnnEWkIhviO5QdLXJOGXetVp9k8+lb9xr
         cg6x17P/8IWZIf8/ogPmHez167/amQg6M7Y3PTMDqHYRm3yZGDqraFp8UI0VtNz3UziW
         CejPSsh1g49u5tenrvc07L21kU0q0Hs5bHWQ3FI6eKXg01UuUjOywonlyLqCzx8ljQJ7
         gHz+P9ZVpU9nHFlHvVNLFTVwpsjjxGiIPObg0XZlpu+nm5p+c8U6xYIzigMw8OF/9VS+
         0bm2dVTnHGmzYAtO8J6Shi+SX6ljh4QmE7Ozh6GhCjWwZs/Jr3xG7IpV6Yx2sY9vCg++
         3zIQ==
X-Gm-Message-State: AOAM533OE/9Wj87TQRpzK+W7u+Ad5h7D1CigNJlUrYtEghhCDE/jspdI
        5WTwSU7CjAcxZIpzxnq/47Fkyu7b91r9zw==
X-Google-Smtp-Source: ABdhPJzZD4DJAGsD/gyzFyFbdZRDIc/eYMzFbJ+uC8RmzgpPyr7pc5lgetTLVkdD7EcTMJb+/UtzIg==
X-Received: by 2002:a5d:6983:: with SMTP id g3mr884604wru.168.1610397908013;
        Mon, 11 Jan 2021 12:45:08 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id x18sm1266382wrg.55.2021.01.11.12.45.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 12:45:07 -0800 (PST)
Date:   Mon, 11 Jan 2021 20:45:05 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: pxa2xx: Fix use-after-free on
 unbind" failed to apply to 4.14-stable tree
Message-ID: <20210111204505.yzydbkffdn2k44u3@debian>
References: <160915257822973@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a7mtnjoi7ljaqlh4"
Content-Disposition: inline
In-Reply-To: <160915257822973@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a7mtnjoi7ljaqlh4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 11:49:38AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.9-stable and 4.4-stable.

--
Regards
Sudip

--a7mtnjoi7ljaqlh4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-pxa2xx-Fix-use-after-free-on-unbind.patch"

From d0263dea6365ee31ca590e3866b8ca6a24cf456a Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:05 +0100
Subject: [PATCH] spi: pxa2xx: Fix use-after-free on unbind

commit 5626308bb94d9f930aa5f7c77327df4c6daa7759 upstream

pxa2xx_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master/slave() helper
which keeps the private data accessible until the driver has unbound.

Fixes: 32e5b57232c0 ("spi: pxa2xx: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v2.6.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v2.6.17+: 32e5b57232c0: spi: pxa2xx: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v2.6.17+
Link: https://lore.kernel.org/r/5764b04d4a6e43069ebb7808f64c2f774ac6f193.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-pxa2xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 1579eb2bc29f..06eb7d259b7f 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1660,7 +1660,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(dev, sizeof(struct driver_data));
+	master = devm_spi_alloc_master(dev, sizeof(*drv_data));
 	if (!master) {
 		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		pxa_ssp_free(ssp);
@@ -1841,7 +1841,6 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
-	spi_master_put(master);
 	pxa_ssp_free(ssp);
 	return status;
 }
-- 
2.11.0


--a7mtnjoi7ljaqlh4--
