Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C274124E1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381618AbhITSiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380297AbhITSgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5486761406;
        Mon, 20 Sep 2021 17:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158963;
        bh=T7SIofURIVF3X4OIUNNKYwN8beYr8BiPk7L0p0U2Lig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzL82nYD4a0FzoF3L2rABXMQeyQXfd8D9F0XJ6ZM5M2tBPQfpeKZK1Zx6uUoNfHu0
         T2LQg/tXK6X7Ps9Cb/hCMB41tqD3veo+4TMuTxtEwHqG2IVCoDEyEaocu6OLpE58Kw
         5O97jG/fqmAHl/g8s+M4L5QvM7xkKIB4/F5AxQfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ernst=20Sj=C3=B6strand?= <ernstp@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 014/168] drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10
Date:   Mon, 20 Sep 2021 18:42:32 +0200
Message-Id: <20210920163922.119271099@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -757,7 +757,7 @@ enum amd_hw_ip_block_type {
 	MAX_HWIP
 };
 
-#define HWIP_MAX_INSTANCE	8
+#define HWIP_MAX_INSTANCE	10
 
 struct amd_powerplay {
 	void *pp_handle;


