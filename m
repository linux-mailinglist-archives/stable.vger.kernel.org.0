Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853D148E5A4
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiANIT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbiANITf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:19:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55704C0613E5;
        Fri, 14 Jan 2022 00:19:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FDC7B82436;
        Fri, 14 Jan 2022 08:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5077FC36AE9;
        Fri, 14 Jan 2022 08:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148368;
        bh=/HzMlIO/lVsRC60BZw0AIy2OfdnGqzptletOqeUm+Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACZ8y7alLW3815Zo1X2w6zEo9EUX/idRAlHtMgRT/H8VyFMRHdA637k+rDQHkYii6
         uFszvBOGfL3Jmj9o+MZYUnaqRGwCh2k596+pKISMZAaUA//ChTZPqfvjzx66q6cI9l
         MGyTYi7RigFj5tbD3VQDUWTnW5jI0m9NCBZvDbWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.15 10/41] Bluetooth: btusb: enable Mediatek to support AOSP extension
Date:   Fri, 14 Jan 2022 09:16:10 +0100
Message-Id: <20220114081545.507226490@linuxfoundation.org>
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
@@ -2843,6 +2843,7 @@ static int btusb_mtk_setup(struct hci_de
 		}
 
 		hci_set_msft_opcode(hdev, 0xFD30);
+		hci_set_aosp_capable(hdev);
 		goto done;
 	default:
 		bt_dev_err(hdev, "Unsupported hardware variant (%08x)",


