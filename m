Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DC06E43AD
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 11:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjDQJ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 05:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjDQJ1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 05:27:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0922C1FE5;
        Mon, 17 Apr 2023 02:27:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fw30so9567145ejc.5;
        Mon, 17 Apr 2023 02:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681723621; x=1684315621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgHbhg3esGq56aGO/HEuNPuheQE575OxiIZl4oc8nlY=;
        b=RNrYptZWKFmRWsxaXdqW76/MXUnEG8YgJVkIPz2XIswRWoOddQSHkqRrK+IWS6crsY
         6Vt9Ea7y1y8e2gV1jHItJ+LBt5HUj3MgbHtEUYLvFWc8noeLVxQ5B8x1+EM+E4oql0SS
         ZYO4SpQeMMYZDDfbbuNPWAB7Q+IU9v3XBjfMU1cS496/Rswp7tYkaO3yuuPNW2Ck8RR1
         reCQqpxGhzRB64OhtAafre8Rqui2CVrSOFZnF8qarj35TUNEv3pr0udqhC2OEpxalL/s
         /2GKSUjvgwyZ7hXbmZf5+fQhPL5Ie0UAhm6CuerxV2kjCQ+2SSZ/tDUoeznRROi4hsE6
         RM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681723621; x=1684315621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgHbhg3esGq56aGO/HEuNPuheQE575OxiIZl4oc8nlY=;
        b=U/dWfr/Y8/65TBW3EvJ7aGjxAySwuuk9J5kYQLKgUg9X8y4ohb5z0E+vTLFCdS6I8A
         MGjyGDMf0VFFWo1MaiaphqJxgL/Ijxx9FEYbu6/kXU/hKfYhvcw1zJj+3hjaN/rvlXPU
         wHjUkW7dyAFBdSWbQ/Tu8IMu9sQ2wq1kolS4o9nwzB/job2YXPKMrBJlDPP+37MZUpgL
         YHi600RHATnmLl6UgNOnGBxKEPVQjn+lEy1ghYZK5ZvwWLxYWDmRl+WHw6Sv0oyGjWtr
         SLhUtmUPOCFYm4LH0YZHH5pECVUDHSq0/Ct2wTGHapj3vJh9gfNbIZNXyVxSSQ7AXYKy
         o9/A==
X-Gm-Message-State: AAQBX9f3jAVRJzcjKOBmyOgasGz3V6zUlhIs2+5qb5oCd7XlkJ4Cr24Z
        cT8dTuA7lXNy34NV8Mhj0LI=
X-Google-Smtp-Source: AKy350ZtaT9/Ot9FlAA7mneJxaKzhVc1IKVlLT6ux5SovpbAI5g6KGB9sKEQNfomYwZ1BPms8vpRdA==
X-Received: by 2002:a17:906:408c:b0:94a:653b:ba41 with SMTP id u12-20020a170906408c00b0094a653bba41mr6729159ejj.15.1681723621512;
        Mon, 17 Apr 2023 02:27:01 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id p20-20020a170906615400b0094aa087578csm6398596ejl.171.2023.04.17.02.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 02:27:01 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Brian Norris <briannorris@chromium.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/11] PCI: rockchip: Write PCI Device ID to correct register
Date:   Mon, 17 Apr 2023 11:26:20 +0200
Message-Id: <20230417092631.347976-3-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230417092631.347976-1-rick.wertenbroek@gmail.com>
References: <20230417092631.347976-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Write PCI Device ID (DID) to the correct register. The Device ID was not
updated through the correct register. Device ID was written to a read-only
register and therefore did not work. The Device ID is now set through the
correct register. This is documented in the RK3399 TRM section 17.6.6.1.1

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 6 ++++--
 drivers/pci/controller/pcie-rockchip.h    | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index d5c477020417..9b835377bd9e 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -115,6 +115,7 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
 					 struct pci_epf_header *hdr)
 {
+	u32 reg;
 	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 
@@ -127,8 +128,9 @@ static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
 				    PCIE_CORE_CONFIG_VENDOR);
 	}
 
-	rockchip_pcie_write(rockchip, hdr->deviceid << 16,
-			    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) + PCI_VENDOR_ID);
+	reg = rockchip_pcie_read(rockchip, PCIE_EP_CONFIG_DID_VID);
+	reg = (reg & 0xFFFF) | (hdr->deviceid << 16);
+	rockchip_pcie_write(rockchip, reg, PCIE_EP_CONFIG_DID_VID);
 
 	rockchip_pcie_write(rockchip,
 			    hdr->revid |
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 32c3a859c26b..51a123e5c0cf 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -133,6 +133,8 @@
 #define PCIE_RC_RP_ATS_BASE		0x400000
 #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
 #define PCIE_RC_CONFIG_BASE		0xa00000
+#define PCIE_EP_CONFIG_BASE		0xa00000
+#define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
 #define PCIE_RC_CONFIG_RID_CCR		(PCIE_RC_CONFIG_BASE + 0x08)
 #define PCIE_RC_CONFIG_DCR		(PCIE_RC_CONFIG_BASE + 0xc4)
 #define   PCIE_RC_CONFIG_DCR_CSPL_SHIFT		18
-- 
2.25.1

