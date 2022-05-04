Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9B51A8C2
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353010AbiEDRMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356839AbiEDRJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685ED4093D;
        Wed,  4 May 2022 09:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D920A616B8;
        Wed,  4 May 2022 16:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F5CC385A5;
        Wed,  4 May 2022 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683355;
        bh=d9FRUiv783dU/wMy58x9p6NFoSQWCkLOfWCusjCDE3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwYEDfMAnpmRSMr9WUnlvAt0qtEfzua/ETnUm2h9URgMXplw6CP7gV53VYVl0rxtF
         7TTpIf/fJmMFcF/nUbOhzfx4AhIyIAgz0JoIoWr72gW+7ZYjDb64IOIiLBERQoVb2p
         vYtTpk3KOD6v8hmzficbepvVMyeh4UmPTYb93E30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.17 028/225] usb: dwc3: pci: add support for the Intel Meteor Lake-P
Date:   Wed,  4 May 2022 18:44:26 +0200
Message-Id: <20220504153112.808856424@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 973e0f7a847ef13ade840d4c30729ce329a66895 upstream.

This patch adds the necessary PCI IDs for Intel Meteor Lake-P
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220425103518.44028-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -44,6 +44,8 @@
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
+#define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
+#define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
@@ -421,6 +423,12 @@ static const struct pci_device_id dwc3_p
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLP),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 


