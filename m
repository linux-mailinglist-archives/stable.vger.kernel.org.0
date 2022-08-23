Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87D59DA56
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352292AbiHWKHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352783AbiHWKGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E141706D;
        Tue, 23 Aug 2022 01:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D057D611DD;
        Tue, 23 Aug 2022 08:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA989C433D6;
        Tue, 23 Aug 2022 08:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244777;
        bh=xTE+WIlYlbFUxAgf1adSZ4BmPtJbzXnhoxEqVKDjqtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2redC4PLBOIMzkRDTcs/nC3Fycya5j5+h708IY+xIazAajYT/rWDf8+K6Qv+gOmHf
         hnX8xJPlIrgtXgf7O037qCgmphJSQpBrYzPBZywoXGf/LQmu3zeHlBVw29RMhDIXVj
         VQF+EgCnXZkGlqNwRpAfRUTldR+teIP9WbPpg7wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.14 160/229] intel_th: pci: Add Raptor Lake-S PCH support
Date:   Tue, 23 Aug 2022 10:25:21 +0200
Message-Id: <20220823080059.391832934@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 23e2de5826e2fc4dd43e08bab3a2ea1a5338b063 upstream.

Add support for the Trace Hub in Raptor Lake-S PCH.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -259,6 +259,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Raptor Lake-S */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


