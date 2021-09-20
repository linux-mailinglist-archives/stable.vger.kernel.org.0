Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C684123EA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377671AbhITS2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378758AbhITS0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C14632CD;
        Mon, 20 Sep 2021 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158730;
        bh=fbMyY/4KGBdq5dALuZ3wWpG73aHr5JeVlSKLDkNfDKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXlfVNH0PtSLOj1fAIdyFej6qdlFzXK7h1Yd1U/P4UbCn6ngF2Rj6OwBm9rkKKHGJ
         AVd6HFjkdIu7Shf6teFgMg5YE742Ky1P5IXfEqpFlwUEbURjX5giDYRc3rFR6BRbQh
         Mxz2htQdUwRiixHXAh42kV855dYacyDOUMplRKIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ernst=20Sj=C3=B6strand?= <ernstp@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 009/122] drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10
Date:   Mon, 20 Sep 2021 18:43:01 +0200
Message-Id: <20210920163916.071405631@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernst Sjöstrand <ernstp@gmail.com>

commit 67a44e659888569a133a8f858c8230e9d7aad1d5 upstream.

Seems like newer cards can have even more instances now.
Found by UBSAN: array-index-out-of-bounds in
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:318:29
index 8 is out of range for type 'uint32_t *[8]'

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1697
Cc: stable@vger.kernel.org
Signed-off-by: Ernst Sjöstrand <ernstp@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -717,7 +717,7 @@ enum amd_hw_ip_block_type {
 	MAX_HWIP
 };
 
-#define HWIP_MAX_INSTANCE	8
+#define HWIP_MAX_INSTANCE	10
 
 struct amd_powerplay {
 	void *pp_handle;


