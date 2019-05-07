Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5800015AAE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbfEGFk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbfEGFk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D1C205ED;
        Tue,  7 May 2019 05:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207655;
        bh=Gzzi3VsPQoOc0Wwur4Hdr8LUbWfj03H6MpPi4hbh0F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4lBtLKl4Ksp73Unxw5sadISIKdnW2LZCkPBSPV6e9e9D1NeEyS9WGFFjvPAFQy2d
         S2W2d5/+1j6yGoELQWsUOA4xqw3BYN2sYn/63mMdpykmD4AjVt8t0oYHLjvwlUM6wv
         tL/b/95mdizSj/bbyRgRQaVY96vcKw+xXuwfSFS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     KT Liao <kt.liao@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 80/95] Input: elan_i2c - add hardware ID for multiple Lenovo laptops
Date:   Tue,  7 May 2019 01:38:09 -0400
Message-Id: <20190507053826.31622-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KT Liao <kt.liao@emc.com.tw>

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
index 2ce805d31ed1..ad89ba143a0e 100644
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

