Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8496C312F5A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhBHKpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:45:07 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51483 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232655AbhBHKnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:43:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A5BA894F;
        Mon,  8 Feb 2021 05:41:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:41:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=G2iE2F
        WGpnPJlDy1n8AKPAAlmKDpmnfXADnneNjUjsk=; b=DiCtfgUDWS7nseZ3R5noPH
        hXqXp8kCZl2nmSheAirfXe8tortqwGigRltZFCwT8PFFIILCErOGmar0mQ8gIpgX
        2ayMrQCG0wD9FKuvcAcoaAnvQNH3MTs3WtH8ZU+otw+fxQ0SHjaL2nxIFjClqU2U
        8CK7hIQJDpxr3PyCl9vWvnMj7lhVekqmyOiizK1HQwIYPhlif+vHwHNxGpuAJrAv
        zG0SKq5HFIJad1VpsT4bOb1G3j4eqnMVObR6S0+KXiJTbBFlvh0J04ZKq4eSFL8i
        1YWe6MHZ01LLin7FBKGUe1xpqNtRDal/D2kxCMZgh7R+xGAiSN2pDr3GyHjGcvYA
        ==
X-ME-Sender: <xms:bhUhYJYGE8mqDLZAaRF85iyoF3JiV8eCWHZ_1Mg9iTCj7WK3EQ4yGw>
    <xme:bhUhYAauQiMyuwDjW1F7gvE0HDyCYYImD1hSDG8A9LtYySumU-ADr6_0WFcAukNE7
    uA4bUvXLdjjhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedthffhjeegheekhfetkeevgeefudegiedttdeugfeuve
    ehvdevkeettdeukefhteenucffohhmrghinhepsggrshgvrdgsohenucfkphepkeefrdek
    iedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bhUhYL_UpYQh1BCzbCjZfWhePCcuDwZxG_C31mWb5gm90x0I6ZRtVg>
    <xmx:bhUhYHqbtn796ZYyZACpU7ob0nElAXuECsSi84ExANuqDDkHjMS5Fw>
    <xmx:bhUhYEqTK2C8orEX8Hfb3flmjBkAvyOIgh_hAE1bsZ4-MUD42dFVHg>
    <xmx:bhUhYBDcExp7IupFMpEd6vKms4AzEEsFjUf6lLN4LFDmvNqFI5Y3uKfA_zY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DCD7024005D;
        Mon,  8 Feb 2021 05:41:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix the issue that retry constantly once the" failed to apply to 5.10-stable tree
To:     ray.huang@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:41:47 +0100
Message-ID: <161278090720449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 89fa15ecdca7eb46a711476b961f70a74765bbe4 Mon Sep 17 00:00:00 2001
From: Huang Rui <ray.huang@amd.com>
Date: Sat, 30 Jan 2021 17:14:30 +0800
Subject: [PATCH] drm/amdgpu: fix the issue that retry constantly once the
 buffer is oversize
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We cannot modify initial_domain every time while the retry starts. That
will cause the busy waiting that unable to switch to GTT while the vram
is not enough.

Fixes: f8aab60422c3 ("drm/amdgpu: Initialise drm_gem_object_funcs for imported BOs")

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index d0a1fee1f5f6..174a73eb23f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -269,8 +269,8 @@ int amdgpu_gem_create_ioctl(struct drm_device *dev, void *data,
 		resv = vm->root.base.bo->tbo.base.resv;
 	}
 
-retry:
 	initial_domain = (u32)(0xffffffff & args->in.domains);
+retry:
 	r = amdgpu_gem_object_create(adev, size, args->in.alignment,
 				     initial_domain,
 				     flags, ttm_bo_type_device, resv, &gobj);

