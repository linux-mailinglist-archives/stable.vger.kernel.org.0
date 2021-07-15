Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0013CA94D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhGOTGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242638AbhGOTFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 290636141D;
        Thu, 15 Jul 2021 19:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375675;
        bh=mTUfbD5MVl4Nd0GYhQMLHXk0Dpo6nGARDrZOMGB3n4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guB3YOYwNjV/tu7O6WrH5O0tkYV2A8Mn4NodgFSgK3+eAEKgCLPzWPvwFBFrzXc9p
         u/AbGQxM+P4/5LPT3EsMSN8KCJIUHSY8kepG+bWkzhNKa2VG1jijk0CxqnVp54+3we
         NnArspZshiKlhXYMy32mg0YzPnpea/wmyWK2I188=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 161/242] drm/amdgpu: add new dimgrey cavefish DID
Date:   Thu, 15 Jul 2021 20:38:43 +0200
Message-Id: <20210715182621.475616609@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 06ac9b6c736ac9da600b1782d7ac6d6e746286c4 upstream.

Add new PCI device id.

Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1123,6 +1123,7 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x73E0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
 	{0x1002, 0x73E1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
 	{0x1002, 0x73E2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
+	{0x1002, 0x73E3, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
 	{0x1002, 0x73FF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
 
 	{0, 0, 0}


