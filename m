Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FBBB202E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389506AbfIMNRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390080AbfIMNRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:35 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B309D20717;
        Fri, 13 Sep 2019 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380655;
        bh=kOe/e8wj5K6DSrfsbugwq5GyIY6FAwrp96RMEEC7K1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ey41CePeDEMmnrAXsI3quA5wCpqgOYNZu0SqseexKdklZsbN/UtbnVZr981zxkhq8
         dKGkUtmoo9o0XWPKyegmdMNfmNqcIJ2XzPFIo0ueoafU7gHq3GX3pns1LcDIT4zK9N
         HX0LfP8rkqnP/KnbVDbKlF7oKg6i9Cmb6UyQUEFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.rg, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/190] drm/amdkfd: Add missing Polaris10 ID
Date:   Fri, 13 Sep 2019 14:06:30 +0100
Message-Id: <20190913130610.768254465@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0a5a9c276c335870a1cecc4f02b76d6d6f663c8b ]

This was added to amdgpu but was missed in amdkfd

Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.rg
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 5aba50f63ac6f..938d0053a8208 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -310,6 +310,7 @@ static const struct kfd_deviceid supported_devices[] = {
 	{ 0x67CF, &polaris10_device_info },	/* Polaris10 */
 	{ 0x67D0, &polaris10_vf_device_info },	/* Polaris10 vf*/
 	{ 0x67DF, &polaris10_device_info },	/* Polaris10 */
+	{ 0x6FDF, &polaris10_device_info },	/* Polaris10 */
 	{ 0x67E0, &polaris11_device_info },	/* Polaris11 */
 	{ 0x67E1, &polaris11_device_info },	/* Polaris11 */
 	{ 0x67E3, &polaris11_device_info },	/* Polaris11 */
-- 
2.20.1



