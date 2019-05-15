Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44401F181
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbfEOLSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbfEOLSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CE2420818;
        Wed, 15 May 2019 11:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919132;
        bh=HmAkxD5WGmy/RoY864NLyadG6VXokwA+13jgf0iy0Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHAIw/BW7dd0f+zrYViEALHN/Q0aypX1hdquGm/aaz3+qY4SxhAkJmqm+pf/Ha/st
         YZzr1RQRM3KhN/vvKDLh0XetJEyj5uQoMYQ1aQ4GFJYuxlhvzoaxFMoj7wG/W/AID3
         /xDcyjRW+J1k71nuC+uWsl+EWiDc0rfP+T58qIyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KT Liao <kt.liao@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 079/115] Input: elan_i2c - add hardware ID for multiple Lenovo laptops
Date:   Wed, 15 May 2019 12:55:59 +0200
Message-Id: <20190515090705.130414779@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 738c06d0e4562e0acf9f2c7438a22b2d5afc67aa ]

There are many Lenovo laptops which need elan_i2c support, this patch adds
relevant IDs to the Elan driver so that touchpads are recognized.

Signed-off-by: KT Liao <kt.liao@emc.com.tw>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/input/mouse/elan_i2c_core.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index 2ce805d31ed13..ad89ba143a0e3 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1254,22 +1254,47 @@ static const struct acpi_device_id elan_acpi_id[] = {
 	{ "ELAN0600", 0 },
 	{ "ELAN0601", 0 },
 	{ "ELAN0602", 0 },
+	{ "ELAN0603", 0 },
+	{ "ELAN0604", 0 },
 	{ "ELAN0605", 0 },
+	{ "ELAN0606", 0 },
+	{ "ELAN0607", 0 },
 	{ "ELAN0608", 0 },
 	{ "ELAN0605", 0 },
 	{ "ELAN0609", 0 },
 	{ "ELAN060B", 0 },
 	{ "ELAN060C", 0 },
+	{ "ELAN060F", 0 },
+	{ "ELAN0610", 0 },
 	{ "ELAN0611", 0 },
 	{ "ELAN0612", 0 },
+	{ "ELAN0615", 0 },
+	{ "ELAN0616", 0 },
 	{ "ELAN0617", 0 },
 	{ "ELAN0618", 0 },
+	{ "ELAN0619", 0 },
+	{ "ELAN061A", 0 },
+	{ "ELAN061B", 0 },
 	{ "ELAN061C", 0 },
 	{ "ELAN061D", 0 },
 	{ "ELAN061E", 0 },
+	{ "ELAN061F", 0 },
 	{ "ELAN0620", 0 },
 	{ "ELAN0621", 0 },
 	{ "ELAN0622", 0 },
+	{ "ELAN0623", 0 },
+	{ "ELAN0624", 0 },
+	{ "ELAN0625", 0 },
+	{ "ELAN0626", 0 },
+	{ "ELAN0627", 0 },
+	{ "ELAN0628", 0 },
+	{ "ELAN0629", 0 },
+	{ "ELAN062A", 0 },
+	{ "ELAN062B", 0 },
+	{ "ELAN062C", 0 },
+	{ "ELAN062D", 0 },
+	{ "ELAN0631", 0 },
+	{ "ELAN0632", 0 },
 	{ "ELAN1000", 0 },
 	{ }
 };
-- 
2.20.1



