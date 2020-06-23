Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842F5206581
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388217AbgFWUEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387699AbgFWUEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293BE2082F;
        Tue, 23 Jun 2020 20:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942670;
        bh=8/pXT+CdqlF/Ij3YUpTLBMYKt/T67s2YJK6t2h09dJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6ppAVP/plVcwN5hBKwxYn5OwjydHhUNVsAly6+Rj9ivStJPec4E/gADVh2tIO9io
         21LumUegd1EnzJ4Phfe0BD7LmHcxaGY5XCvdGCduD2MIow3zhAcPt+GldOswDH5Xl3
         DRteKtEc/V+zEKwASBfUyz9bWa2m56pHp4ywaAdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 089/477] drm/nouveau: gr/gk20a: Use firmware version 0
Date:   Tue, 23 Jun 2020 21:51:26 +0200
Message-Id: <20200623195411.812334847@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4209b24a46d70..bf6b65257852f 100644
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



