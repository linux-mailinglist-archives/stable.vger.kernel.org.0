Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9940721F369
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGNOCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:02:33 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:58137 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgGNOCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 10:02:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 6144C9AE5;
        Tue, 14 Jul 2020 10:02:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Jul 2020 10:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8O/VVw
        9z3H5OFgbjRd+tLf3o2F5nVKNiM15dYrKIXio=; b=UsZkwpLQ6XFyUsa0QxXCr7
        Gzfo6U/wB10RQaCo4nfw+D6aD2S7sEpV8EavrIE0dEO7SjyXxBQtCm8TIh0q+gCO
        ttIz1V17/EH5F5dmWchZv0a4VsmhMlu+LuAnBoXKp1QTLhYrNvFdMVXG+xq7M77E
        iha8vbnY40hTENIsYrwmkC6vRmS7IjTPfGIW+P7H2kxkYfhUhefdT3PAQpOT/arW
        qt2EEx7Zr4gBEouoS+Yf9zybBe756mu9p6UzkLeW5tn4tIRJWML2cTMDDOEW+mkW
        jswkF/tWkVchvnrVH16f4cwRbJjadARoU3zegbvvRUHTEcTweRPjvDkRuk7xbGnA
        ==
X-ME-Sender: <xms:97oNX-kLfV_4KyxOKU23pIX9oS7J0CgayLwI-UdtI7eAf0d8oi7euw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:97oNX12Es1Fqx0EE9R4FgzZ2SrbiPKLdo2-TWxODGhFLuXasOZBljg>
    <xmx:97oNX8pBd7V9WdTzsSXC1-QvvMF3YpFcESxeEIXGxS4AfRmectkn_g>
    <xmx:97oNXynr_X-214UK_yizHG-Okrwa-5DjTB6ROD0w2Yd6-rEGaJYwqQ>
    <xmx:-LoNXx8Ou5aASMR_Fq0PxUxJN7IsV-tk9zRw-0oZZD6i1G6-azkTSmLwFL0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E1E030600A3;
        Tue, 14 Jul 2020 10:02:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: add dmcub check on RENOIR" failed to apply to 5.4-stable tree
To:     aaron.ma@canonical.com, alexander.deucher@amd.com,
        nicholas.kazlauskas@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Jul 2020 16:02:22 +0200
Message-ID: <159473534221103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b2e973dff59d88bee1d814ddf8762a24fc02b60 Mon Sep 17 00:00:00 2001
From: Aaron Ma <aaron.ma@canonical.com>
Date: Wed, 8 Jul 2020 04:16:22 -0400
Subject: [PATCH] drm/amd/display: add dmcub check on RENOIR

RENOIR loads dmub fw not dmcu, check dmcu only will prevent loading iram,
it breaks backlight control.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=208277
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 10ac8076d4f2..db5e0bb0d935 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1358,7 +1358,7 @@ static int dm_late_init(void *handle)
 	struct dmcu *dmcu = NULL;
 	bool ret;
 
-	if (!adev->dm.fw_dmcu)
+	if (!adev->dm.fw_dmcu && !adev->dm.dmub_fw)
 		return detect_mst_link_for_all_connectors(adev->ddev);
 
 	dmcu = adev->dm.dc->res_pool->dmcu;

