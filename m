Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320A4304AB8
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbhAZE6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730660AbhAYSt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF9E22460;
        Mon, 25 Jan 2021 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600556;
        bh=8NmroIXwyEPKeQya12VtiDZxyxXxVV+r8YuVfqTFcwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMp1afZmHYUxXHP6fj8x7UYgs5hC5IPfxoii79yqxwL4B2ZD/tWXCT3fC1muk1SO+
         pohK1GJ6EZSiy0Oi13lLhyVNci2l6qzyzE+dKrcjjsoSuSNBa0t/37maMMMAEDsmZP
         Rd8HehuZyYu12UY760iYiACagJncJgL67h91fe88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 030/199] drm/amdgpu: remove gpu info firmware of green sardine
Date:   Mon, 25 Jan 2021 19:37:32 +0100
Message-Id: <20210125183217.526949343@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

commit acc214bfafbafcd29d5d25d1ede5f11c14ffc147 upstream.

The ip discovery is supported on green sardine, it doesn't need gpu info
firmware anymore.

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -80,7 +80,6 @@ MODULE_FIRMWARE("amdgpu/renoir_gpu_info.
 MODULE_FIRMWARE("amdgpu/navi10_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi14_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
-MODULE_FIRMWARE("amdgpu/green_sardine_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 


