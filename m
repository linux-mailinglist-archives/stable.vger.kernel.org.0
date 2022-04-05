Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DF64F2F17
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbiDEI5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242277AbiDEIhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0A51C928;
        Tue,  5 Apr 2022 01:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AABB260FF5;
        Tue,  5 Apr 2022 08:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75C9C385A0;
        Tue,  5 Apr 2022 08:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147556;
        bh=JAcNIEr1LPWrk+L53Ncmi4AbV1sJxXCTFWiNjxRRQuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpkoPBDob5ySX1D74Kb+uQIQrtrFKO6+3b2e2YjHOXO86aRTJJMm7bH0gCWCHHVYe
         0FLixkoiZjJXZ8EqxH5p1M+QGcRaUUgOIsd1bGkFaXMEc46NcMHp3wQdn6djIJRgx+
         nTIYdvGJvxLJZGLqZ7EkUhSKdhwPQSZYev+MCLDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.16 0039/1017] mei: me: add Alder Lake N device id.
Date:   Tue,  5 Apr 2022 09:15:52 +0200
Message-Id: <20220405070355.339716085@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 7bbbd0845818cffa9fa8ccfe52fa1cad58e7e4f2 upstream.

Add Alder Lake N device ID.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20220301071115.96145-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -107,6 +107,7 @@
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
 #define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
+#define MEI_DEV_ID_ADP_N      0x54E0  /* Alder Lake Point N */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -113,6 +113,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


