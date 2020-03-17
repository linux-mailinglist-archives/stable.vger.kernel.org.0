Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D25518820F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCQLVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbgCQK6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:58:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B55EB20719;
        Tue, 17 Mar 2020 10:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442715;
        bh=Lets9yH3P5twM0NTw/q9oANDVOhsQvUIg2oFpyqIBbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qv8FsQ5Yca+boV+O3wqgax/1Xw84RTFSAj2kvCdvJyzq1FLore9OEIwpyjbMtP5XR
         /aEdbQcNQmgILQpS9GYxnUp6CEhD09qzkRoacvybx/M0iandXuusthF30aVf79xDRj
         jeiND2u6dSL0wcYdkPGTP6EsJ+iAqR5VAVlrrDVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        nobuhiro1.iwamatsu@toshiba.co.jp
Subject: [PATCH 4.19 56/89] drm/amd/display: remove duplicated assignment to grph_obj_type
Date:   Tue, 17 Mar 2020 11:55:05 +0100
Message-Id: <20200317103306.349791002@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit d785476c608c621b345dd9396e8b21e90375cb0e upstream.

Variable grph_obj_type is being assigned twice, one of these is
redundant so remove it.

Addresses-Coverity: ("Evaluation order violation")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -364,8 +364,7 @@ bool amdgpu_atombios_get_connector_info_
 			router.ddc_valid = false;
 			router.cd_valid = false;
 			for (j = 0; j < ((le16_to_cpu(path->usSize) - 8) / 2); j++) {
-				uint8_t grph_obj_type=
-				grph_obj_type =
+				uint8_t grph_obj_type =
 				    (le16_to_cpu(path->usGraphicObjIds[j]) &
 				     OBJECT_TYPE_MASK) >> OBJECT_TYPE_SHIFT;
 


