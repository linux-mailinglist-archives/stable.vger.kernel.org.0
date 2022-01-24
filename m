Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212A349A3D6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368882AbiAYAAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846544AbiAXXQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089DEC07E29E;
        Mon, 24 Jan 2022 11:45:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AFD261574;
        Mon, 24 Jan 2022 19:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C679C340E5;
        Mon, 24 Jan 2022 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053540;
        bh=HIAkzRqMWe56mqAJ9L6yapuAdhj1TTnDOc4KMkX8+Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2gHicUbZaTIestuWESUE+v+3BQYYl/jnDO3y2ccBNaA4aW6kcg1dKQi+sDo+TGle
         fiFZ+j5EH9MPy18T7kOKGJYV5AL9gcBb3aV2PgkSwgsRSXFP22WMbLNG3tuKb++yCl
         vltPmszj59MBgGw6+h7thcj4ezEFEzA5eT7PY7eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aline Santana Cordeiro <alinesantanacordeiro@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/563] media: staging: media: atomisp: pci: Balance braces around conditional statements in file atomisp_cmd.c
Date:   Mon, 24 Jan 2022 19:37:16 +0100
Message-Id: <20220124184026.861147087@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aline Santana Cordeiro <alinesantanacordeiro@gmail.com>

[ Upstream commit 0a016c35a326c6b2f558ede58ff08da7ef1da1a8 ]

Balance braces around conditional statements.
Issue detected by checkpatch.pl.
It happens in if-else statements where one of the commands
uses braces around a block of code and the other command
does not since it has just a single line of code.

Signed-off-by: Aline Santana Cordeiro <alinesantanacordeiro@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/atomisp_cmd.c   | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index 592ea990d4ca4..21cd03f06291d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -1138,9 +1138,10 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 					asd->frame_status[vb->i] =
 					    ATOMISP_FRAME_STATUS_OK;
 				}
-			} else
+			} else {
 				asd->frame_status[vb->i] =
 				    ATOMISP_FRAME_STATUS_OK;
+			}
 		} else {
 			asd->frame_status[vb->i] = ATOMISP_FRAME_STATUS_OK;
 		}
@@ -4945,9 +4946,9 @@ atomisp_try_fmt_file(struct atomisp_device *isp, struct v4l2_format *f)
 
 	depth = get_pixel_depth(pixelformat);
 
-	if (field == V4L2_FIELD_ANY)
+	if (field == V4L2_FIELD_ANY) {
 		field = V4L2_FIELD_NONE;
-	else if (field != V4L2_FIELD_NONE) {
+	} else if (field != V4L2_FIELD_NONE) {
 		dev_err(isp->dev, "Wrong output field\n");
 		return -EINVAL;
 	}
@@ -6587,17 +6588,17 @@ static int atomisp_get_pipe_id(struct atomisp_video_pipe *pipe)
 {
 	struct atomisp_sub_device *asd = pipe->asd;
 
-	if (ATOMISP_USE_YUVPP(asd))
+	if (ATOMISP_USE_YUVPP(asd)) {
 		return IA_CSS_PIPE_ID_YUVPP;
-	else if (asd->vfpp->val == ATOMISP_VFPP_DISABLE_SCALER)
+	} else if (asd->vfpp->val == ATOMISP_VFPP_DISABLE_SCALER) {
 		return IA_CSS_PIPE_ID_VIDEO;
-	else if (asd->vfpp->val == ATOMISP_VFPP_DISABLE_LOWLAT)
+	} else if (asd->vfpp->val == ATOMISP_VFPP_DISABLE_LOWLAT) {
 		return IA_CSS_PIPE_ID_CAPTURE;
-	else if (pipe == &asd->video_out_video_capture)
+	} else if (pipe == &asd->video_out_video_capture) {
 		return IA_CSS_PIPE_ID_VIDEO;
-	else if (pipe == &asd->video_out_vf)
+	} else if (pipe == &asd->video_out_vf) {
 		return IA_CSS_PIPE_ID_CAPTURE;
-	else if (pipe == &asd->video_out_preview) {
+	} else if (pipe == &asd->video_out_preview) {
 		if (asd->run_mode->val == ATOMISP_RUN_MODE_VIDEO)
 			return IA_CSS_PIPE_ID_VIDEO;
 		else
-- 
2.34.1



