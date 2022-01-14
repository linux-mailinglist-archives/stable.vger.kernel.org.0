Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0383E48E63D
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiANIZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:25:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34084 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbiANIWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80331B82436;
        Fri, 14 Jan 2022 08:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914E4C36AEA;
        Fri, 14 Jan 2022 08:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148564;
        bh=2umMD07aAb2cIL1bLIQ6obfEYTptUCgi0c5F3wOPRv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zh11WJ0elAB8iKAxDRTQidNyFn0UBMr7wtS+feLGnTyOuMSDY7TXWTnbBpvfkHhR6
         HamoB0/NDKjLsNlZvgWM/ZJCLa7hRAdMnUxeAozHFuklyGHF9Fahh6ImF31H+qFNW7
         2jiZT7/mGK8zJ/jTszOuKE4DmR59qdxCRQGMFoQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.16 08/37] Bluetooth: btusb: enable Mediatek to support AOSP extension
Date:   Fri, 14 Jan 2022 09:16:22 +0100
Message-Id: <20220114081545.135045434@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: mark-yw.chen <mark-yw.chen@mediatek.com>

commit 28491d7ef4af471841e454f8c1f77384f93c6fef upstream.

This patch enables AOSP extension for Mediatek Chip (MT7921 & MT7922).

Signed-off-by: mark-yw.chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2884,6 +2884,7 @@ static int btusb_mtk_setup(struct hci_de
 		}
 
 		hci_set_msft_opcode(hdev, 0xFD30);
+		hci_set_aosp_capable(hdev);
 		goto done;
 	default:
 		bt_dev_err(hdev, "Unsupported hardware variant (%08x)",


