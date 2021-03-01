Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5860F328D69
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhCATKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240840AbhCATGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D7D65187;
        Mon,  1 Mar 2021 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618620;
        bh=9iPuqNfhcg7uoDhboyGdeAcSKpzqX2F9GAQ1uonXyrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPQl+PoPH/mWQ8EDZHzympJZihxOTLQUin68z6oIOB1cW11SSkYeaxF8KoS54f3fY
         JKyt2yfhWEWphmAQB0LlnsV2qPy375SJR3EquKZQmXLi0aF3XhFRpDb9dFqyTGxXN1
         QgbSKfCds7JwJTi9P7HFpiN7zLtwq6MqelOcMErQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Chenyang Li <lichenyang@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/663] drm/amdgpu: Fix macro name _AMDGPU_TRACE_H_ in preprocessor if condition
Date:   Mon,  1 Mar 2021 17:06:42 +0100
Message-Id: <20210301161149.394962244@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index ee9480d14cbc3..86cfb3d55477f 100644
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



