Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110F42FDACD
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbhATU1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 15:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388672AbhATUZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 15:25:49 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9DBC0613ED
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 12:24:45 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id m4so24298700wrx.9
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 12:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yimTY/rG3sROqg7NlmhfyEzAOlH8lsDPUQQplBsWTqE=;
        b=lt0z8oCWGAAa7PvG7SYEdniL+MhiUYU+hbaghuWb4RvDKRK5SOcQLdxKUFLxgErHva
         aOuN3OC9cdZoAb7UpjXLlU+arBINFYVqR6ya943hOEFdjW/XiMc6XrtRiGkJzEdiDBCE
         TqQT5ZqTeGz+rjmXEgJILajO/Dhn93RHFo6cpRe989iVDnxFRw/NniMRe+a6vq4/7p11
         AxpnrGl4xKnvXp71B20V7H5a/I6uVDAZUsAfbDCWhPXI9adHrZkLpW3dvuNiPhk7bRZG
         s4SE+r6SdabUGQ5CRa6Pu0UCUHY8rOh8r14MYwgKvTa8+Se5io9odTnpDKRNwI1Y5RVC
         9pwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yimTY/rG3sROqg7NlmhfyEzAOlH8lsDPUQQplBsWTqE=;
        b=aEIpiKZm+lLfFOvcnkpLqYndTyHB83/zGYm1kozLxTc4TM1nXFqzxsL7G0xCp7VGTw
         8Yd7pLbKUHvL3U9nQaMEx72Q476SSF1G9/NZKLQK9sq4+y07qigrD2s0t5b5++v1b2Ib
         RpsxqvcS8U5pKRNqu82JzpMlWTGnD/3JYcBXUpR/gbRtMmMfTEkU+lwKjuEokgofVAEy
         agjQqggyrDUxVv8LTwtMUnl7NrHzxTOLNiyBMYNihiMbBUosam/jgfRyqedWn0KIoilh
         LCmjju5tVtk3686tRuG/0rFF+EOjEnZqqLYvr6fRNumf3Zg0gxZEVlf/nYXI90Ahz1GL
         bidQ==
X-Gm-Message-State: AOAM5319ZAHP0MrUGXLZdrlkcwfXssZWIQNNDNhST0IsQnrJWP5oQQLG
        ZjAvorkAS+gDKFAcHVJ9wYa1Haqr2GTkzg==
X-Google-Smtp-Source: ABdhPJyXoxn9MMlGzhztgttF60mVgILtPONtYeZqGwTvoOJFs5cQWpwyNGAMCLyKwEjdUCsq37GESA==
X-Received: by 2002:a5d:4a09:: with SMTP id m9mr11208184wrq.359.1611174284374;
        Wed, 20 Jan 2021 12:24:44 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id h16sm5516769wmb.41.2021.01.20.12.24.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Jan 2021 12:24:43 -0800 (PST)
Date:   Wed, 20 Jan 2021 20:24:41 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org,
        tmaimon77@gmail.com
Subject: Re: FAILED: patch "[PATCH] spi: npcm-fiu: Disable clock in probe
 error path" failed to apply to 5.4-stable tree
Message-ID: <20210120202441.foyzperafwmqmsrh@debian>
References: <160915322711352@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qrl2mgursonnglyp"
Content-Disposition: inline
In-Reply-To: <160915322711352@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qrl2mgursonnglyp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:00:27PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with 4c3a14fbc05a ("spi: npcm-fiu: simplify the
return expression of npcm_fiu_probe()") which makes backport easier.

--
Regards
Sudip

--qrl2mgursonnglyp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-npcm-fiu-simplify-the-return-expression-of-npcm_.patch"

From cefb8d3e297579898a170ae99f9bad4c0c5342a4 Mon Sep 17 00:00:00 2001
From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Mon, 21 Sep 2020 21:11:06 +0800
Subject: [PATCH 1/2] spi: npcm-fiu: simplify the return expression of
 npcm_fiu_probe()

commit 4c3a14fbc05a09fc369fb68a86cdbf6f441a29f2 upstream

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20200921131106.93228-1-miaoqinglang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-npcm-fiu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index 5ed7c9e017fb..561c68329133 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -677,7 +677,6 @@ static int npcm_fiu_probe(struct platform_device *pdev)
 	struct npcm_fiu_spi *fiu;
 	void __iomem *regbase;
 	struct resource *res;
-	int ret;
 	int id;
 
 	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
@@ -736,11 +735,7 @@ static int npcm_fiu_probe(struct platform_device *pdev)
 	ctrl->num_chipselect = fiu->info->max_cs;
 	ctrl->dev.of_node = dev->of_node;
 
-	ret = devm_spi_register_master(dev, ctrl);
-	if (ret)
-		return ret;
-
-	return 0;
+	return devm_spi_register_master(dev, ctrl);
 }
 
 static int npcm_fiu_remove(struct platform_device *pdev)
-- 
2.11.0


--qrl2mgursonnglyp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-spi-npcm-fiu-Disable-clock-in-probe-error-path.patch"

From 02b79219e662710c4ec8fcc4047cd9da8ce3c281 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:16 +0100
Subject: [PATCH 2/2] spi: npcm-fiu: Disable clock in probe error path

commit 234266a5168bbe8220d263e3aa7aa80cf921c483 upstream

If the call to devm_spi_register_master() fails on probe of the NPCM FIU
SPI driver, the clock "fiu->clk" is erroneously not unprepared and
disabled.  Fix it.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Tomer Maimon <tmaimon77@gmail.com>
Link: https://lore.kernel.org/r/9ae62f4e1cfe542bec57ac2743e6fca9f9548f55.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-npcm-fiu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index 561c68329133..1e770d673905 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -677,7 +677,7 @@ static int npcm_fiu_probe(struct platform_device *pdev)
 	struct npcm_fiu_spi *fiu;
 	void __iomem *regbase;
 	struct resource *res;
-	int id;
+	int id, ret;
 
 	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
 	if (!ctrl)
@@ -735,7 +735,11 @@ static int npcm_fiu_probe(struct platform_device *pdev)
 	ctrl->num_chipselect = fiu->info->max_cs;
 	ctrl->dev.of_node = dev->of_node;
 
-	return devm_spi_register_master(dev, ctrl);
+	ret = devm_spi_register_master(dev, ctrl);
+	if (ret)
+		clk_disable_unprepare(fiu->clk);
+
+	return ret;
 }
 
 static int npcm_fiu_remove(struct platform_device *pdev)
-- 
2.11.0


--qrl2mgursonnglyp--
