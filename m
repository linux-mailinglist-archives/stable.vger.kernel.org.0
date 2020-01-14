Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B9C13A5D3
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgANKDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgANKDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887FF2465B;
        Tue, 14 Jan 2020 10:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996228;
        bh=DntZkKp3PJnO/KUHNr3qll8+eCoE39ra9aEggD3z8uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzhtFqLuSrTCLCBVfeiXh8S90Xy+if9qLn3WvWFNus3vuQNUNK//OnzAvHXUg2vut
         QBueU5SERTVH4/5uhN9u68PjdrDXnwhuygFVxU6ZSqRK2t9KUqdXDEotVgBmQitjI2
         yl02HFzLR8WgPyUP9TuAqDUO/ib5lppHERJMxt+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunming Zhou <david1.zhou@amd.com>,
        Flora Cui <Flora.Cui@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 24/78] drm/amdgpu: add DRIVER_SYNCOBJ_TIMELINE to amdgpu
Date:   Tue, 14 Jan 2020 11:00:58 +0100
Message-Id: <20200114094356.995503791@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunming Zhou <david1.zhou@amd.com>

commit db4ff423cd1659580e541a2d4363342f15c14230 upstream.

Can expose it now that the khronos has exposed the
vlk extension.

Signed-off-by: Chunming Zhou <david1.zhou@amd.com>
Reviewed-by: Flora Cui <Flora.Cui@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1422,7 +1422,8 @@ static struct drm_driver kms_driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_ATOMIC |
 	    DRIVER_GEM |
-	    DRIVER_RENDER | DRIVER_MODESET | DRIVER_SYNCOBJ,
+	    DRIVER_RENDER | DRIVER_MODESET | DRIVER_SYNCOBJ |
+	    DRIVER_SYNCOBJ_TIMELINE,
 	.load = amdgpu_driver_load_kms,
 	.open = amdgpu_driver_open_kms,
 	.postclose = amdgpu_driver_postclose_kms,


