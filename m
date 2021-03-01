Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9404327B90
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhCAKHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:07:12 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:44571 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231129AbhCAKGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:06:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id ACDBE1940B25;
        Mon,  1 Mar 2021 05:05:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6FCuE+
        e/dLyXEO7p8o59A1qMTn+B1jzY9cCzI6LXO/o=; b=dEtEw9r5HwhdAoa601I7/L
        PKn88oi/n2cfL2s811JLX/3mgEQb8Ao5yvX+QzoUGnmmmfw6qMbdCHSOEhsuOvaH
        TS2h1p4VvuTw1r6rSbgJkmn5jsakTzL9GUr13IMuqt+Sk3Gag7nsjObQnul+DanB
        QbtoevkdRDgBTLVyMi/qFWEiBs4z45SUnyyrc83eEBF6Fg5qKGQBtPnlOtfPJAVp
        hhmHi7pNqsJiopXOzDNLFYgMvUMC+sznsls3YE0t/ox7PUjx3nluOizhHOZZAzy2
        FFYr+8thGy9OGWlCUHOlAUP6myf5qBk0Do26jxYPCBPFChVt5VXeBgZm57nLHf9w
        ==
X-ME-Sender: <xms:T7w8YHhLCfVZ4MJqtvTx4B-B8Mn-TAQZPbGuROl0AWixrpA-QyW9DQ>
    <xme:T7w8YEAOWZmUDT7f2hjO0G0ftiVo-cSeps_-qJ15gLqCRjz49E-F0tvlFZrwH2Nc-
    6nEy4jEbHtk0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:T7w8YHHpGOgZwNGj1fo771ae-TzG1fZag1yeqbmS9tbs2IYGe3EGgQ>
    <xmx:T7w8YERXZqta3yvHCCLJ4RJ6vzIjuDB9PuB0Zken8MwCstqToXMnEg>
    <xmx:T7w8YEwE7pORDaAtOGw9UBJ6kDzTXCmvxSxjTy0fq0C5PLEUld_kKA>
    <xmx:T7w8YKZj1XjpEdgVGixojVI6CzJdxwXmDyabl9dyRciNMY_ac4HrXw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E9051080068;
        Mon,  1 Mar 2021 05:05:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix DRM_INFO flood if display core is not" failed to apply to 5.10-stable tree
To:     alexandre.f.demers@gmail.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:05:01 +0100
Message-ID: <161459310112020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 044a48f420b9d3c19a135b821c34de5b2bee4075 Mon Sep 17 00:00:00 2001
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Date: Thu, 7 Jan 2021 18:53:03 -0500
Subject: [PATCH] drm/amdgpu: fix DRM_INFO flood if display core is not
 supported (bug 210921)

This fix bug 210921 where DRM_INFO floods log when hitting an unsupported ASIC in
amdgpu_device_asic_has_dc_support(). This info should be only called once.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=210921
Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b69c34074d8d..087afab67e22 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3034,7 +3034,7 @@ bool amdgpu_device_asic_has_dc_support(enum amd_asic_type asic_type)
 #endif
 	default:
 		if (amdgpu_dc > 0)
-			DRM_INFO("Display Core has been requested via kernel parameter "
+			DRM_INFO_ONCE("Display Core has been requested via kernel parameter "
 					 "but isn't supported by ASIC, ignoring\n");
 		return false;
 	}

