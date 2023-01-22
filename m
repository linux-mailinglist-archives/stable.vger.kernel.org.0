Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2FC677005
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjAVP1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjAVP1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689602313A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0690760C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156A0C433D2;
        Sun, 22 Jan 2023 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401256;
        bh=eh9dQx2MdJXKK+RotbNGFFipuOfEOyKfPsykHKGVShE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgfQqoPXb+TrysqKuElyq71gspRCcbqVp6dtBYRDcfnvMfc3mG4m5jNj/jKkwsza2
         5gXwNCRZO9yD0JeItf2X8GbKzF2wlb/jKjYaZiHn3oxQO55P3U+J74V59DL/tKkLSa
         umvcliGbN0lhnD3SsxSUGRY/WkUZ5QGsaFuQ9mdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 170/193] drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11
Date:   Sun, 22 Jan 2023 16:04:59 +0100
Message-Id: <20230122150254.182304700@linuxfoundation.org>
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

commit 16412a94364d1dcebded9217ecb693c9659eaabc upstream.

Add the entry to set the ppt functions for SMU IP v13.0.11.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -585,6 +585,7 @@ static int smu_set_funcs(struct amdgpu_d
 		yellow_carp_set_ppt_funcs(smu);
 		break;
 	case IP_VERSION(13, 0, 4):
+	case IP_VERSION(13, 0, 11):
 		smu_v13_0_4_set_ppt_funcs(smu);
 		break;
 	case IP_VERSION(13, 0, 5):


