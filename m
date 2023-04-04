Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92566D5AB7
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 10:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbjDDIZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjDDIZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 04:25:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DE21BE8;
        Tue,  4 Apr 2023 01:25:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cn12so127310846edb.4;
        Tue, 04 Apr 2023 01:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680596703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9JMZo+h1Q4ZjhPYRd6OF+eR14aI4rNR3ktfkwOViXk=;
        b=eKcMH3SCK/MbvXuG3s2Ev/t/hq1VBjng1BsNbovjdYDzWxmh5EvfFbpoGhQSkIs7zd
         KM9qQGv9dmQ07lGLewPyudXrdyFruzXwvpI2vGdfLjgflmsAhE9oNVznVCB9CjjkQo+X
         Mvl6VslYs4Yysi7O6tvayCT3OHbAor2EBVaajWAaOf5G7tIlXK9aR69Q9HIkROmcmszi
         7zzlVzO+JIbwT4BvHoDFDugx8swq7vYbahcdtmjJ5bjKKkisKjwDcLnCpGfx8mUN6AKH
         tkoUdxWjKem1Qh8D9bT9a0O9XjT60QV/3PfPJ/36oYkEJ4TQpRYO7tupUgtXLySFhlPU
         PcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680596703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9JMZo+h1Q4ZjhPYRd6OF+eR14aI4rNR3ktfkwOViXk=;
        b=mWyomXZOFrqYZrKDrynJYi2MIJzXfU4QwNyzF2S+3SG/4Lhel2EFEoTOHhZvbhhDkw
         RwoFewucREhBFY2gs+9Jo2Fly/TK7bHpvgYdD4fVmbdVVdB/ddlZ/+MLERWHS6wJ/4V0
         LnYPaYrdgX1r1mevJbTqQHUzkrdhZg5kv9soN0RrIGEr2rratT41GnlsaZLZgK4dHtfL
         3XhzblGspXrFS6EifeK5rRLfKZjO0yyAIVwcAwi//K/2l44vVwffzlK47s5iBpWqxl25
         6jWcsF8V4u9fkVFGCzGpzJJSvDUQCjDwrYQkAjfDuftr9N32BsWX021N4ojnR5BqbcHR
         KfoQ==
X-Gm-Message-State: AAQBX9eipWwl+B+uOKwfI73rvtOIotV8xeuYyfAXaTTfz+vFDc9DodoG
        FR5aeUWBYRtfWpe+JQ4fmaI=
X-Google-Smtp-Source: AKy350Ys42q5uri8bicxqR0N3cA43deEBD9IDcrI3QZ/WfiFn0XzrsmaOfX3iP+K1xydrcXYHOvJtg==
X-Received: by 2002:a17:906:f29a:b0:933:816c:abb9 with SMTP id gu26-20020a170906f29a00b00933816cabb9mr18076043ejb.36.1680596703038;
        Tue, 04 Apr 2023 01:25:03 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id s5-20020a170906454500b008e54ac90de1sm5640652ejq.74.2023.04.04.01.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 01:25:02 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     damien.lemoal@opensource.wdc.com, xxm@rock-chips.com,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Johan Jonker <jbx6244@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Caleb Connolly <kc@postmarketos.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lin Huang <hl@rock-chips.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/11] PCI: rockchip: Write PCI Device ID to correct register
Date:   Tue,  4 Apr 2023 10:24:15 +0200
Message-Id: <20230404082426.3880812-3-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
References: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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

