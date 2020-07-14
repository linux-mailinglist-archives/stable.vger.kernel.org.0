Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE0C21F368
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGNOC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:02:26 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41349 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgGNOC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 10:02:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 35ADA8CB7;
        Tue, 14 Jul 2020 10:02:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Jul 2020 10:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VBRsi1
        ps2b0uW5blLTijVNr1H6cbvziozMpuawwoFs4=; b=LTi3v5+UthIsILLlio3Pgg
        o+wag/RE98AwLtkB7N14lVhvySpT9ICpVhgsv+mJmGjCbY9Rt/1aso+sfuYVZYwO
        8hIyd93ZdxjqJZiczIEpz7vdylmH9YJZkkO7iZYLc6krHNDNJO1mdM1hnkPZS1I6
        Lu5GNQT0Arj/Asi1ZnbLl63aDIjwmcF+L0K6XCrJBAWrF6Z2+NErwI1EHPCWGIOq
        xN3YPW532XPN+4UbUGnQ8hfT4RAdnT0f/B/yy8kjMBe9H8YavfXaK7BDg0RWBGHS
        piTfOY0YTowwgUFvVHfLsX5pRTeYzaM/sE6wW+tjcWej+Zp/9r9aPdcp/k7BjhXA
        ==
X-ME-Sender: <xms:77oNX_lAEbSUmxFJHHFBvYrHlNYlvyY2GMHJqA11qGlyW-ynSvvpHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:77oNXy18OkcOJ2PDkhe8-ts5wlyXyybhVTCe8Swjp-XxwwZAcN8dmQ>
    <xmx:77oNX1qlU1aMLkNp9Hq_x85hBgR2RIKgb2KpXCpI4KWf5yRrUb56Jg>
    <xmx:77oNX3mvB6gGwQAcY_EX-fNZfWr6Ie8BsFP1yEHK0YLjx33q8hKtmQ>
    <xmx:8LoNX69Tygjg2B6UprjixPi1ZyWqQQ-wFsmt3iGuHZxmVlQyFXKwGCPREhc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 380C6328005E;
        Tue, 14 Jul 2020 10:02:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: add dmcub check on RENOIR" failed to apply to 5.7-stable tree
To:     aaron.ma@canonical.com, alexander.deucher@amd.com,
        nicholas.kazlauskas@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Jul 2020 16:02:22 +0200
Message-ID: <159473534271190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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

