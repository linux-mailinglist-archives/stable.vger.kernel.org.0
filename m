Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261B86C55E6
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjCVUB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjCVUBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:01:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A660C6B94C;
        Wed, 22 Mar 2023 12:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F060D62276;
        Wed, 22 Mar 2023 19:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D11DC433EF;
        Wed, 22 Mar 2023 19:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515125;
        bh=h1C3jfAE2PYU/BbEkLJgU+iKGqkKcYmMoviIAYMVqnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4apHamuYY90TtQHxGGC0zWaP6EzaBZ5Lfs8EjBt+rd4z9DHLsn68tDZ0Ht/NAFI5
         YPMwdM9HG1D2zGbsVSNCLxuTRix7WSFR60cP/oWKpaeNUrx8yuUNtkWvjwdmet/XHg
         mnGT+A9yazbrG5sR0ZEm5HrDSZK5K9w+vU30MRQ7IDcpLPYhYR2bP9HCIkMcE7wxAB
         bjn512tYHaNxxZmy+t4FNBAx8P1QuMlw/isSeqy/uYaJ9I3qeLEvp1+16xaOdcWqIg
         uC5Oqm7nU44NRMiSo6vgB1pNtZBAGRgLB52H+W8rSIE6C0lAQaQdSWs+J4A2gx9bvM
         mul0gWFXp4Gtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jane Jian <Jane.Jian@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        danijel.slivka@amd.com, horace.chen@amd.com,
        Felix.Kuehling@amd.com, nathan@kernel.org, Bokun.Zhang@amd.com,
        David.Francis@amd.com, Likun.Gao@amd.com, Hawking.Zhang@amd.com,
        sonny.jiang@amd.com, James.Zhu@amd.com, evan.quan@amd.com,
        tim.huang@amd.com, kenneth.feng@amd.com, Stanley.Yang@amd.com,
        yiqing.yao@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 26/45] drm/amdgpu/vcn: custom video info caps for sriov
Date:   Wed, 22 Mar 2023 15:56:20 -0400
Message-Id: <20230322195639.1995821-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Jian <Jane.Jian@amd.com>

[ Upstream commit d71e38df3b730a17ab6b25cabb2ccfe8a7f04385 ]

for sriov, we added a new flag to indicate av1 support,
this will override the original caps info.

Signed-off-by: Jane Jian <Jane.Jian@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h    |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h |   3 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c          | 103 ++++++++++++++++++--
 3 files changed, 99 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 2b9d806e23afb..10a0a510910b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -123,6 +123,8 @@ enum AMDGIM_FEATURE_FLAG {
 	AMDGIM_FEATURE_PP_ONE_VF = (1 << 4),
 	/* Indirect Reg Access enabled */
 	AMDGIM_FEATURE_INDIRECT_REG_ACCESS = (1 << 5),
+	/* AV1 Support MODE*/
+	AMDGIM_FEATURE_AV1_SUPPORT = (1 << 6),
 };
 
 enum AMDGIM_REG_ACCESS_FLAG {
@@ -321,6 +323,8 @@ static inline bool is_virtual_machine(void)
 	((!amdgpu_in_reset(adev)) && adev->virt.tdr_debug)
 #define amdgpu_sriov_is_normal(adev) \
 	((!amdgpu_in_reset(adev)) && (!adev->virt.tdr_debug))
+#define amdgpu_sriov_is_av1_support(adev) \
+	((adev)->virt.gim_feature & AMDGIM_FEATURE_AV1_SUPPORT)
 bool amdgpu_virt_mmio_blocked(struct amdgpu_device *adev);
 void amdgpu_virt_init_setting(struct amdgpu_device *adev);
 void amdgpu_virt_kiq_reg_write_reg_wait(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
index 6c97148ca0ed3..24d42d24e6a01 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
@@ -93,7 +93,8 @@ union amd_sriov_msg_feature_flags {
 		uint32_t mm_bw_management  : 1;
 		uint32_t pp_one_vf_mode	   : 1;
 		uint32_t reg_indirect_acc  : 1;
-		uint32_t reserved	   : 26;
+		uint32_t av1_support       : 1;
+		uint32_t reserved	   : 25;
 	} flags;
 	uint32_t all;
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 3d938b52178e3..9eedc1a1494c0 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -101,6 +101,59 @@ static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_decode_vcn1 =
 	.codec_array = vcn_4_0_0_video_codecs_decode_array_vcn1,
 };
 
+/* SRIOV SOC21, not const since data is controlled by host */
+static struct amdgpu_video_codec_info sriov_vcn_4_0_0_video_codecs_encode_array_vcn0[] = {
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
+};
+
+static struct amdgpu_video_codec_info sriov_vcn_4_0_0_video_codecs_encode_array_vcn1[] = {
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+};
+
+static struct amdgpu_video_codecs sriov_vcn_4_0_0_video_codecs_encode_vcn0 = {
+	.codec_count = ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_encode_array_vcn0),
+	.codec_array = sriov_vcn_4_0_0_video_codecs_encode_array_vcn0,
+};
+
+static struct amdgpu_video_codecs sriov_vcn_4_0_0_video_codecs_encode_vcn1 = {
+	.codec_count = ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_encode_array_vcn1),
+	.codec_array = sriov_vcn_4_0_0_video_codecs_encode_array_vcn1,
+};
+
+static struct amdgpu_video_codec_info sriov_vcn_4_0_0_video_codecs_decode_array_vcn0[] = {
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
+};
+
+static struct amdgpu_video_codec_info sriov_vcn_4_0_0_video_codecs_decode_array_vcn1[] = {
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
+};
+
+static struct amdgpu_video_codecs sriov_vcn_4_0_0_video_codecs_decode_vcn0 = {
+	.codec_count = ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_decode_array_vcn0),
+	.codec_array = sriov_vcn_4_0_0_video_codecs_decode_array_vcn0,
+};
+
+static struct amdgpu_video_codecs sriov_vcn_4_0_0_video_codecs_decode_vcn1 = {
+	.codec_count = ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_decode_array_vcn1),
+	.codec_array = sriov_vcn_4_0_0_video_codecs_decode_array_vcn1,
+};
+
 static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 				 const struct amdgpu_video_codecs **codecs)
 {
@@ -111,16 +164,31 @@ static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 	case IP_VERSION(4, 0, 0):
 	case IP_VERSION(4, 0, 2):
 	case IP_VERSION(4, 0, 4):
-		if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
-			if (encode)
-				*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;
-			else
-				*codecs = &vcn_4_0_0_video_codecs_decode_vcn1;
+		if (amdgpu_sriov_vf(adev)) {
+			if ((adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) ||
+			!amdgpu_sriov_is_av1_support(adev)) {
+				if (encode)
+					*codecs = &sriov_vcn_4_0_0_video_codecs_encode_vcn1;
+				else
+					*codecs = &sriov_vcn_4_0_0_video_codecs_decode_vcn1;
+			} else {
+				if (encode)
+					*codecs = &sriov_vcn_4_0_0_video_codecs_encode_vcn0;
+				else
+					*codecs = &sriov_vcn_4_0_0_video_codecs_decode_vcn0;
+			}
 		} else {
-			if (encode)
-				*codecs = &vcn_4_0_0_video_codecs_encode_vcn0;
-			else
-				*codecs = &vcn_4_0_0_video_codecs_decode_vcn0;
+			if ((adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0)) {
+				if (encode)
+					*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;
+				else
+					*codecs = &vcn_4_0_0_video_codecs_decode_vcn1;
+			} else {
+				if (encode)
+					*codecs = &vcn_4_0_0_video_codecs_encode_vcn0;
+				else
+					*codecs = &vcn_4_0_0_video_codecs_decode_vcn0;
+			}
 		}
 		return 0;
 	default:
@@ -729,8 +797,23 @@ static int soc21_common_late_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev)) {
 		xgpu_nv_mailbox_get_irq(adev);
+		if ((adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) ||
+		!amdgpu_sriov_is_av1_support(adev)) {
+			amdgpu_virt_update_sriov_video_codec(adev,
+							     sriov_vcn_4_0_0_video_codecs_encode_array_vcn1,
+							     ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_encode_array_vcn1),
+							     sriov_vcn_4_0_0_video_codecs_decode_array_vcn1,
+							     ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_decode_array_vcn1));
+		} else {
+			amdgpu_virt_update_sriov_video_codec(adev,
+							     sriov_vcn_4_0_0_video_codecs_encode_array_vcn0,
+							     ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_encode_array_vcn0),
+							     sriov_vcn_4_0_0_video_codecs_decode_array_vcn0,
+							     ARRAY_SIZE(sriov_vcn_4_0_0_video_codecs_decode_array_vcn0));
+		}
+	}
 
 	return 0;
 }
-- 
2.39.2

