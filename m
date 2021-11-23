Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32D745A0E8
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhKWLLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234587AbhKWLLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:11:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E55261055;
        Tue, 23 Nov 2021 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637665673;
        bh=HjzvhTeww5b0ZMEzuJmleHhTrE67WH1pPqzJ1j6up3Q=;
        h=Subject:To:Cc:From:Date:From;
        b=HKWw8xTtmaTB13yuPV7DHjfuPgu19lcgcwSmeqxSF6ChxkvfWjpKN/uYaDCU7QiOX
         icHKd6val4x5XVVV+nUT+qEp+izYF1k8kjex0b9Srd85w1RwhNcuweHPqDcGKrPXOs
         abhaLh+P1NjFNnY3Sg0vRsJcdhj6YLAwECWMGcCA=
Subject: FAILED: patch "[PATCH] drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10" failed to apply to 5.15-stable tree
To:     ernstp@gmail.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:07:50 +0100
Message-ID: <163766567021749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cd54323e762ddda11552ee5258d35a3a7cc5cc0f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ernst=20Sj=C3=B6strand?= <ernstp@gmail.com>
Date: Thu, 2 Sep 2021 09:50:27 +0200
Subject: [PATCH] drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Seems like newer cards can have even more instances now.
Found by UBSAN: array-index-out-of-bounds in
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:318:29
index 8 is out of range for type 'uint32_t *[8]'

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1697
Cc: stable@vger.kernel.org
Signed-off-by: Ernst Sjöstrand <ernstp@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index dc3c6b3a00e5..d356e329e6f8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -758,7 +758,7 @@ enum amd_hw_ip_block_type {
 	MAX_HWIP
 };
 
-#define HWIP_MAX_INSTANCE	8
+#define HWIP_MAX_INSTANCE	10
 
 struct amd_powerplay {
 	void *pp_handle;

