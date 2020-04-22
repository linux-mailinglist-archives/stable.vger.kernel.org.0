Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F621B3CF8
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgDVKKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbgDVKKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 06:10:19 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB7EC03C1AA
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 03:10:18 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t11so1164727lfe.4
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 03:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C6DnVKRB6NIRjwPWAXMLQ0NJgkEo62OoeU3KPTioqDw=;
        b=KObRodabLDVnh1RpbkhyXvi3gbBuwT9PIEfxCQHFdpvCFUN4d+kPA4VAHcRZ0RmfVZ
         4wIxqA6/QeN4pIEGPxiruC+Wizaj1UgClk2twBJwLYA2KBkeFCQVRwwAjmdMB/BoSkB6
         r0AGQiT09nh4MdZh/BYj9bHL+W2gJtzl2/Z/wSMvMN7E0k10z4EmkCrpKMeu3+5jfc98
         JQsmBEmWCQqQBBzMEAC9wIQz0e2+Tu9TzKVjO/TR1zp3LnZK8eP8DzkVpWzZzZeasvxE
         +Ex9E8rxacadZ+yRRA/FMveBBk1RwMPUPgpDv6wlQi9J/i9v18jGoBlxjLEMNJRwtqTs
         wGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C6DnVKRB6NIRjwPWAXMLQ0NJgkEo62OoeU3KPTioqDw=;
        b=thECzTYj7k1YOb9569uH5sTR3vjt38oLxLXdzXEo0BD9v4PvIIfWXy+qW0zNloF73E
         3VJ94OvZMt7jy2idAgOwyH04dj0wd7Ys3dSxlvFoNFHGbRMEQ37B5MCJBGWyNx2vYFAA
         sg8lMD8hPQid1Ab38wOeVjKc6eBmSRW9E/zFYAy03mSQwW5sFRDjhiSyvmL0c842/G4I
         Lv77uEw3iOx8nC3UztUsv923ITZIo+e7lPlAdJIbhxS45Y+JZK53zicgl8qn8JPN7A3p
         K4WkLnPOlRGoSEzE8TbKnZGPxsEsDvPpmpdLxo89KpZ2HuKvPYAo0R+YnIDP6D86Yp4f
         nRlQ==
X-Gm-Message-State: AGi0PuaTI1xkmTiC+e8K/ahCGFyCTkbNDfCeLmYEpoklsF4H5+tQUzZ4
        pb1Uao9RF9zTeB+H2JkHcmhoVQ==
X-Google-Smtp-Source: APiQypLiEWMoI272TzvgNnpPzocl0qlAVahabYTkLZn37KAuy/71WeWwggv4+DDRNoenNgGXkegsaw==
X-Received: by 2002:a19:ee11:: with SMTP id g17mr16425495lfb.42.1587550216225;
        Wed, 22 Apr 2020 03:10:16 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-181-7.NA.cust.bahnhof.se. [98.128.181.7])
        by smtp.gmail.com with ESMTPSA id s6sm4246018lfs.74.2020.04.22.03.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 03:10:15 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org
Subject: [RESEND PATCH v2 2/2] amba: Initialize dma_parms for amba devices
Date:   Wed, 22 Apr 2020 12:10:13 +0200
Message-Id: <20200422101013.31267-1-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's currently the amba driver's responsibility to initialize the pointer,
dma_parms, for its corresponding struct device. The benefit with this
approach allows us to avoid the initialization and to not waste memory for
the struct device_dma_parameters, as this can be decided on a case by case
basis.

However, it has turned out that this approach is not very practical. Not
only does it lead to open coding, but also to real errors. In principle
callers of dma_set_max_seg_size() doesn't check the error code, but just
assumes it succeeds.

For these reasons, let's do the initialization from the common amba bus at
the device registration point. This also follows the way the PCI devices
are being managed, see pci_device_add().

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Tested-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/amba/bus.c       | 1 +
 include/linux/amba/bus.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index fe1523664816..8558b629880b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -645,6 +645,7 @@ static void amba_device_initialize(struct amba_device *dev, const char *name)
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
 	dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
+	dev->dev.dma_parms = &dev->dma_parms;
 	dev->res.name = dev_name(&dev->dev);
 }
 
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 26f0ecf401ea..0bbfd647f5c6 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -65,6 +65,7 @@ struct amba_device {
 	struct device		dev;
 	struct resource		res;
 	struct clk		*pclk;
+	struct device_dma_parameters dma_parms;
 	unsigned int		periphid;
 	unsigned int		cid;
 	struct amba_cs_uci_id	uci;
-- 
2.20.1

