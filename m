Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1FF191D2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEITAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfEISv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70DD6217D7;
        Thu,  9 May 2019 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427888;
        bh=TMZ6zPgSlmugN5V2TsBStkTQ1fYYai4lrVnTOz3IRrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kj3KMbVi8W/m1/uBF9N6M+l4LISiL4HydCM5Uyh0iqxkVRIl1N2JIf9yiXfiERbLE
         h5rMzkKIkegYIgzme/6nqST+nocQWDY2EXzPRItF7/oQjMPJozBatLrKKVksRQaSJy
         9bw20gRCVsHJGvs1HWICVxiVwf1+uFRuEAJZRDZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 42/95] drm/amdkfd: Add picasso pci id
Date:   Thu,  9 May 2019 20:41:59 +0200
Message-Id: <20190509181312.345494066@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e7ad88553aa1d48e950ca9a4934d246c1bee4be4 ]

Picasso is a new raven variant.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 8be9677c0c07d..cf9a49f49d3a4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -320,6 +320,7 @@ static const struct kfd_deviceid supported_devices[] = {
 	{ 0x9876, &carrizo_device_info },	/* Carrizo */
 	{ 0x9877, &carrizo_device_info },	/* Carrizo */
 	{ 0x15DD, &raven_device_info },		/* Raven */
+	{ 0x15D8, &raven_device_info },		/* Raven */
 #endif
 	{ 0x67A0, &hawaii_device_info },	/* Hawaii */
 	{ 0x67A1, &hawaii_device_info },	/* Hawaii */
-- 
2.20.1



