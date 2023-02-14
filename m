Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD369660D
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjBNOK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbjBNOKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:10:46 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90DE2A141;
        Tue, 14 Feb 2023 06:10:13 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id mc25so3023031ejb.13;
        Tue, 14 Feb 2023 06:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTWPMQ5IkIsp33gvRTV303Woi805qt5LWeJY1A4m9uw=;
        b=iRlk5JA6Owj1tpws1EfuazhlcuU+rLUsxc4gTBtwVUs4Q9lo9qvpvsYcNZJlbZ/JpE
         oK21vzja6sMUmUzIodoZTYUYtdFan5EAlpeMGzSl9AcMHptN4c4s7+PViEkF29SMzUv7
         3GFX025yHPRed6vxvk84JBOK3WfyWoCaZSaG41y9VTxvCV4ani39VSJDzoa3zUjnuC8h
         RIanKdM7Z61smgWoUAhAo9bk8kFPc0zpqgH/ThekupRHUpCa8p2/Mp2LqcoLr3n+RbC5
         jQaGBc2bQEBMq61ascyWWDBrPVkdCATbE+MY6luviuG2Dkx3fvMqKiOHxaI4ubCB/eV7
         qvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTWPMQ5IkIsp33gvRTV303Woi805qt5LWeJY1A4m9uw=;
        b=wUOZ1/HyJunzvX7b2JSyEaS17tFNEdR+IZKqohdMyW9VRysp+uDcGizM/itjpsydLa
         4dT7UJAgtXNFVBmvKJCIhAF4dcLDA39I4JagaoETxhOI49bPURF6Rem32RNqEy8v6t8D
         Ka8ltw+2U0K9FQMv7w/477UnchU2Oxk6CLSbXLj0rm99tFBJUrJs2YqXGmGcciF5aTIp
         LxfyYU2ZOEPDzeq5GpI/x0wyT1vXGHULGbXw/fpbnImE6wONo7ride6b5vk986a4A2dv
         J0Asxq6eIxWRCqkT33Ja8o4d8VB+9h9owyH+trQ6ll7CrepNRFfAd0GfufRp2x0IM2V1
         Jy9g==
X-Gm-Message-State: AO0yUKXThJ5dkTEXAGy/5YmZsP5XwYxFWnw1YVr81v3Iiz94zvQIqyfq
        mEa3NCCWh0Lgkhs8IFX8mY8=
X-Google-Smtp-Source: AK7set9KhVRcL1vkjLJPVGMyilsn5eE+TJWdC9vdzFon7EJF13hwGE1UA2zzRaRP2jZ55wjDvdPiXQ==
X-Received: by 2002:a17:906:2214:b0:8b1:304e:58a7 with SMTP id s20-20020a170906221400b008b1304e58a7mr2092828ejs.56.1676383800712;
        Tue, 14 Feb 2023 06:10:00 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id n11-20020a1709065e0b00b008b13814f804sm332241eju.186.2023.02.14.06.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:10:00 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, rick.wertenbroek@heig-vd.ch,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 3/9] PCI: rockchip: Assert PCI Configuration Enable bit after probe
Date:   Tue, 14 Feb 2023 15:08:51 +0100
Message-Id: <20230214140858.1133292-4-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/pci/controller/pcie-rockchip-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 9b835377b..4c84e403e 100644
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

