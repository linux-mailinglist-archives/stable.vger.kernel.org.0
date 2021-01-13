Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DA52F4E7A
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAMPY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 10:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbhAMPY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 10:24:57 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7330C061786
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 07:24:16 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c14so1314728qtn.0
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 07:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G6oe8P4Cun9SiL0t1L9XuoXsNwtXDQqzA/hUUXLRRy8=;
        b=k0FptLBrQ0lIrlPQ5SAAtOS3q1vC7iY4EO1FME5ovzI4Bi6paNTwjqWQDOFVoEFfCa
         ljMbMdpecfgmwjh1gQpDo9qiTS7edrD024lHSpkspbXWJAacFpTebbl465b0lANcy/ek
         CakqOxpW9opeRKq65OtWwmTw7Lxe/7wgNQpWiagvQhTj9uOPYDDYcQ4hsnNlbzMxIyr3
         IG+rpgPXS6eWAvzZ2L4Kc/0aTe6wKaBL5C+vTn9fLRbOpSNM2K37tG722PiLtLfRQIjo
         IAgpMvbOmBHrWUkYypk/S6MBYUzt5mSNDMJZAww9LxHDOZiqSSBfqAa3XKvX30SmaC8D
         L7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G6oe8P4Cun9SiL0t1L9XuoXsNwtXDQqzA/hUUXLRRy8=;
        b=X5y4ZfWKgPlFHhiTbBPFAQDYVWzQ6r06F8Dwyxc1BE27hWns/ZwikMsPJ6cPo2NiB3
         QagdT0k8ky6WbatO4SupfzLFnBsLKvKxEl6nbURe6/hCWZNv3ePoKi/8r5DxkIMgDeZJ
         ir5vMqsclAsOa4iGfN5lbf/P6SWi6Vuu7zI734ymEmGunXC4ZElv7tGrPvQVlPLLXnMw
         O3/FXy+bSGS8s0GHj11VGBWh76HIxCNcMfLPXVgYeWM9JPUgT0lq/yrJD15CmBRZHOEH
         8/h5E09xFeEo6DCL1IysFBqlLqXG2CT33W+xuZnBuNvgdgIaqB8QiFycB89KjwcHg+Dd
         Twhg==
X-Gm-Message-State: AOAM532YHYmiLlUZB4phCnOGz0EoX9tA9eGfRSy4i4U7uS3yuJnp/TDf
        lctMwHHO0m7h50PfgiL3+OyuYJDvRzY=
X-Google-Smtp-Source: ABdhPJxAugt1k2AHmUlmKMWOdManzJZpZwnQ2YiX+5vGVLEkJjOfkdz9Yi1d5QhWSVWb7Euy2alyBA==
X-Received: by 2002:ac8:6d05:: with SMTP id o5mr2862002qtt.6.1610551455992;
        Wed, 13 Jan 2021 07:24:15 -0800 (PST)
Received: from localhost.localdomain ([192.161.78.241])
        by smtp.gmail.com with ESMTPSA id i3sm1159827qkd.119.2021.01.13.07.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 07:24:15 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/amdgpu: add green_sardine device id (v2)
Date:   Wed, 13 Jan 2021 10:24:03 -0500
Message-Id: <20210113152404.1307212-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

Add green_sardine PCI id support and map it to renoir asic type.

v2: add apu flag

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index cac2724e7615..6a402d8b5573 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1085,6 +1085,7 @@ static const struct pci_device_id pciidlist[] = {
 
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},
-- 
2.29.2

