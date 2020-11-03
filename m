Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37DE2A4A4B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKCPrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:47:12 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53573 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCPrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:47:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 59BD0D41;
        Tue,  3 Nov 2020 10:47:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/DL5YX
        QiGJkOtlnsxtYx9lbnbWcu0TUxdn7oXc5YzkU=; b=VPH32HJ4aBcQbSGTFzyRwn
        0bZgjOXmJIfCkCz3DC9wqS1HIlIsc8wvhgJsixvxp+giLpwoV+Z3UMIxJl+SmvvD
        38HNtEqxGGj98WUbMhothhGOHkRy1a30SmMDLu7xEMIrvV5Y6cRIP5XgTUgFBVM2
        UnexnvybEOFOp8VWa0d1lIlofR6dpb0MLZFmgS57TeSB9u9gznEci7ScSQkUMUqM
        oe/RzkQhiw0SSY8Al95RiKTDdn7JBVnF7wDqhkvEg+LKDt8h7HG+Ft50rOo+V0Vg
        jE+hzpObIotWabv8SWYnxuxSQKryXYYYbRybduzOr9mbZ12n9LIydyEefSz/+FKA
        ==
X-ME-Sender: <xms:fXuhX6RJ8Nqj2GcPabRRRXHs9klqM-u-aXxDpo-xLE026r0Zkh-jdQ>
    <xme:fXuhX_zOnn0Cp4hr9GkB1kazy53dZSsy0Gs8vcYUXJ7Dks6oZ0KNkC0ymdiNtmUQn
    0hcglg7_8g5Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:fXuhX33hRHq8S90qBPYEobWFfQ__ah9YTap_gzL0yJNp7xLVY8yl7A>
    <xmx:fXuhX2C8CXwDljmzHDwbz-qXu1BYAUjjNMcRAj9KDWcy09pkQ3hrPQ>
    <xmx:fXuhXzg5J7QmmR6Zx86F4wbc6YFrQEN1EpGI6vCCJVSRd-XhEjhXjg>
    <xmx:fnuhX7bzd_6hbb3Za6rnvc-JQ0iQUGPYfWQSU4ZFTLlmONlNeWYCZDH0r1M>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A05A3280068;
        Tue,  3 Nov 2020 10:47:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/swsmu: add missing feature map for sienna_cichlid" failed to apply to 5.9-stable tree
To:     kevin1.wang@amd.com, Likun.Gao@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:48:03 +0100
Message-ID: <160441848368154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d48d7484d8dca1d4577fc53f1f826e68420d00eb Mon Sep 17 00:00:00 2001
From: Kevin Wang <kevin1.wang@amd.com>
Date: Fri, 16 Oct 2020 11:07:47 +0800
Subject: [PATCH] drm/amd/swsmu: add missing feature map for sienna_cichlid

it will cause smu sysfs node of "pp_features" show error.

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x

diff --git a/drivers/gpu/drm/amd/pm/inc/smu_types.h b/drivers/gpu/drm/amd/pm/inc/smu_types.h
index 35fc46d3c9c0..cbf4a58b77d9 100644
--- a/drivers/gpu/drm/amd/pm/inc/smu_types.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu_types.h
@@ -220,6 +220,7 @@ enum smu_clk_type {
        __SMU_DUMMY_MAP(DPM_MP0CLK),                    	\
        __SMU_DUMMY_MAP(DPM_LINK),                      	\
        __SMU_DUMMY_MAP(DPM_DCEFCLK),                   	\
+       __SMU_DUMMY_MAP(DPM_XGMI),			\
        __SMU_DUMMY_MAP(DS_GFXCLK),                     	\
        __SMU_DUMMY_MAP(DS_SOCCLK),                     	\
        __SMU_DUMMY_MAP(DS_LCLK),                       	\
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index c27806fd07e0..ca2abb2e5340 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -151,14 +151,17 @@ static struct cmn2asic_mapping sienna_cichlid_feature_mask_map[SMU_FEATURE_COUNT
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

