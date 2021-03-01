Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A68632866D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhCARKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236430AbhCARED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:04:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6CF64F43;
        Mon,  1 Mar 2021 16:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616735;
        bh=uR4f3vgveoyAMQixU9XiNcIvMiRtKl98VOTLkSCI7OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tb7Jas6MGBhjo0SyTKvtmMrrS1Fi9LsDLSZH6yoXiqbayxSElRnpxyFe2efcCp+vV
         5oemQLtA/GF2r05cBYI7fvoz/6TnHEVf8fW2ytPF1LKcfEyns2dx8wizVzJ5R4A13f
         CKz0pDO8ZmwnFxZ9Co/ojOIDoNQ81/s/wnQ+P60A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Chenyang Li <lichenyang@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/247] drm/amdgpu: Fix macro name _AMDGPU_TRACE_H_ in preprocessor if condition
Date:   Mon,  1 Mar 2021 17:11:37 +0100
Message-Id: <20210301161035.460602125@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenyang Li <lichenyang@loongson.cn>

[ Upstream commit 956e20eb0fbb206e5e795539db5469db099715c8 ]

Add an underscore in amdgpu_trace.h line 24 "_AMDGPU_TRACE_H".

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Chenyang Li <lichenyang@loongson.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
index 7206a0025b17a..db9907fb99f3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
@@ -21,7 +21,7 @@
  *
  */
 
-#if !defined(_AMDGPU_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#if !defined(_AMDGPU_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
 #define _AMDGPU_TRACE_H_
 
 #include <linux/stringify.h>
-- 
2.27.0



