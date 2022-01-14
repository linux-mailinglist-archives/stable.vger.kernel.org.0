Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8203948E5F4
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbiANIWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60012 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240169AbiANIVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B39E61E2D;
        Fri, 14 Jan 2022 08:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEB8C36AE9;
        Fri, 14 Jan 2022 08:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148470;
        bh=7kGEXRNySCmMV6a3X7qpJunA2kbXe/Ib0GFudLPmItc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqJVep2zPJJejGxGeLct3p3xN7nhFIEUmwNDnyhMq96ed8gfYJxPJCCLq/GPjUH36
         Fwl57QtHcYbFp7GdCjstaF+Q+eswJrHeqzIVtlTO1UWLOet5Ebh95wpFF6b5O7MTFe
         khkqTCRIdLT+EnJGe2TYAdNVj3dR5IXxKPGhE1VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.15 27/41] Bluetooth: btbcm: disable read tx power for MacBook Air 8,1 and 8,2
Date:   Fri, 14 Jan 2022 09:16:27 +0100
Message-Id: <20220114081546.059821176@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

commit 3318ae23bbcb14b7f68e9006756ba6d970955635 upstream.

The MacBook Air 8,1 and 8,2 also need querying of LE Tx power
to be disabled for Bluetooth to work.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btbcm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -366,6 +366,18 @@ static const struct dmi_system_id disabl
 	{
 		 .matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,2"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
 		},
 	},


