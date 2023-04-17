Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF6C6E43B6
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 11:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDQJ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 05:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjDQJ1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 05:27:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0715C3A94;
        Mon, 17 Apr 2023 02:27:06 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dm2so62464503ejc.8;
        Mon, 17 Apr 2023 02:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681723624; x=1684315624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+j5o6fQJQAp9pw9pBLSNzanRfTudfjw+am50p7MN68=;
        b=A8x572u5E+uNqeMjdLTyUOpLHMn5BUr/ENipcSEmI93Ofwh9gCCbXoHv1BAWhUK4Fj
         Ay9mQaDk18LX7JPBlKEFMx+5tJipdDJ82ryrj0BycUdc8QW2aSAQZLRbb9sXCU6W2MFJ
         H7CbTwhlBniI7h1kEwjFlvyZR7aYLQReiEVk+w22YJvFP/z2OGELZuySeG6G9NC2ORv5
         ewBMVRuske96Pt2q3KewsOHxn8BCsJw4j0N+9ySrLNYkbK21WE7QjaUUvjB+FNIYVK56
         cAJzmwBuKuLs0fyZB/5l+6hMElblkxn5SSAqpNyhA4/TzzLA8h+K+Rtfxa9PIGIEimUI
         M6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681723624; x=1684315624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n+j5o6fQJQAp9pw9pBLSNzanRfTudfjw+am50p7MN68=;
        b=GiRo7wCljKYLRPRy8HipMiAcqPVDbzDGB0siRFHl+mf1h3DpEUxtFhllLt41nLZ2Ao
         E1N7Y/LadV6f4yqphJE2zt84pkIxkzkIRdmG/DksP//mv3npCyGacFsI+h2JvY65l9TW
         +Kes+r4CObShKB3xqENMbaIyEFFxFbo1h57tf0eYd5T6L0dUIe1hZJFKoMGRU/PZGwp4
         IEJ+R7RgPBQe/L/OgGrJ8SMlDWDD9nvTUfLv+sRu1pj10kJCFYNuZxFujQYZlJ2UF+7y
         5cPvY7f7RW+fsGo2YuBUp4Gj44tJ9y74rI895lAtIvazfcng+YC+aXc9rRQtC9GjfmtP
         PBUA==
X-Gm-Message-State: AAQBX9fTSl19Z+hzwYmJGF1wD1+flzDTzyjub73ll1tbfT2QPifeh6Za
        +zid8SfdZuOOBcA9GH/dhb0=
X-Google-Smtp-Source: AKy350bwKnIAuymj6R4Bop2jFbqIKWbdAh6gr9vRU/9fNPpwQjpcs5wiS63Mdr7mmSWWrO5MOpW/8Q==
X-Received: by 2002:a17:906:244d:b0:94e:626e:c108 with SMTP id a13-20020a170906244d00b0094e626ec108mr6990751ejb.50.1681723624285;
        Mon, 17 Apr 2023 02:27:04 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id p20-20020a170906615400b0094aa087578csm6398596ejl.171.2023.04.17.02.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 02:27:04 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Caleb Connolly <kc@postmarketos.org>,
        Brian Norris <briannorris@chromium.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/11] PCI: rockchip: Assert PCI Configuration Enable bit after probe
Date:   Mon, 17 Apr 2023 11:26:21 +0200
Message-Id: <20230417092631.347976-4-rick.wertenbroek@gmail.com>
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

Assert PCI Configuration Enable bit after probe. When this bit is left to
0 in the endpoint mode, the RK3399 PCIe endpoint core will generate
configuration request retry status (CRS) messages back to the root complex.
Assert this bit after probe to allow the RK3399 PCIe endpoint core to reply
to configuration requests from the root complex.
This is documented in section 17.5.8.1.2 of the RK3399 TRM.

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 9b835377bd9e..4c84e403e155 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -623,6 +623,8 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 
 	ep->irq_pci_addr = ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR;
 
+	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE, PCIE_CLIENT_CONFIG);
+
 	return 0;
 err_epc_mem_exit:
 	pci_epc_mem_exit(epc);
-- 
2.25.1

