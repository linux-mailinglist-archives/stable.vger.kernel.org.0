Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656693CE467
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347737AbhGSPnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347839AbhGSPjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EE9B613F1;
        Mon, 19 Jul 2021 16:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711556;
        bh=QtPEqdfQOScgFynDx1d1MBk/zWmMI0Fptn7UuC7rYXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/XyOVkMTdAAIgzPhhmSJ2FCWgbJHFYoHVgUjX2qPBicKy++1RBhcJHoHw5sJ+Oqz
         zNOAktx5vcjH14156wrxOppsTo6VTefa5K0oJS2mC8Mv9liM6XMPrYGjCeQOtleqEQ
         heUbBtXao2zRNQm825O7gKFBrv3926LWIioiVYrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinzhou Su <Jinzhou.Su@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 014/292] drm/amdgpu: add another Renoir DID
Date:   Mon, 19 Jul 2021 16:51:16 +0200
Message-Id: <20210719144942.997909650@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinzhou Su <Jinzhou.Su@amd.com>

commit 775da83005cb61d4c213c636df9337da05714ff1 upstream.

Add new PCI device id.

Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1092,6 +1092,7 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x734F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI14},
 
 	/* Renoir */
+	{0x1002, 0x15E7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 	{0x1002, 0x164C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},


