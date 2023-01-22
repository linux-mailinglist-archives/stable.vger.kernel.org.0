Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185EF677010
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjAVP2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjAVP2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:28:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561E815547
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E54E160C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3649C433D2;
        Sun, 22 Jan 2023 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401285;
        bh=RzSBhXoJ3LqBmNtesx0y8eLwPd53YZ9uxdsaXPGek24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PaBjAjUHvI1RMD3DBsUA54qxFtRJZXcMnHx+RgATKPgBjrWrK+rt2tBN/86UxsX+C
         B/SOkSvAxldj3dp7tcx3NSpWa+E2a7mpjXS4TVTxY4cfb/6JSWSGAybFWBIoHeZIjz
         xp/2OtOr96quJ1iGpQXHKdi6axLIhugQVKNl4jDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zhang <yifan1.zhang@amd.com>,
        Tim Huang <Tim.Huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 180/193] drm/amdgpu: add tmz support for GC 11.0.1
Date:   Sun, 22 Jan 2023 16:05:09 +0100
Message-Id: <20230122150254.652378849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 97074216917b4188f0af3e52cc5b3f2b277bbbca upstream.

this patch to add tmz support for GC 11.0.1.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -548,6 +548,7 @@ void amdgpu_gmc_tmz_set(struct amdgpu_de
 	case IP_VERSION(10, 3, 1):
 	/* YELLOW_CARP*/
 	case IP_VERSION(10, 3, 3):
+	case IP_VERSION(11, 0, 1):
 		/* Don't enable it by default yet.
 		 */
 		if (amdgpu_tmz < 1) {


