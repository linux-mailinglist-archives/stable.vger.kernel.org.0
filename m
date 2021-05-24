Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29E538EE75
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhEXPu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234071AbhEXPs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D70B61483;
        Mon, 24 May 2021 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870640;
        bh=LEfSqMjJgZCv6ZwSTW4fO5N37l/PmX+RzxLwdfcuLPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSXSU16INBuV6hDvQuq/s0X0J3fN3u9d18E8wZOc7L/ZX2uK/CB1QuM985Uz3xxB7
         DiHtdRD2smvzOBD3XKs6ugwLgFaYSi+WryU7NoRilUpPmKAnG4t+21YtURsudm2QyK
         aqLNZSOUmoZHOSvP3vdOfB+MBIXqOzbfBfku59v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 39/71] drm/amdgpu: update sdma golden setting for Navi12
Date:   Mon, 24 May 2021 17:25:45 +0200
Message-Id: <20210524152327.741325101@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

commit 77194d8642dd4cb7ea8ced77bfaea55610574c38 upstream.

Current golden setting is out of date.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -100,6 +100,10 @@ static const struct soc15_reg_golden gol
 
 static const struct soc15_reg_golden golden_settings_sdma_nv12[] = {
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSDMA0_RLC3_RB_WPTR_POLL_CNTL, 0xfffffff7, 0x00403000),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSDMA0_GB_ADDR_CONFIG, 0x001877ff, 0x00000044),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSDMA0_GB_ADDR_CONFIG_READ, 0x001877ff, 0x00000044),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSDMA1_GB_ADDR_CONFIG, 0x001877ff, 0x00000044),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSDMA1_GB_ADDR_CONFIG_READ, 0x001877ff, 0x00000044),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSDMA1_RLC3_RB_WPTR_POLL_CNTL, 0xfffffff7, 0x00403000),
 };
 


