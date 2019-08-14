Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81C78DB8E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfHNREz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbfHNREy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF56B216F4;
        Wed, 14 Aug 2019 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802294;
        bh=Mx1n58CaDnbSfPiqZmPvIquoDq/LKIQCovOJI5KLmzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYvrwGwJUCjBzTnH14pga+Y8w9+Z78anhW8nb0gY+v9SZ6H5plRi8xlYSsOy7NdnN
         DhGDH7v13BcIscewe1OvknkwNwGqksH3c0SdxuwtSrTroceyM4LJkfR8/FsJlg9wW3
         spIohmeFyCQsbWGkAxnypOrRj93qkNv5Y7zzGfiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Lai <Derek.Lai@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 070/144] drm/amd/display: allocate 4 ddc engines for RV2
Date:   Wed, 14 Aug 2019 19:00:26 +0200
Message-Id: <20190814165802.782267695@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 67fd6c0d2de8e51e84ff3fa6e68bbd524f823e49 ]

[Why]
Driver will create 0, 1, and 2 ddc engines for RV2,
but some platforms used 0, 1, and 3.

[How]
Still allocate 4 ddc engines for RV2.

Signed-off-by: Derek Lai <Derek.Lai@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
index 7eccb54c421d9..aac52eed6b2aa 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
@@ -512,7 +512,7 @@ static const struct resource_caps rv2_res_cap = {
 		.num_audio = 3,
 		.num_stream_encoder = 3,
 		.num_pll = 3,
-		.num_ddc = 3,
+		.num_ddc = 4,
 };
 #endif
 
-- 
2.20.1



