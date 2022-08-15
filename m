Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD08594A22
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbiHOXWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346033AbiHOXVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562187E32E;
        Mon, 15 Aug 2022 13:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39D26068D;
        Mon, 15 Aug 2022 20:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1D5C433C1;
        Mon, 15 Aug 2022 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593874;
        bh=3bSndzRHGwDoEIiOezBILBR3x1ANK+Rt3C1uwr4VLqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEkfrXn7iJTxAyccQz0QIc8fWWmulym9qWmhfcNrV6QkAZfMcGgG6piw0h8Hr2bi8
         H9FV0hNNETq2xyiYCydbCWse/tvMYJXKDDr0EniZpj0w63J/BoxRxDyta/D5PMlLMN
         pGvgVqJuamsM821bOj1p8T8cNVLyNr0SmtOztf+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0991/1095] intel_th: pci: Add Raptor Lake-S PCH support
Date:   Mon, 15 Aug 2022 20:06:30 +0200
Message-Id: <20220815180510.102890328@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit 23e2de5826e2fc4dd43e08bab3a2ea1a5338b063 ]

Add support for the Trace Hub in Raptor Lake-S PCH.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 41a31c7f505f..5b6da26f1b63 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -289,6 +289,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7e24),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Raptor Lake-S */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
-- 
2.35.1



