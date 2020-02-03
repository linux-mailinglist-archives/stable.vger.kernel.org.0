Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD0150D5D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgBCQnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbgBCQcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:32 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF14217BA;
        Mon,  3 Feb 2020 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747551;
        bh=12HEvJehZ/Jgk+eTbKkqViC4hFoUbZr3wcNHfpAyxPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8Yww1F5DHXheUdO8E/+YGLdsuPFA/w7YZpHAHR4YWviTYKfBcDd/45Z5ONERkT7M
         AyMnCZbDOQjWvdDDZj+EghTAP5GGjVpCCN27XDTi5WI/DePp+Y3uWrqZbPgHVUmxjP
         +m1sYBVPZxDrgXdibBqWeSzCB7Hb6Va44LzKLP00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/70] qmi_wwan: Add support for Quectel RM500Q
Date:   Mon,  3 Feb 2020 16:19:52 +0000
Message-Id: <20200203161918.199502280@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

[ Upstream commit a9ff44f0e61d074f29770413fef6a5452be7b83e ]

RM500Q is a 5G module from Quectel, supporting both standalone and
non-standalone modes. The normal Quectel quirks apply (DTR and dynamic
interface numbers).

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b55fd76348f9f..13c8788e3b6b2 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -999,6 +999,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
 	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
-- 
2.20.1



