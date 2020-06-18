Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE21FE863
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgFRBKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbgFRBKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8087D21D7F;
        Thu, 18 Jun 2020 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442604;
        bh=1p00aoausvI7CY8T2tlD9dohrS4bq5WWZoQAj/k6VEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgZruJbuUf1v7aC5/in1H7GvAUil4+TwMhg9Aalc7yKAomlRqL4BC0uv5QLB/KI15
         1wrcTyWzAin/gGk6ZMAc2AYZpNxAwVqJOVSCLLZclXK3dt3HxNph9hWT3LzIFm3+Xa
         jyIcoWhwXPBSUYahiDmHsR82nc9hQEl0dv5z8rAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 090/388] drm/nouveau: gr/gk20a: Use firmware version 0
Date:   Wed, 17 Jun 2020 21:03:07 -0400
Message-Id: <20200618010805.600873-90-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 21454fe697fde188ad6fb541f94b9838fa73ab38 ]

Tegra firmware doesn't actually use any version numbers and passing -1
causes the existing firmware binaries not to be found. Use version 0 to
find the correct files.

Fixes: ef16dc278ec2 ("drm/nouveau/gr/gf100-: select implementation based on available FW")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c
index 4209b24a46d7..bf6b65257852 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c
@@ -341,7 +341,7 @@ gk20a_gr_load(struct gf100_gr *gr, int ver, const struct gf100_gr_fwif *fwif)
 
 static const struct gf100_gr_fwif
 gk20a_gr_fwif[] = {
-	{ -1, gk20a_gr_load, &gk20a_gr },
+	{ 0, gk20a_gr_load, &gk20a_gr },
 	{}
 };
 
-- 
2.25.1

