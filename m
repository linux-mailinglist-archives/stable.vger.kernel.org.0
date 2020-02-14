Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE8115F0BC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgBNR5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387715AbgBNP5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6CB24680;
        Fri, 14 Feb 2020 15:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695839;
        bh=cF0AFVHw8PPABmHKwcOZG09O4STfsB3xpXfX9/LrqXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiJwFP896GAemQYnfSH2NfPgJOs7MZ23MZlmIGAPHs3w2GdwTa1heaWu+skv+nHH4
         VLq5wDcqjrCUyZeKwxgDFbRjE3lK+6GPrMhSwm+pohQnu2Env/EYK6Sksh55G9kR+D
         /GUaj3pHrZAJY8xKbkgaYbk4NHefc4UHVbrnTHSk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jun Lei <Jun.Lei@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 390/542] drm/amd/display: fixup DML dependencies
Date:   Fri, 14 Feb 2020 10:46:22 -0500
Message-Id: <20200214154854.6746-390-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Lei <Jun.Lei@amd.com>

[ Upstream commit 34ad0230062c39cdcba564d16d122c0fb467a7d6 ]

[why]
Need to fix DML portability issues to enable SW unit testing around DML

[how]
Move calcs into dc include folder since multiple components reference it
Remove relative paths to external dependencies

Signed-off-by: Jun Lei <Jun.Lei@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c          | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h          | 2 +-
 drivers/gpu/drm/amd/display/dc/{calcs => inc}/dcn_calc_math.h | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/gpu/drm/amd/display/dc/{calcs => inc}/dcn_calc_math.h (100%)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c b/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c
index b953b02a15121..723af0b2dda04 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c
@@ -24,7 +24,7 @@
  */
 
 #include "dml_common_defs.h"
-#include "../calcs/dcn_calc_math.h"
+#include "dcn_calc_math.h"
 
 #include "dml_inline_defs.h"
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h b/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
index eca140da13d82..ded71ea82413d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
@@ -27,7 +27,7 @@
 #define __DML_INLINE_DEFS_H__
 
 #include "dml_common_defs.h"
-#include "../calcs/dcn_calc_math.h"
+#include "dcn_calc_math.h"
 #include "dml_logger.h"
 
 static inline double dml_min(double a, double b)
diff --git a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.h b/drivers/gpu/drm/amd/display/dc/inc/dcn_calc_math.h
similarity index 100%
rename from drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.h
rename to drivers/gpu/drm/amd/display/dc/inc/dcn_calc_math.h
-- 
2.20.1

