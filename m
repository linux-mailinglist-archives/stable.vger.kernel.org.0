Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747EA2D9EC4
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440683AbgLNSRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502355AbgLNRi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Stanley.Yang" <Stanley.Yang@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 095/105] drm/amdgpu: fix sdma instance fw version and feature version init
Date:   Mon, 14 Dec 2020 18:29:09 +0100
Message-Id: <20201214172559.849852775@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley.Yang <Stanley.Yang@amd.com>

commit 6896887b8676d8fb445c85ea56333b9661a6a8aa upstream.

each sdma instance fw_version and feature_version
should be set right value when asic type isn't
between SIENNA_CICHILD and CHIP_DIMGREY_CAVEFISH

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -183,7 +183,7 @@ static int sdma_v5_2_init_microcode(stru
 			if (err)
 				goto out;
 
-			err = sdma_v5_2_init_inst_ctx(&adev->sdma.instance[0]);
+			err = sdma_v5_2_init_inst_ctx(&adev->sdma.instance[i]);
 			if (err)
 				goto out;
 		}


