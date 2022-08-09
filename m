Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A997258DF15
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344139AbiHISdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345889AbiHISa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:30:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0D93719D;
        Tue,  9 Aug 2022 11:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7CCB81980;
        Tue,  9 Aug 2022 18:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF9CC4347C;
        Tue,  9 Aug 2022 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068504;
        bh=HTT+0szE6QFagNjHa5lguAMblNs0baFDZDBvsdoAhl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUPpAMRve4LWdD39xeItB3K9g1qCuv7kzGiMrxhggJ5IIFJd7X7BV7EcHPe7K84QC
         NWe3GfS+IU8+Jj07ZXZzQ3UpFVyUEi8rWtN8m4H5ZJNV+OMGlqOV0KAin6LFO+Oc76
         r9Nfm6zLFKgJH9UpumnKNGnI4RMfBFYIcO/nqois=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hakan Jansson <hakan.jansson@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.19 11/21] Bluetooth: hci_bcm: Add DT compatible for CYW55572
Date:   Tue,  9 Aug 2022 20:01:03 +0200
Message-Id: <20220809175513.692882027@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hakan Jansson <hakan.jansson@infineon.com>

commit f8cad62002a7699fd05a23b558b980b5a77defe0 upstream.

CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1547,6 +1547,7 @@ static const struct of_device_id bcm_blu
 	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
+	{ .compatible = "infineon,cyw55572-bt" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bcm_bluetooth_of_match);


