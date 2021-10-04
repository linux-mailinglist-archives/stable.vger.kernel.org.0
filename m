Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF3420FBB
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhJDNhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237925AbhJDNf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AB0963238;
        Mon,  4 Oct 2021 13:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353363;
        bh=bX9+0K4FaEhhgzXzbjcY3vmFtTRQQnhZ8+ABCRCoxsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHzYT/a5IkkrhnGV/1Z+489xv2vQE60sRacOrTjXXDl1utBRdplqsffMMfl2rNzty
         BICP2S7Y43CD6eTVYPItXeLjxgEGj+y+3ZJoPi2ys54ZK5bo/BJeTHxpxnDUfBe1CC
         bMPqjz7OgDlgdjLbGEhqH0HDE/5WbcC8OPSRMgnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Josip Pavic <Josip.Pavic@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 067/172] drm/amd/display: initialize backlight_ramping_override to false
Date:   Mon,  4 Oct 2021 14:51:57 +0200
Message-Id: <20211004125047.154908306@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josip Pavic <Josip.Pavic@amd.com>

commit 467a51b69d0828887fb1b6719159a6b16da688f8 upstream.

[Why]
Stack variable params.backlight_ramping_override is uninitialized, so it
contains junk data

[How]
Initialize the variable to false

Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1724,6 +1724,7 @@ static int dm_late_init(void *handle)
 		linear_lut[i] = 0xFFFF * i / 15;
 
 	params.set = 0;
+	params.backlight_ramping_override = false;
 	params.backlight_ramping_start = 0xCCCC;
 	params.backlight_ramping_reduction = 0xCCCCCCCC;
 	params.backlight_lut_array_size = 16;


