Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A99C13FD64
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgAPXZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387467AbgAPXZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623B02077C;
        Thu, 16 Jan 2020 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217117;
        bh=lxi8UicBoiMwTp0Kha7H9trLUAbDNsUYIP4CD6rmsPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8dvpa2GydcCB3StGkq1SNO2tJ/G1If8rSSEOngBFiTJ0/4gu2EXr5NSqupJzR6T/
         PSnebXQcQAUU8fYJhrYxHKzhjGuSUPc7Mx9ajdCKgizEs1+E86PGwG2QakybRFd+Zx
         lNuw5wJ4sdzI/jaGMRrJVWknD2XLgOg/BVh0X/JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 155/203] media: cedrus: Use correct H264 8x8 scaling list
Date:   Fri, 17 Jan 2020 00:17:52 +0100
Message-Id: <20200116231758.372108707@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

commit a6b8feae7c88343212686120740cf7551dd16e08 upstream.

Documentation now defines the expected order of scaling lists,
change to use correct indices.

Fixes: 6eb9b758e307 ("media: cedrus: Add H264 decoding support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
@@ -244,8 +244,8 @@ static void cedrus_write_scaling_lists(s
 			       sizeof(scaling->scaling_list_8x8[0]));
 
 	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_1,
-			       scaling->scaling_list_8x8[3],
-			       sizeof(scaling->scaling_list_8x8[3]));
+			       scaling->scaling_list_8x8[1],
+			       sizeof(scaling->scaling_list_8x8[1]));
 
 	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_4x4,
 			       scaling->scaling_list_4x4,


