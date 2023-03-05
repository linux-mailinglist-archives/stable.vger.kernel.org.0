Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAE96AB075
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCEN4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCENzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:55:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35111196AB;
        Sun,  5 Mar 2023 05:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1650F60B21;
        Sun,  5 Mar 2023 13:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D090DC4339E;
        Sun,  5 Mar 2023 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024507;
        bh=YkW9XORc0MfYV6vPpLp/i6aNbNW4yluMnk6Tg9u2gsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZfi9rKag+GtSxrKa6wA73p3/HPR2CY31V+kqX2Ex76fX2xx/L9UV9avoYG4eB3Po
         /AvTe1psdNN4U2gsnkDscTPrKmPHy2gf2FfMbAVHSbbLG3CCjRKP/532wrIliHRc7g
         Q4KQauCMgVKUeTPqOFyAjQlO7qcYGJAGtkzuJb4mwX5dGaF22nC62Ir3U58aOLMCif
         duQ3WKq/kvK1jQQLa0Dw7dBEmYYZG5ZwOmB8SkgSbWvIWAuQOgl3EyXSCSW4UOjuN+
         tMyWQQyWiaUjhXzo2c1t52vGwydlndl4jT3wRyVs0lGF+CydPQbyJnE6sV4nhzT2vR
         2hiLuS9ZU+J3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/7] PCI: Add SolidRun vendor ID
Date:   Sun,  5 Mar 2023 08:54:47 -0500
Message-Id: <20230305135449.1794083-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135449.1794083-1-sashal@kernel.org>
References: <20230305135449.1794083-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvaro Karsz <alvaro.karsz@solid-run.com>

[ Upstream commit db6c4dee4c104f50ed163af71c53bfdb878a8318 ]

Add SolidRun vendor ID to pci_ids.h

The vendor ID is used in 2 different source files, the SNET vDPA driver
and PCI quirks.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Message-Id: <20230110165638.123745-2-alvaro.karsz@solid-run.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 526d423740eb2..3cde3050ef518 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3104,6 +3104,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
-- 
2.39.2

