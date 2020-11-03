Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA12A396E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgKCBZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgKCBTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA44222B9;
        Tue,  3 Nov 2020 01:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366394;
        bh=f1GRbt55qiif67QZPihpz2cm6/Q8TPfTlQf37UMm5B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dK579iD4jNTPmpEGs9qwZT3x+LX4uyF1TFvTlFGEz41vD1fzHWI6jevgr2yMYV4tv
         0LtplW5GNLnulrtXNDBJH6IDxG4M9sLnAVzjilJzTKV97qLHzloA99tbTWcMuwYMlY
         mcXe+5x2fEz7Pulb9FjPgg27W/J1wM93OdIhcyY4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tianci.Yin" <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 19/29] drm/amdgpu: add DID for navi10 blockchain SKU
Date:   Mon,  2 Nov 2020 20:19:18 -0500
Message-Id: <20201103011928.183145-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tianci.Yin" <tianci.yin@amd.com>

[ Upstream commit 8942881144a7365143f196f5eafed24783a424a3 ]

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Tianci.Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index d73924e35a57e..92844ba2c9c4e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1016,6 +1016,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x7319, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	{0x1002, 0x731A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	{0x1002, 0x731B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
+	{0x1002, 0x731E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	{0x1002, 0x731F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	/* Navi14 */
 	{0x1002, 0x7340, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI14},
-- 
2.27.0

