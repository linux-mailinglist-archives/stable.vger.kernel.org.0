Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6C32ABB0E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733245AbgKINUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387865AbgKINT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C4822202;
        Mon,  9 Nov 2020 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927998;
        bh=QWILWw3uduJMwg1IruDSh68vr7n5hC4u0TKvvMqB1fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQ9ldaj1xTZlPqrx2/xoeN+b/ZTTD/R/BbSDwYSfsqGoSLbfaqbSviyXWPsP7YVIf
         FJV2DMollImUvQlpWSkOAybSYrtCUHu2lGnJvhDcpylDd5N6vMyMJEjRZlBxwgkVAv
         qJPmvEP+qp8V+VLTBR5Ni5kPyUMg/dpqBZ6AWDgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        "Tianci.Yin" <tianci.yin@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 091/133] drm/amdgpu: add DID for navi10 blockchain SKU
Date:   Mon,  9 Nov 2020 13:55:53 +0100
Message-Id: <20201109125035.079485033@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianci.Yin <tianci.yin@amd.com>

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
index 321032d3a51a2..06a5b6ae1c43e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1033,6 +1033,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x7319, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	{0x1002, 0x731A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	{0x1002, 0x731B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
+	{0x1002, 0x731E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	{0x1002, 0x731F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI10},
 	/* Navi14 */
 	{0x1002, 0x7340, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI14},
-- 
2.27.0



