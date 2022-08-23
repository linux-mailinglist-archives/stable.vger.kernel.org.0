Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD69B59D93D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350830AbiHWJct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351304AbiHWJbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3259B2CC88;
        Tue, 23 Aug 2022 01:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D51B161530;
        Tue, 23 Aug 2022 08:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46BDC433D6;
        Tue, 23 Aug 2022 08:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243847;
        bh=7oHLfdxUfI49xPBE6W9NwDX0o2JYr7uHVpkexMqKnlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hn2eEI2pTRjWZpUrLnKHwGaRnX4973R1Mwa/ORNn6RzS2r3h58d8i1j9xJ9le8g/b
         7B7vYEVrHWmrZ+4/lRAFdvh4ohYV2uEezXc3p0U9HZpq0C+o4IKF7kXgCBi4WVjppe
         c+HMbAnUzkfuEghNZcMDp+cNWZ3FBYL7yqeVJpbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 033/229] PCI: Add defines for normal and subtractive PCI bridges
Date:   Tue, 23 Aug 2022 10:23:14 +0200
Message-Id: <20220823080054.708220842@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pali Rohár <pali@kernel.org>

commit 904b10fb189cc15376e9bfce1ef0282e68b0b004 upstream.

Add these PCI class codes to pci_ids.h:

  PCI_CLASS_BRIDGE_PCI_NORMAL
  PCI_CLASS_BRIDGE_PCI_SUBTRACTIVE

Use these defines in all kernel code for describing PCI class codes for
normal and subtractive PCI bridges.

[bhelgaas: similar change in pci-mvebu.c]
Link: https://lore.kernel.org/r/20220214114109.26809-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>a
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
[ gregkh - take only the pci_ids.h portion for stable backports ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -59,6 +59,8 @@
 #define PCI_CLASS_BRIDGE_EISA		0x0602
 #define PCI_CLASS_BRIDGE_MC		0x0603
 #define PCI_CLASS_BRIDGE_PCI		0x0604
+#define PCI_CLASS_BRIDGE_PCI_NORMAL		0x060400
+#define PCI_CLASS_BRIDGE_PCI_SUBTRACTIVE	0x060401
 #define PCI_CLASS_BRIDGE_PCMCIA		0x0605
 #define PCI_CLASS_BRIDGE_NUBUS		0x0606
 #define PCI_CLASS_BRIDGE_CARDBUS	0x0607


