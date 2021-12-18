Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9682A47988E
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 05:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhLREWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 23:22:37 -0500
Received: from mx.ucr.edu ([169.235.156.38]:14433 "EHLO mx-lax3-3.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhLREWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Dec 2021 23:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1639801358; x=1671337358;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HiC3hCK63Qa8Qb4loFRgdeRVld94u+OjjR3csxq5Wus=;
  b=QLQHgqTI6bkDefDWD2C0BBhtkErMp/rorsLfgd4hl9Yk0AzFtU/i6ly3
   fazdJYRZZWGiKvpUwLGGSWLFKSMdaEULrMbA/zTaEYz3pUA7amy/6VX8u
   wuHPInHLyZUWaI5ZPN/4DxlMPFwNTKj1YcAoobHgFPv2opsIfs+4bO6sS
   FsHeLb2WKPje4UyPcqqIKt0fRANfZKLmeLltDg4rfxlyj5I0xaY+UbrZB
   V75FCgS0g6saDnj4324e61Xopbej/cpRVPrUcd8pTk3N+Dou4P3Z4rSsf
   SzhA2dHs3Um95YUi24/qmx7JazIhRdpwqf8GFCZbKsXz5nfELgbZ3hy6Y
   w==;
IronPort-SDR: 7HPVGd+51/yN6V0xaeVAFoPme4ti2ZM/k44tcQ23ViQHctTQXwWEQAQGfTvY+f/4CLpmBxdn8C
 RBfr1MhLyT0qxamshIrkOMTsZpZquKkEqi/q52Is1XgYVCe2SgHSbNeNSZiTA9GC/3uh2idSlJ
 PwyMcGqGnpMLZi/9gvnnoiNPvg9hHSfLx0UD7drlgYMnjsoTS4mGqKtYmQfErketCmmbUkQFoh
 2nTFEkWd9I/KIQwOkJmwBy9JfcekZ98wXuL5AAz3xNWf7I2X3fpsCzLnrCRGvQqFgnsedJkafW
 BFa/9NvL8kME7RYSqiJPzkSU
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="95157380"
Received: from mail-qv1-f69.google.com ([209.85.219.69])
  by smtp-lax3-3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2021 20:22:34 -0800
Received: by mail-qv1-f69.google.com with SMTP id ke1-20020a056214300100b003b5a227e98dso4374851qvb.14
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 20:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uFquvFdIStXIJTsPn2k5rBU0qh7wG0l4oiCoU43pQg8=;
        b=bXlm2lS0L1cyH2tSCF4kf3SQ17o+srdPcNuSX0IN5fdxXx90fPQz8j0OTE/DIoDyNG
         NBLMGRGfhKW/vXeGz0RyOrwHJPODREbZxxtNpZqx1FHpckyz9EkMB+GVjII3tzO39jqR
         54F6vn74a8bEU6PVKdMbAqjnZHWPkSh7B94io=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uFquvFdIStXIJTsPn2k5rBU0qh7wG0l4oiCoU43pQg8=;
        b=b7fe6qcU3u4COVBejzEHy3jpZbUcrMeqY6R7Sv56zJlKo9L3A/XbDuLlU491GHJ2sY
         i4RRV/mNiHe2HoKz9OaymWPqvUp2zDB2H/6IY1Ubk8Rzh5E1LZYvH0GYdHYbLEUHclk4
         eWdmcgfbRrG3E1TaGzIXhU2Lm5lqwVKk7FGMPp+aEbb9ueY7kqBEETE5FCRAGZqMtZCW
         HSIZt2O9fi2drz5OPm7bCgwEHDA1kvc+yWHpxpTS75upE0ywKP4mlJdgaZO5ewRDl8T3
         ibAiUoxQosESpr0zBWLg6sL/vn46+uDhsSgjTSQAAzZnVbK1q6BcbXL8Ij8kmosSkg2j
         q0EQ==
X-Gm-Message-State: AOAM531FSVjrqd1BeWKf1IztuwdnNPzU9UYf5RgnZrJwKGAsgOR6HhT3
        cD5bIH5kJy9fnCkN/7YSFLEkfqf3oENW0dSYjUUUPk771wmdlQHnaDPVYpfCY6T4eDJ/BUHaG72
        T/1jgw6F8VjjhRyzviQ==
X-Received: by 2002:a0c:edca:: with SMTP id i10mr5323740qvr.62.1639801351931;
        Fri, 17 Dec 2021 20:22:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyE3Tagh5RgslGVJv/eRvjbgxu42RfzRLSIimsqstN4aB/aqSAgEsFtcF+iB7KjMXViNfFsrg==
X-Received: by 2002:a0c:edca:: with SMTP id i10mr5323738qvr.62.1639801351765;
        Fri, 17 Dec 2021 20:22:31 -0800 (PST)
Received: from kq.cs.ucr.edu (kq.cs.ucr.edu. [169.235.27.223])
        by smtp.googlemail.com with ESMTPSA id s20sm9081682qtc.75.2021.12.17.20.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 20:22:31 -0800 (PST)
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Cc:     Yizhuo Zhai <yzhai003@ucr.edu>, stable@vger.kernel.org,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Wenjing Liu <wenjing.liu@amd.com>, Jun Lei <jun.lei@amd.com>,
        Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Mark Morra <MarkAlbert.Morra@amd.com>,
        Agustin Gutierrez <agustin.gutierrez@amd.com>,
        Robin Singh <robin.singh@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        "Guo, Bing" <Bing.Guo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/amd/display: Fix the uninitialized variable in enable_stream_features()
Date:   Fri, 17 Dec 2021 20:22:23 -0800
Message-Id: <20211218042226.2608212-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In function enable_stream_features(), the variable "old_downspread.raw"
could be uninitialized if core_link_read_dpcd() fails, however, it is
used in the later if statement, and further, core_link_write_dpcd()
may write random value, which is potentially unsafe.

Fixes: 6016cd9dba0f ("drm/amd/display: add helper for enabling mst stream features")
Cc: stable@vger.kernel.org
Signed-off-by: Yizhuo Zhai <yzhai003@ucr.edu>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index c8457babfdea..fd5a0e7eb029 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1844,6 +1844,8 @@ static void enable_stream_features(struct pipe_ctx *pipe_ctx)
 		union down_spread_ctrl old_downspread;
 		union down_spread_ctrl new_downspread;
 
+		memset(&old_downspread, 0, sizeof(old_downspread));
+
 		core_link_read_dpcd(link, DP_DOWNSPREAD_CTRL,
 				&old_downspread.raw, sizeof(old_downspread));
 
-- 
2.25.1

