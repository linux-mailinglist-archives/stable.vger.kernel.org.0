Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99912D45AC
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgLIPnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgLIPnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:43:11 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1BBC0613D6
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 07:42:31 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id j26so1073200qtq.8
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 07:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PXx3JQucEDxFpN8n5rcA/XbHDNM0wJUFLGIsR1DXFk4=;
        b=XaEeBuX0YRCKBmEembAkf7SL7OHtsxaYT1idMNmNe/4VBiIYldcVKgvc0YYSqApeN5
         rjYS9Tc/t/6J7Ugxdw1a/5gD4ti3i+a7lDMeXq/evnbkFhVh7VuqF1HVr1FvOW2VNF0E
         JmGaZq6igy90dT2l0/rc10doPl/7swleEmwTTbuylWl1rUd/zxSo7N8ZlguCBbYsiq0M
         G3DeimrKkVaWar6j9pHU97Kov7MekMDYtSz4zaJPj4jrsy/4zKlZpaenORWfIIs9uG8U
         BHTvFYMDnlSb3Ony2gkpwlVhv5dExK7UGdPnPE9OpHllhUI35TeKi9F+h6pnBCFkzRei
         1MPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PXx3JQucEDxFpN8n5rcA/XbHDNM0wJUFLGIsR1DXFk4=;
        b=Yfa/VxF8UzHkpfwSDcIcnAZ6DcR09PLfTmOVwbuYA3jDDcpG0jtRJAqVE0yU+B8ycX
         FCjggOxNm3/sfn3eSIR+zw+TEPpf1wTmfHnzoyGTb7h+F17oW8lLIU4vVLgEwYbynYb4
         a+rjdYymHgxh72aBAuSATg2Gi21jIn4Xcn1TIEDD0AP6u0Mw5UDefH3tEb/lseKxVJX5
         Ow0gTEuV2m9XQGdmazoV1rKY6lE8l8nY0eToRSBdpwnDE19ipoAev22Kcts2DOTU5Zjm
         2KDAVTh08rMkeerARH8CeI7VE0NqzFOJrJhKgORpv52RRvXg3/S0xQ5HmiUK/j7bUfcW
         MoLA==
X-Gm-Message-State: AOAM531ltfg1Dk3bjBa1TKTrmiOuHUq/m9ann/ZCJ+NgAaw/8kJAlt7l
        xlqcxYxo0zAi/EVOx9D6PFP6sEtKr1w=
X-Google-Smtp-Source: ABdhPJyp/EyAocrMus88/lbxUhZcS1q8U3Uoi03SN/pytbMBP3QcALG0x6R+U4wuGmby9VC7Ln8F9g==
X-Received: by 2002:aed:3c42:: with SMTP id u2mr3590283qte.159.1607528550494;
        Wed, 09 Dec 2020 07:42:30 -0800 (PST)
Received: from localhost.localdomain ([192.161.78.5])
        by smtp.gmail.com with ESMTPSA id n2sm1273204qkf.37.2020.12.09.07.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 07:42:29 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH] Revert "amd/amdgpu: Disable VCN DPG mode for Picasso"
Date:   Wed,  9 Dec 2020 10:42:22 -0500
Message-Id: <20201209154222.1069043-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch should not have been applied to stable.  It depends
on changes in newer drivers.

This reverts commit 756fec062e4b823bbbe10b95cbcfa84f948131c6.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1402
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 254ab2ada70a..c28ebf41530a 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1220,7 +1220,8 @@ static int soc15_common_early_init(void *handle)
 
 			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
 				AMD_PG_SUPPORT_MMHUB |
-				AMD_PG_SUPPORT_VCN;
+				AMD_PG_SUPPORT_VCN |
+				AMD_PG_SUPPORT_VCN_DPG;
 		} else {
 			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |
 				AMD_CG_SUPPORT_GFX_MGLS |
-- 
2.25.4

