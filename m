Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6CF65D9C0
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbjADQ2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240058AbjADQ2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:28:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C1B4437C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FB60B817B7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A57C433EF;
        Wed,  4 Jan 2023 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849659;
        bh=Cp4Xey+5WpKc028XxyYs27sWKy+hn7eJfH7Ol3j+gxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6oWGiS/MdL/etIH3u2Jdb9LXVmJYdp0T6Jdxa3S0q7tS0JZfKiz0TTaxGrmBQXSk
         bK2m/XYj/ILfoFkgrd1DGbDTZ33XWX/mVHUWP6gJa+KVR9FmZSvKLqm9N+97yIrcdj
         CyGwMkobHrJIVQ5iSAjI5++9wVR2weiGgl0aNE3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 175/177] drm/amd/pm: add missing SMU13.0.7 mm_dpm feature mapping
Date:   Wed,  4 Jan 2023 17:07:46 +0100
Message-Id: <20230104160512.979685310@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit e0607c10ebf551a654c3577fc74b4bf5533e1cea upstream.

Without this, the pp_dpm_vclk and pp_dpm_dclk outputs are not with
correct data.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -189,6 +189,8 @@ static struct cmn2asic_mapping smu_v13_0
 	FEA_MAP(MEM_TEMP_READ),
 	FEA_MAP(ATHUB_MMHUB_PG),
 	FEA_MAP(SOC_PCC),
+	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_table_map[SMU_TABLE_COUNT] = {


