Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9AC13FF20
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbgAPX1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389786AbgAPX1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA6B20684;
        Thu, 16 Jan 2020 23:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217224;
        bh=YY2vsOhOD5tx230oh8e2361TtBk7nItWViDntducFIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcQPEDwOEQ7i2KoOiLEHsIeD0Z1v4n5Ks/Kx4NAefbhlaz6+ciBtVG/NppoVzh+5K
         u+STGlyWkWggy1lDBZSo897TSlEm+WMgGHQMrvHzyiPgiklCdPFI9Kg0yccpPCUH0W
         fIrFsfLo8cWFsqR9ZufYRQX2zF5hF6Yq6BS4LCA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/203] media: intel-ipu3: Align struct ipu3_uapi_awb_fr_config_s to 32 bytes
Date:   Fri, 17 Jan 2020 00:18:36 +0100
Message-Id: <20200116231801.506393848@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit ce644cf3fa06504c2c71ab1b794160d54aaccbc0 ]

A struct that needs to be aligned to 32 bytes has a size of 28. Increase
the size to 32.

This makes elements of arrays of this struct aligned to 32 as well, and
other structs where members are aligned to 32 mixing
ipu3_uapi_awb_fr_config_s as well as other types.

Fixes: commit dca5ef2aa1e6 ("media: staging/intel-ipu3: remove the unnecessary compiler flags")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/include/intel-ipu3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index c7cd27efac8a..0b1cb9f9cbd1 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -449,7 +449,7 @@ struct ipu3_uapi_awb_fr_config_s {
 	__u16 reserved1;
 	__u32 bayer_sign;
 	__u8 bayer_nf;
-	__u8 reserved2[3];
+	__u8 reserved2[7];
 } __attribute__((aligned(32))) __packed;
 
 /**
-- 
2.20.1



