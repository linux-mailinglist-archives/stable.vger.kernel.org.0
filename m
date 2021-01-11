Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8123C2F210A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbhAKUpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 15:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391134AbhAKUob (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 15:44:31 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A488FC061794
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:43:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 3so23740wmg.4
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZNyxgXy3w0mtNQj3+khVYCS012379DOTQgRjpMdPsGI=;
        b=NFKp4RYSiZEHlaY8dktteyrZ3kVncfOPJn1A32VS21QuM/eHDmpk0l4zRAZHpIkd5P
         YojdMzYCuscO6j2hJ3myR15gnPjhEhcCFy69hYLxNE+1AWnHkI/A3MCEmBqKWnHQRYqI
         7iDkwNDMnxk9d6opGvpKP5a+TCwvEgsYOFZbFUTGqMp7VOPRN/zmFgS94rhOrjNZOCdw
         5vGwdYInSHLYizyOy5N/swLLE9J+X/kqKE2CAT3U1qYG+end4hkibN7YiWuxPqQ5Ko5H
         m+uHJhNNex/62ENXGcdvbNbyjzyVbd0SlMITh6zlHV+5cBoYlJiyIsYUFdezUFTP4fPc
         LYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZNyxgXy3w0mtNQj3+khVYCS012379DOTQgRjpMdPsGI=;
        b=FaFJjO5ksg/jtNDIY2b12f3Y0qkNXGnwt2fLXKJ6Jq5t3OQ1qcg7yt5UEKNoBbFncj
         QCpsO9tOyIWriANsIa0drZn84fOF52MsbMPF78UKOnzCl0WU/Zepmo/OBWojDWJekJUL
         rCrbEKFqh5EDF4iyLbomUkvWEWRlM8GoIx6oQavMsJdIBfUU5TnLyDMI7j1nKwpYPe3n
         TGaGv2+hf/fR++LJc1DPNfDrNL9dW67uYw4v5Snx/kuy3Wga4qgVwtPKyTspuHkBu1Ha
         ALTSyxNsPdS85hzjjGrzsmDVFAQ+eHebc6hjy9FBfTRQTUq70mkJUdFE/C+fY5dBImzp
         id6A==
X-Gm-Message-State: AOAM533H01+oKMN9leH6xdeUU8+UZsKBFUTkKazK9Y7bodoMZFqDYNU4
        B00ZwtDghP89p4ZanxXw2DyEkfDIfgAMAw==
X-Google-Smtp-Source: ABdhPJztXkBp/ht5iQCDZzHefiNDxFz+K/5NYYTd7X65VLJvMpBjV6am9L5h45HpO4FuO5S943mOIg==
X-Received: by 2002:a1c:4d0a:: with SMTP id o10mr492608wmh.185.1610397829385;
        Mon, 11 Jan 2021 12:43:49 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id a62sm628220wmf.7.2021.01.11.12.43.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 12:43:48 -0800 (PST)
Date:   Mon, 11 Jan 2021 20:43:47 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: pxa2xx: Fix use-after-free on
 unbind" failed to apply to 4.19-stable tree
Message-ID: <20210111204347.wpr5gyzhruvinumr@debian>
References: <160915257890155@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="msl7ymncpdjudsee"
Content-Disposition: inline
In-Reply-To: <160915257890155@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--msl7ymncpdjudsee
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 11:49:38AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.


--
Regards
Sudip

--msl7ymncpdjudsee
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-pxa2xx-Fix-use-after-free-on-unbind.patch"

From 3c70fbd5207444a0e0ede62ab991125dfd442d76 Mon Sep 17 00:00:00 2001
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
index eafd0c2135a1..a889505e978b 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1572,7 +1572,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(dev, sizeof(struct driver_data));
+	master = devm_spi_alloc_master(dev, sizeof(*drv_data));
 	if (!master) {
 		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		pxa_ssp_free(ssp);
@@ -1759,7 +1759,6 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
-	spi_controller_put(master);
 	pxa_ssp_free(ssp);
 	return status;
 }
-- 
2.11.0


--msl7ymncpdjudsee--
