Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C785E5053E1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbiDRNBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241167AbiDRM60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6591824F38;
        Mon, 18 Apr 2022 05:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFCBBB80EDE;
        Mon, 18 Apr 2022 12:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F886C385A7;
        Mon, 18 Apr 2022 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285521;
        bh=tGzXzQhqgL+alx1Q6zWeqj7q4zL1AuwH2it+jAec/5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4FlZjJbZgcFdBn2/PUQwNgCwdnn2lScEjyzvfs3ZPUGf6noUFNz5R2rO+1RT3IAw
         BPFqsN7XVo8cAl3JKbXU3xlwHvoCJiYIPkch7bkrMWXVX0OXbXWZqOZ4QwtnFpkOTd
         MPgDye1cPpdagF81JjSFJLrha8imZ/6mEsYG4CWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/105] drm/amd: Add USBC connector ID
Date:   Mon, 18 Apr 2022 14:12:44 +0200
Message-Id: <20220418121147.673400790@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit c5c948aa894a831f96fccd025e47186b1ee41615 ]

[Why&How] Add a dedicated AMDGPU specific ID for use with
newer ASICs that support USB-C output

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/ObjectID.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/ObjectID.h b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
index 5b393622f592..a0f0a17e224f 100644
--- a/drivers/gpu/drm/amd/amdgpu/ObjectID.h
+++ b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
@@ -119,6 +119,7 @@
 #define CONNECTOR_OBJECT_ID_eDP                   0x14
 #define CONNECTOR_OBJECT_ID_MXM                   0x15
 #define CONNECTOR_OBJECT_ID_LVDS_eDP              0x16
+#define CONNECTOR_OBJECT_ID_USBC                  0x17
 
 /* deleted */
 
-- 
2.35.1



