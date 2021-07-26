Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A33D626F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbhGZPgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236400AbhGZPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A23460240;
        Mon, 26 Jul 2021 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316154;
        bh=l08SUBo51MVM2dJAcmjaw26ROihC7LMRdgYhw6xgxn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZE9CI+w9ECHPddD/AMqQx73YXuC0PV9BtjcSlBdD9K9BKHlg7ilA36CReVlWJGZ1L
         DZgJVXSSv0M/vRPAwb98gAfrh2WSO89Jjb55R3ak7HEu2dZVSlKy8WzHWP6SaF0bkg
         XrIsbW8INY+LkrtE3w2xkNWKBkXFKe6EHFXLpDgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Zhou <tao.zhou1@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 210/223] drm/amdgpu: update gc golden setting for dimgrey_cavefish
Date:   Mon, 26 Jul 2021 17:40:02 +0200
Message-Id: <20210726153853.056214074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Zhou <tao.zhou1@amd.com>

commit cfe4e8f00f8f19ba305800f64962d1949ab5d4ca upstream.

Update gc_10_3_4 golden setting.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3411,6 +3411,7 @@ static const struct soc15_reg_golden gol
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_PERFCOUNTER7_SELECT, 0xf0f001ff, 0x00000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_PERFCOUNTER8_SELECT, 0xf0f001ff, 0x00000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_PERFCOUNTER9_SELECT, 0xf0f001ff, 0x00000000),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSX_DEBUG_1, 0x00010000, 0x00010020),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmTA_CNTL_AUX, 0x01030000, 0x01030000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmUTCL1_CTRL, 0x03a00000, 0x00a00000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmLDS_CONFIG,  0x00000020, 0x00000020)


