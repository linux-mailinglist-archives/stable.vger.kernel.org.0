Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4C46215E0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiKHOQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiKHOQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AB869DE3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E6C3B81B05
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ACCC433D6;
        Tue,  8 Nov 2022 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916981;
        bh=eQ9yCyPCFwm9kR2sZlq4gUh/4cxS7IrE3MaAV7yGYwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19MmXEdSW58J5GoSUBfbYOoDboYFRFXCYqicEMy9AxxL5e7VqfgmM5Exn/ufGyKNP
         qm9jxvJksku5scVprewffL22cF2ncZ0jr6LUxoUf8Qbn304n4AFnnGHOH3GBJIKa6X
         J0kqZHa03AkCNR0Xxi0cn1LAkWhUdcRo9Aun3hn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 193/197] drm/amd/display: Update latencies on DCN321
Date:   Tue,  8 Nov 2022 14:40:31 +0100
Message-Id: <20221108133403.623782569@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

commit c580d758ba1b79de9ea7a475d95a6278736ae462 upstream.

Update DF related latencies based on new measurements.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -119,15 +119,15 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 		},
 	},
 	.num_states = 1,
-	.sr_exit_time_us = 12.36,
-	.sr_enter_plus_exit_time_us = 16.72,
+	.sr_exit_time_us = 19.95,
+	.sr_enter_plus_exit_time_us = 24.36,
 	.sr_exit_z8_time_us = 285.0,
 	.sr_enter_plus_exit_z8_time_us = 320,
 	.writeback_latency_us = 12.0,
 	.round_trip_ping_latency_dcfclk_cycles = 263,
-	.urgent_latency_pixel_data_only_us = 4.0,
-	.urgent_latency_pixel_mixed_with_vm_data_us = 4.0,
-	.urgent_latency_vm_data_only_us = 4.0,
+	.urgent_latency_pixel_data_only_us = 9.35,
+	.urgent_latency_pixel_mixed_with_vm_data_us = 9.35,
+	.urgent_latency_vm_data_only_us = 9.35,
 	.fclk_change_latency_us = 20,
 	.usr_retraining_latency_us = 2,
 	.smn_latency_us = 2,


