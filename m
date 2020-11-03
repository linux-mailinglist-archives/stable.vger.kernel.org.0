Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD252A529B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgKCUv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731962AbgKCUv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127C62053B;
        Tue,  3 Nov 2020 20:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436685;
        bh=7kmNv4SiTGTm1wSPyzRwsQK/+GujU6foFuRTCmedvnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StHAN0R73C3OoJB7aJXG8PJD7vD/FuEAoOoHefG9KUffs/eIMVo1Brwrsb/2CUwMa
         EMEsSkYoDQTUV8p5KdEwU7kCqzDyxYQ4Nf95blyn5Ina1Svr1mKIJvBzOnpodMJx43
         hgbu6ItuA2l9PRgmDdjlkUi4LR9NUsHvj1wB1cLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 359/391] drm/amd/swsmu: add missing feature map for sienna_cichlid
Date:   Tue,  3 Nov 2020 21:36:50 +0100
Message-Id: <20201103203411.360376799@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

commit d48d7484d8dca1d4577fc53f1f826e68420d00eb upstream.

it will cause smu sysfs node of "pp_features" show error.

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/amd/powerplay/inc/smu_types.h      |    1 +
 drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
@@ -217,6 +217,7 @@ enum smu_clk_type {
        __SMU_DUMMY_MAP(DPM_MP0CLK),                    	\
        __SMU_DUMMY_MAP(DPM_LINK),                      	\
        __SMU_DUMMY_MAP(DPM_DCEFCLK),                   	\
+       __SMU_DUMMY_MAP(DPM_XGMI),			\
        __SMU_DUMMY_MAP(DS_GFXCLK),                     	\
        __SMU_DUMMY_MAP(DS_SOCCLK),                     	\
        __SMU_DUMMY_MAP(DS_LCLK),                       	\
--- a/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
@@ -150,14 +150,17 @@ static struct cmn2asic_mapping sienna_ci
 	FEA_MAP(DPM_GFXCLK),
 	FEA_MAP(DPM_GFX_GPO),
 	FEA_MAP(DPM_UCLK),
+	FEA_MAP(DPM_FCLK),
 	FEA_MAP(DPM_SOCCLK),
 	FEA_MAP(DPM_MP0CLK),
 	FEA_MAP(DPM_LINK),
 	FEA_MAP(DPM_DCEFCLK),
+	FEA_MAP(DPM_XGMI),
 	FEA_MAP(MEM_VDDCI_SCALING),
 	FEA_MAP(MEM_MVDD_SCALING),
 	FEA_MAP(DS_GFXCLK),
 	FEA_MAP(DS_SOCCLK),
+	FEA_MAP(DS_FCLK),
 	FEA_MAP(DS_LCLK),
 	FEA_MAP(DS_DCEFCLK),
 	FEA_MAP(DS_UCLK),


