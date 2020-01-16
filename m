Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9965313E1A3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAPQq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgAPQqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6108207FF;
        Thu, 16 Jan 2020 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193213;
        bh=63/4FcQxs5o4qvcmFcvglUh0Gy5MM0SzrMmb6gx3iPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TooSHNrTWfdEG46X9NJcl3DdR0zG6tIv+IEy0QK3cHsNPyEN3NW96RU+z8Sp/3i4l
         0zGp2GHwlal8tsBgCOS9opT9YzE//KAFVbtaraJti9J5lgu/dndx5utNZG7fQT5rXY
         kcqFkYi1S6hZrwUrassusW3+GEJ9zBpIQefJAG2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 047/205] iio: imu: st_lsm6dsx: fix gyro gain definitions for LSM9DS1
Date:   Thu, 16 Jan 2020 11:40:22 -0500
Message-Id: <20200116164300.6705-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 1b3751017e09f0857bc38f9b1be08dce38f3d92c ]

Fix typos in gyro gain definitions for LSM9DS1 sensor

Fixes: 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 28e011b35f21..3e0528793d95 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -152,9 +152,10 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 					.addr = 0x10,
 					.mask = GENMASK(4, 3),
 				},
-				.fs_avl[0] = {  IIO_DEGREE_TO_RAD(245), 0x0 },
-				.fs_avl[1] = {  IIO_DEGREE_TO_RAD(500), 0x1 },
-				.fs_avl[2] = { IIO_DEGREE_TO_RAD(2000), 0x3 },
+
+				.fs_avl[0] = {  IIO_DEGREE_TO_RAD(8750), 0x0 },
+				.fs_avl[1] = { IIO_DEGREE_TO_RAD(17500), 0x1 },
+				.fs_avl[2] = { IIO_DEGREE_TO_RAD(70000), 0x3 },
 				.fs_len = 3,
 			},
 		},
-- 
2.20.1

