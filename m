Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34BEEDE5
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390639AbfKDWLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390622AbfKDWLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:09 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 447FD2084D;
        Mon,  4 Nov 2019 22:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905468;
        bh=ogYgWkFbujCwYrRN5QGPEQxOjsFJtOVpEHkNH94O13M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbRCQHz+B7oHM24OPsmTowuCCNrAXHzcJpsZeJzHEbD5nIONw0UBpYVHGkwwVhfPj
         Ucg6NpVXIgIQA8+JV/PQribOlqxfOE1Mom6s3SX6YNLeagCnAiV4XMFSg9koY3azOB
         gJ4J2Gy3ClXjT8tDgaXibC5mbK25qRK7iQnrfHjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feifei Xu <Feifei.Xu@amd.com>,
        "Tianci.Yin" <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 139/163] drm/amdgpu/gfx10: update gfx golden settings
Date:   Mon,  4 Nov 2019 22:45:29 +0100
Message-Id: <20191104212150.410463228@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianci.Yin <tianci.yin@amd.com>

commit f52ebe1f888dfae68d7cffabf5ac898f8cb64fb3 upstream.

update registers: mmCGTT_SPI_CLK_CTRL

Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Tianci.Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -67,7 +67,7 @@ static const struct soc15_reg_golden gol
 {
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCB_HW_CONTROL_4, 0xffffffff, 0x00400014),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_CPF_CLK_CTRL, 0xfcff8fff, 0xf8000100),
-	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SPI_CLK_CTRL, 0xc0000000, 0xc0000100),
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SPI_CLK_CTRL, 0xcd000000, 0x0d000100),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SQ_CLK_CTRL, 0x60000ff0, 0x60000100),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_SQG_CLK_CTRL, 0x40000000, 0x40000100),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmCGTT_VGT_CLK_CTRL, 0xffff8fff, 0xffff8100),


