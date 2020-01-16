Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADD713FFA2
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAPXYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgAPXYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959A72075B;
        Thu, 16 Jan 2020 23:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217045;
        bh=R+bh719d9Q5QgI+sWO+6UqYdpo93I4kzyTiicq2nTvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYerBByNzbQ7wmc5JiVfgatCjMb3pylkShw9pj4qNft/YkFRhlJM9yMpAJYrCdEht
         yn6yGhdQjR3eB0NjLmiNP/I1OpkDdGvi9mOZeBlhh/txM4Lx69la+6xfRaggF/190G
         yOZcTVYPOe9g3dGvd6drZ1odIy0zmA1dDtaoF8MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 109/203] iio: imu: st_lsm6dsx: fix gyro gain definitions for LSM9DS1
Date:   Fri, 17 Jan 2020 00:17:06 +0100
Message-Id: <20200116231755.033009357@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 1b3751017e09f0857bc38f9b1be08dce38f3d92c upstream.

Fix typos in gyro gain definitions for LSM9DS1 sensor

Fixes: 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -152,9 +152,10 @@ static const struct st_lsm6dsx_settings
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


