Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D75549963
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbiFMQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 12:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242639AbiFMQ6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 12:58:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB681BE150;
        Mon, 13 Jun 2022 04:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCBC2B80ECD;
        Mon, 13 Jun 2022 11:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A1C34114;
        Mon, 13 Jun 2022 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121143;
        bh=zLwGP0JHz18RrqK8aoEs9PBVqjjKIkNSSPITEh8DSxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2+VQNERt8Gx6nXffv3s2gWUBVUKEVtp/R23KNno8ZXML6RZiP9n0yiX4iqJi5fyb
         TgzwZqALYnwDeo7ctzd8YsWnupNytiPkDAkBHx+SUjidtw4wFmS/PUbslEDgudez6m
         iYOM7fVr2sbwY3p+Jy2+OtXgnu+T8fdE40pdv2/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.17 287/298] drm/amdgpu: update VCN codec support for Yellow Carp
Date:   Mon, 13 Jun 2022 12:13:01 +0200
Message-Id: <20220613094933.784461500@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 97e50305542f384741a5b45699aba349fe9fca73 upstream.

Supports AV1.  Mesa already has support for this and
doesn't rely on the kernel caps for yellow carp, so
this was already working from an application perspective.

Fixes: 554398174d98 ("amdgpu/nv.c - Added video codec support for Yellow Carp")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2002
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -170,6 +170,7 @@ static const struct amdgpu_video_codec_i
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codecs yc_video_codecs_decode = {


