Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36103608B4E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJVKLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiJVKLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:11:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE464F38B;
        Sat, 22 Oct 2022 02:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ED8EB82E3E;
        Sat, 22 Oct 2022 08:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCA2C433C1;
        Sat, 22 Oct 2022 08:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426056;
        bh=9mM2KpCgp5FXSp4BZ4kUo6ES9NP7bd+VPnmOcTLJj00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPltwl0rFoBeJl7KTDysQAmbtDBpOWSCtIzUDG7/5GnZBLg6LcsYw1qqzQpZCtvMP
         cUEsrWkKgd7SKLJJkRznJIawSVdDhksXJb+B5EM11TVDCne/bW9vZKkKKfzyfwZrAq
         OFWA7MOvuBL5qVsIc45Kl07oKB0nGmqjrp8ms8CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Wang <Yao.Wang1@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Aric Cyr <aric.cyr@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 704/717] Revert "drm/amd/display: correct hostvm flag"
Date:   Sat, 22 Oct 2022 09:29:43 +0200
Message-Id: <20221022072529.586530106@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

commit 96ab3cb3b0f862308a03046d01d66c7b4154846b upstream.

This reverts commit 796d6a37ff5ffaf9f2dc0f3f4bf9f4a1034c00de.

4K144 resolution isn't available on DCN31.

Reviewed-by: Sherry Wang <Yao.Wang1@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -892,7 +892,7 @@ static const struct dc_debug_options deb
 	.enable_sw_cntl_psr = true,
 	.apply_vendor_specific_lttpr_wa = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
+	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {


