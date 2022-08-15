Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041FF594776
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353471AbiHOXWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbiHOXS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:18:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4852C149A13;
        Mon, 15 Aug 2022 13:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5029C61089;
        Mon, 15 Aug 2022 20:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58577C433C1;
        Mon, 15 Aug 2022 20:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593828;
        bh=ideHvfhDE9wq+JxMMdoFAQuD3viIDQ424rCtYQY44JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzptm9vIqJVsnS/M10s6MsU9i4++YBWGEumq3Ci8SMvz+i3TlJqUFYMHiWkJcvH4+
         R4OhK4vph0N27YJRV59YCnm/DRiZT54EZ7FhIbEY+qW/nuQBX0DzgVv3RHeNJVC0FP
         2YL8DRyaY50toeDhMg7NYGuca4IRFlfDZ9w00GgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0990/1095] intel_th: pci: Add Meteor Lake-P support
Date:   Mon, 15 Aug 2022 20:06:29 +0200
Message-Id: <20220815180510.065201774@linuxfoundation.org>
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

[ Upstream commit 802a9a0b1d91274ef10d9fe429b4cc1e8c200aef ]

Add support for the Trace Hub in Meteor Lake-P.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index fcd0aca75007..41a31c7f505f 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -284,6 +284,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x54a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Meteor Lake-P */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7e24),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
-- 
2.35.1



