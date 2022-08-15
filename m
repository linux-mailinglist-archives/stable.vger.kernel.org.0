Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA57594BFB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241012AbiHPAwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241861AbiHPAuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6F6198ED6;
        Mon, 15 Aug 2022 13:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E242661239;
        Mon, 15 Aug 2022 20:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE57EC433C1;
        Mon, 15 Aug 2022 20:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596379;
        bh=jDaLYORDZLE16hR4HAETjjaA730kH0CcJg5oji5pRxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwroGvs7JHPgCMhGu7bI2/CXFuA+knFG/vSK/bGKXjqsGXrszMn+NdO/IdTAxQ0H1
         5dGq+75pL8In3x6lgBCnoM5iW6dESxg1LFvYS0FRLdNHyNZU7/RlPAATf4PuMF/7Wt
         QECB7uabctA8iUqWbaPxKEeJ5eLQz1c7VKv2Yb+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1062/1157] intel_th: pci: Add Raptor Lake-S CPU support
Date:   Mon, 15 Aug 2022 20:06:58 +0200
Message-Id: <20220815180522.545406270@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit ff46a601afc5a66a81c3945b83d0a2caeb88e8bc ]

Add support for the Trace Hub in Raptor Lake-S CPU.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-7-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -295,6 +295,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Raptor Lake-S CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa76f),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


