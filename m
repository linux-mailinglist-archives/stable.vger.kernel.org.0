Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFABE2FA424
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393184AbhARPHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390423AbhARLl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F2C221EC;
        Mon, 18 Jan 2021 11:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970103;
        bh=eoeN956v6gl2uTqaz4xFxRX2HSsvn4vWeldRg81tQtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHhJxNU1B++dxyi/SxpIipk0v69Ehuh5mkGqab0wBL0UppI2NoLiuXbjguPoAD5wy
         wV+6OKbEkP51+1IIoN2gbY75pg1uGgLV1uFac4fbOlWrxCeZ6L2q+mk2eaNDJyWqQC
         dH7FDvhxZETIUN0t+8N0GYWxLK1k04mkOwyVaTX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.10 008/152] drm/amdgpu: add green_sardine device id (v2)
Date:   Mon, 18 Jan 2021 12:33:03 +0100
Message-Id: <20210118113353.164932945@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit 21702c8cae51535e09b91341a069503c6ef3d2a3 upstream.

Add green_sardine PCI id support and map it to renoir asic type.

v2: add apu flag

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1076,6 +1076,7 @@ static const struct pci_device_id pciidl
 
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},


