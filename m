Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CC060455A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJSMda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiJSMdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:33:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3511781CB;
        Wed, 19 Oct 2022 05:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF02BCE217C;
        Wed, 19 Oct 2022 09:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05B1C433D6;
        Wed, 19 Oct 2022 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170993;
        bh=9hn852ZhM0EfVIh1DYObpQhwk4metOXndls0I/VbDLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8bhC0POKDhJ9dC9gNSPCOB68ypQXcgpDimi7myfkrxm6h/qVAYozCpAFHOXxyrNn
         vcIRss6bSFwdy/jyA97Fkm4z7o0uxEkYURq5G8+5I7IZslvnLYk5waCvnDsJaeRE5v
         72Lr7QOlNdz2cfDWIZePBfSckoyk0bfowk72iN7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Wang <Yao.Wang1@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Aric Cyr <aric.cyr@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 853/862] Revert "drm/amd/display: correct hostvm flag"
Date:   Wed, 19 Oct 2022 10:35:40 +0200
Message-Id: <20221019083327.553350539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
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
@@ -891,7 +891,7 @@ static const struct dc_debug_options deb
 	.optimize_edp_link_rate = true,
 	.enable_sw_cntl_psr = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
+	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {


