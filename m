Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768B14ED8BD
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiCaLzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 07:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiCaLzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 07:55:50 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A98473B1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 04:54:02 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 590713F80B
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 11:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648727637;
        bh=2jyx0kbR6GJQGmMST8/3DmUefxT+fMVF/gHFJomSucY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Lq5JAMdHl+nAWXVnGaMKtcHSHNheTLAAMPNzo//S4Q0ADAvfFC/BggCPrzfoUSv0O
         HPoD66gLM5xXfmAENI8FIYLQYf3plJ/gA8feFnUUiPfo011kRn14wlJ7+/4EfpcC70
         gwFBpiLbdQ5DZUA+g3ng3brUJmZOUBx0f8QiRdxhyosqKIBratBCWanaybKNuC0WPV
         xrFfIReV7tIvKSnyjn7cvUYELwkC1pJiyS/roQo66G7Wn61jLR1M9HhDcSPSu0oxFN
         63BdW7qwU7doIwFR7CG1TLpXQz+mJ9epX1mbT7UAH11vT1L7hp7P1uRovgL8gdAdiN
         v7LxiSBxKI11Q==
Received: by mail-ej1-f71.google.com with SMTP id de52-20020a1709069bf400b006dffb966922so11389055ejc.2
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 04:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2jyx0kbR6GJQGmMST8/3DmUefxT+fMVF/gHFJomSucY=;
        b=EqlI9CZQXJ8owRrDA3YcBDp4+MUsEHOsdCJXL3jbAGwgrJrCVMAVPHO3mv/dUSkfcO
         32u/zFGg2Nl8A3d5HvtZSgf2kgamckrQOKAR2FvMDoKib69hU5cuCdRBqRblO0Qh+zMN
         AGadyBRxj/+ZNn4pCM8WWNy55PNBnTEofk2qIkThuy/Ud4zz1FC06eTXw8BW5/TQ6UTo
         BSxVz/DMjiWJA33gVFTpw1GZnDhzYR7o8Z2cMcLV5JMfQZIAufPMBsqN0QgZ9CMSi5Xh
         3MADLzOJiv3GeBZx3SGvkK4VtDKF9SCpsUe6lUsoroOY468STDgJg07ldGT0Fn2Sd959
         9YKQ==
X-Gm-Message-State: AOAM533f+EgDw3eT7mpm7zebgIp1bE8hX+enMBffB7mlyFXA8NGWMkzY
        Fh4j3MumH+mZZXZtNV5MqjfYhVhTGZO1QVL/Hx6sZbQzKypuArM5S8aleVwMr545VDp6JU2X8l9
        uAbI947prtme4hCB6KioZ50yfZe3OhXV6lw==
X-Received: by 2002:aa7:c345:0:b0:419:12ae:449c with SMTP id j5-20020aa7c345000000b0041912ae449cmr16149297edr.300.1648727634811;
        Thu, 31 Mar 2022 04:53:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy48UxSxDPX9nmoRMJzCi4JzPNION0lcRH7bTAxdAnF3X5e7OwyL7gx9tfipboDXsx4I+XcMA==
X-Received: by 2002:aa7:c345:0:b0:419:12ae:449c with SMTP id j5-20020aa7c345000000b0041912ae449cmr16149274edr.300.1648727634563;
        Thu, 31 Mar 2022 04:53:54 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm9449156ejj.74.2022.03.31.04.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 04:53:54 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH for v5.15+] PCI: fu740: Force 2.5GT/s for initial device probe
Date:   Thu, 31 Mar 2022 12:53:45 +0100
Message-Id: <20220331115345.117662-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit a382c757ec5ef83137a86125f43a4c43dc2ab50b upstream.

The fu740 PCIe core does not probe any devices on the SiFive Unmatched
board without this fix (or having U-Boot explicitly start the PCIe via
either boot-script or user command). The fix is to start the link at
2.5GT/s speeds and once the link is up then change the maximum speed back
to the default.

The U-Boot driver claims to set the link-speed to 2.5GT/s to get the probe
to work (and U-Boot does print link up at 2.5GT/s) in the following code:
https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/pci/pcie_dw_sifive.c?id=v2022.01#L271

Link: https://lore.kernel.org/r/20220318152430.526320-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---

 Please apply this patch to v5.15+ stable trees which fixes PCIe on
 the very popular SiFive Unmatched RISC-V board.

 drivers/pci/controller/dwc/pcie-fu740.c | 51 ++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-fu740.c b/drivers/pci/controller/dwc/pcie-fu740.c
index 00cde9a248b5..78d002be4f82 100644
--- a/drivers/pci/controller/dwc/pcie-fu740.c
+++ b/drivers/pci/controller/dwc/pcie-fu740.c
@@ -181,10 +181,59 @@ static int fu740_pcie_start_link(struct dw_pcie *pci)
 {
 	struct device *dev = pci->dev;
 	struct fu740_pcie *afp = dev_get_drvdata(dev);
+	u8 cap_exp = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+	int ret;
+	u32 orig, tmp;
+
+	/*
+	 * Force 2.5GT/s when starting the link, due to some devices not
+	 * probing at higher speeds. This happens with the PCIe switch
+	 * on the Unmatched board when U-Boot has not initialised the PCIe.
+	 * The fix in U-Boot is to force 2.5GT/s, which then gets cleared
+	 * by the soft reset done by this driver.
+	 */
+	dev_dbg(dev, "cap_exp at %x\n", cap_exp);
+	dw_pcie_dbi_ro_wr_en(pci);
+
+	tmp = dw_pcie_readl_dbi(pci, cap_exp + PCI_EXP_LNKCAP);
+	orig = tmp & PCI_EXP_LNKCAP_SLS;
+	tmp &= ~PCI_EXP_LNKCAP_SLS;
+	tmp |= PCI_EXP_LNKCAP_SLS_2_5GB;
+	dw_pcie_writel_dbi(pci, cap_exp + PCI_EXP_LNKCAP, tmp);
 
 	/* Enable LTSSM */
 	writel_relaxed(0x1, afp->mgmt_base + PCIEX8MGMT_APP_LTSSM_ENABLE);
-	return 0;
+
+	ret = dw_pcie_wait_for_link(pci);
+	if (ret) {
+		dev_err(dev, "error: link did not start\n");
+		goto err;
+	}
+
+	tmp = dw_pcie_readl_dbi(pci, cap_exp + PCI_EXP_LNKCAP);
+	if ((tmp & PCI_EXP_LNKCAP_SLS) != orig) {
+		dev_dbg(dev, "changing speed back to original\n");
+
+		tmp &= ~PCI_EXP_LNKCAP_SLS;
+		tmp |= orig;
+		dw_pcie_writel_dbi(pci, cap_exp + PCI_EXP_LNKCAP, tmp);
+
+		tmp = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
+		tmp |= PORT_LOGIC_SPEED_CHANGE;
+		dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, tmp);
+
+		ret = dw_pcie_wait_for_link(pci);
+		if (ret) {
+			dev_err(dev, "error: link did not start at new speed\n");
+			goto err;
+		}
+	}
+
+	ret = 0;
+err:
+	WARN_ON(ret);	/* we assume that errors will be very rare */
+	dw_pcie_dbi_ro_wr_dis(pci);
+	return ret;
 }
 
 static int fu740_pcie_host_init(struct pcie_port *pp)
-- 
2.32.0

