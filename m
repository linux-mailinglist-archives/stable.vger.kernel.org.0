Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA23328A40
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbhCASNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239372AbhCASIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3622164FA0;
        Mon,  1 Mar 2021 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619598;
        bh=dncZgWL8tHOt2jmvReuGmGPWJ5OUscCw7TzvDQUpXCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlRVf02Ia0BccOGbVzmLuU7zZioaIVsoz5C6TrxtyLtm7MSsropt1Zvgol0Y3afYZ
         XeQ2a9FLAuvmFaZutjws9fE1p/B3hNPm73CBPUMfL+vxGQpouhnU/D46b2t5vWp5nr
         WyGlrRfOaFJ+rH/4D4jcQO+atRigGmnqoRimch8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alvin Lee <alvin.lee2@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 512/663] Revert "drm/amd/display: Update NV1x SR latency values"
Date:   Mon,  1 Mar 2021 17:12:40 +0100
Message-Id: <20210301161207.184017291@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 910f1601addae3e430fc7d3cd589d7622c5df693 upstream.

This reverts commit 4a3dea8932d3b1199680d2056dd91d31d94d70b7.

This causes blank screens for some users.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1388
Cc: Alvin Lee <alvin.lee2@amd.com>
Cc: Jun Lei <Jun.Lei@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -408,8 +408,8 @@ static struct _vcs_dpi_soc_bounding_box_
 			},
 		},
 	.num_states = 5,
-	.sr_exit_time_us = 11.6,
-	.sr_enter_plus_exit_time_us = 13.9,
+	.sr_exit_time_us = 8.6,
+	.sr_enter_plus_exit_time_us = 10.9,
 	.urgent_latency_us = 4.0,
 	.urgent_latency_pixel_data_only_us = 4.0,
 	.urgent_latency_pixel_mixed_with_vm_data_us = 4.0,


