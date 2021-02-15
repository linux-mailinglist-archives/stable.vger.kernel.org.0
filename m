Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5746F31BCD0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhBOPgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230200AbhBOPdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B62264EBE;
        Mon, 15 Feb 2021 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403056;
        bh=/3LqPM0LCoTcaibk894DfChi166tK2R/9OPtyhaZIV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOGSggq2O3KvTEDEKdNCjGdElCYcd0stxAOdMi2bs2yzQj9WUXzGW5OT/MIzfa/3x
         j22ToEMiWRqAqFvve3XjBY9J6beqnhb8Kx4JQJUJHLTOzvahVj+zaz6/P5Cf3JQ9Ra
         YUlvAB4Erva2N1FH1Zd6vcZHWkH3c1aDl21gATMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alvin Lee <alvin.lee2@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 011/104] Revert "drm/amd/display: Update NV1x SR latency values"
Date:   Mon, 15 Feb 2021 16:26:24 +0100
Message-Id: <20210215152719.827312798@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit cf050f96e0970a557601953ed7269d07a7885078 upstream.

This reverts commit 4a3dea8932d3b1199680d2056dd91d31d94d70b7.

This causes blank screens for some users.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1482
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
@@ -297,8 +297,8 @@ static struct _vcs_dpi_soc_bounding_box_
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


