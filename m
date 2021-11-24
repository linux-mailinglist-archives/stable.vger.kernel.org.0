Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A417245C608
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351566AbhKXOE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353856AbhKXOCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12BD161A83;
        Wed, 24 Nov 2021 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759428;
        bh=/2Tq6dNpl8t9OkuSU7exCZ9+cBTBzWdwg+I335ELtqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnbX2IEV7so6d1aBDIzk8bYoZHDhIv8OGnacQUHzZITnf9fDQSmrnqLdteBWSNc+X
         m83hMrgKXjwrIK5iDG9e2T9bfQs1LgNeP11IyFZ9jwaU7VjAKmv1skc4GeoiejeyLl
         qGCimYNMriPiOXOM3FwaeHBQxdZu01X5peL0Kf2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, XiangBing Foo <XiangBing.Foo@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Daniel Wheeler <Daniel.Wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 239/279] drm/amd/display: Update swizzle mode enums
Date:   Wed, 24 Nov 2021 12:58:46 +0100
Message-Id: <20211124115726.991024576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <Alvin.Lee2@amd.com>

commit 58065a1e524de30df9a2d8214661d5d7eed0a2d9 upstream.

[Why]
Swizzle mode enum for DC_SW_VAR_R_X was existing,
but not mapped correctly.

[How]
Update mapping and conversion for DC_SW_VAR_R_X.

Reviewed-by: XiangBing Foo <XiangBing.Foo@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <Daniel.Wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c   |    4 +++-
 drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1854,7 +1854,9 @@ static void swizzle_to_dml_params(
 	case DC_SW_VAR_D_X:
 		*sw_mode = dm_sw_var_d_x;
 		break;
-
+	case DC_SW_VAR_R_X:
+		*sw_mode = dm_sw_var_r_x;
+		break;
 	default:
 		ASSERT(0); /* Not supported */
 		break;
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h
@@ -80,11 +80,11 @@ enum dm_swizzle_mode {
 	dm_sw_SPARE_13 = 24,
 	dm_sw_64kb_s_x = 25,
 	dm_sw_64kb_d_x = 26,
-	dm_sw_SPARE_14 = 27,
+	dm_sw_64kb_r_x = 27,
 	dm_sw_SPARE_15 = 28,
 	dm_sw_var_s_x = 29,
 	dm_sw_var_d_x = 30,
-	dm_sw_64kb_r_x,
+	dm_sw_var_r_x = 31,
 	dm_sw_gfx7_2d_thin_l_vp,
 	dm_sw_gfx7_2d_thin_gl,
 };


